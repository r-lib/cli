
#include "cli.h"
#include "errors.h"
#include "cleancall.h"

#include <string.h>
#include <stdlib.h>

/* ---------------------------------------------------------------------- */

#define BUFFER_SIZE 4096

static char static_buffer[BUFFER_SIZE];

struct cli_buffer {
  char *buf;
  char *ptr;
  size_t size;
};

static void clic__buffer_init(struct cli_buffer *buf);
static void clic__buffer_free(struct cli_buffer *buf);
static void clic__buffer_reset(struct cli_buffer *buf);
static inline char *clic__buffer_get(struct cli_buffer *buf);
static inline size_t clic__buffer_size(struct cli_buffer *buf);
static inline void clic__buffer_push_str(struct cli_buffer *buf,
                                         const char *str);
/* static inline void clic__buffer_push_str_len(struct cli_buffer *buf, */
/*                                              const char *str, */
/*                                              size_t len); */
static inline void clic__buffer_push_piece(struct cli_buffer *buf,
                                           const char *from,
                                           const char *to);
static void clic__buffer_realloc(struct cli_buffer *buf, size_t size);
static void clic__buffer_checklen(struct cli_buffer *buf, size_t len);

static void clic__buffer_init(struct cli_buffer *buf) {
  buf->buf = static_buffer;
  buf->ptr = static_buffer;
  buf->size = sizeof(static_buffer);
}

static void clic__buffer_reset(struct cli_buffer *buf) {
  buf->ptr = buf->buf;
}

static inline char *clic__buffer_get(struct cli_buffer *buf) {
  return buf->buf;
}

static inline size_t clic__buffer_size(struct cli_buffer *buf) {
  return buf->ptr - buf->buf;
}

static void clic__buffer_free(struct cli_buffer *buf) {
  if (buf->buf != static_buffer) free(buf->buf);
}

static inline void clic__buffer_push_str(struct cli_buffer *buf,
                                         const char *str) {
  clic__buffer_checklen(buf, strlen(str));
  buf->ptr = stpcpy(buf->ptr, str);
}

/* static inline void clic__buffer_push_str_len(struct cli_buffer *buf, */
/*                                              const char *str, */
/*                                              size_t len) { */
/*   clic__buffer_checklen(buf, len); */
/*   memcpy(buf->ptr, str, len); */
/*   buf->ptr += len; */
/* } */

static inline void clic__buffer_push_piece(struct cli_buffer *buf,
                                           const char *from,
                                           const char *to) {
  size_t len = to - from;
  clic__buffer_checklen(buf, len);
  memcpy(buf->ptr, from, len);
  buf->ptr += len;
}

static void clic__buffer_realloc(struct cli_buffer *buf, size_t size) {
  size_t current = buf->ptr - buf->buf;
  char *old = buf->buf;
  buf->size = size;
  if (buf->buf == static_buffer) {
    buf->buf = malloc(size);
    if (!buf->buf) R_THROW_SYSTEM_ERROR("ANSI string error");
    memcpy(buf->buf, old, current);
  } else {
    buf->buf = realloc(buf->buf, size);
    if (!buf->buf) R_THROW_SYSTEM_ERROR("ANSI string error");
  }
  buf->ptr = buf->buf + current;
}

 static void clic__buffer_checklen(struct cli_buffer *buf, size_t len) {

  if (buf->ptr + len >= buf->buf + buf->size) {
    size_t current = buf->ptr - buf->buf;
    size_t prop = buf->size * 2;
    if (prop < current + len) prop = current + len;
    clic__buffer_realloc(buf, prop);
  }
}

/* ---------------------------------------------------------------------- */

#define CLI_COL_256 9
#define CLI_COL_RGB 10

struct cli_color {
  char col;                   /* 1-8, 0 off, 9 is 8 bit, 10 is 24 bit */
  unsigned char r, g, b;
};

#define DIFFERENT_COLOR(c1,c2) memcmp(&(c1), &(c2), sizeof(struct cli_color))

struct cli_sgr_state {
  struct cli_color fg;
  struct cli_color bg;
  char bold;
  char faint;
  char italic;
  char underline;
  char blink;
  char inverse;
  char hide;
  char crossedout;
};

struct cli_ansi_state {
  struct cli_sgr_state old;
  struct cli_sgr_state new;
  char off;                     /* TODO: can we handle this better? */
};

static void clic__parse_color(const char *txt, struct cli_color *col) {
  /* This can be:
   * - 5;<n>
   * - 2;<r>;<g>;<b>
   * TODO: handle empty paramters, which should be zero
   */

  col->r = col->g = col->b = 0;

  if (*txt != ';') return;
  txt++;

  if (*txt == '5') {
    col->col = CLI_COL_256;
    sscanf(txt, "5;%hhu", &col->r);
  } else if (*txt == '2') {
    col->col = CLI_COL_RGB;
    sscanf(txt, "2;%hhu;%hhu;%hhu", &col->r, &col->g, &col->b);
  }
}

static void clic__ansi_update_state(const char *param,
                                    const char *intermed,
                                    const char *end,
                                    struct cli_buffer *buffer,
                                    struct cli_ansi_state *state) {
  char *endptr;
  long num = strtol(param, &endptr, 10);
  if (endptr == param && num == 0) {
    state->off = 1;
    memset(&state->new, 0, sizeof(state->new));

  } else if (num == 1) {
    state->new.bold = 1;

  } else if (num == 2) {
    state->new.faint = 1;

  } else if (num == 3) {
    state->new.italic = 1;

  } else if (num == 4) {
    state->new.underline = 1;

  } else if (num == 5) {
    state->new.blink = 1;

  } else if (num == 7) {
    state->new.inverse = 1;

  } else if (num == 8) {
    state->new.hide = 1;

  } else if (num == 9) {
    state->new.crossedout = 1;

  } else if (num == 22) {
    state->new.bold = state->new.faint = 0;

  } else if (num == 23) {
    state->new.italic = 0;

  } else if (num == 24) {
    state->new.underline = 0;

  } else if (num == 25) {
    state->new.blink = 0;

  } else if (num == 27) {
    state->new.inverse = 0;

  } else if (num == 28) {
    state->new.hide = 0;

  } else if (num == 29) {
    state->new.crossedout = 0;

  } else if (num >= 30 && num <= 37) {
    state->new.fg.col = num - 30 + 1;

  } else if (num == 38) {
    clic__parse_color(endptr, &state->new.fg);

  } else if (num == 39) {
    state->new.fg.col = 0;

  } else if (num >= 40 && num <= 47) {
    state->new.bg.col = num - 40 + 1;

  } else if (num == 48) {
    clic__parse_color(endptr, &state->new.bg);

  } else if (num == 49) {
    state->new.bg.col = 0;

  } else {
    /* Keep tag as is, and emit it right away */
    clic__buffer_push_piece(buffer, param - 2, end);
  }
}

#define EMIT(s) clic__buffer_push_str(buffer, "\033[" s "m")
#define EMITS(s) clic__buffer_push_str(buffer, (s))

static void clic__state_update_buffer(struct cli_buffer *buffer,
                                      struct cli_ansi_state *state) {

  /* TODO: better 0 handling */
  /* TODO: 22 turns off two bits */

  char col[20];

  if (state->off) {
    EMIT("0");
  }

  if (state->new.bold > state->old.bold) {
    EMIT("1");
  } else if (state->new.bold < state->old.bold) {
    EMIT("22");
  }

  if (state->new.faint > state->old.faint) {
    EMIT("2");
  } else if (state->new.faint < state->old.faint) {
    EMIT("22");
  }

  if (state->new.italic > state->old.italic) {
    EMIT("3");
  } else if (state->new.italic < state->old.italic) {
    EMIT("23");
  }

  if (state->new.underline > state->old.underline) {
    EMIT("4");
  } else if (state->new.underline < state->old.underline) {
    EMIT("24");
  }

  if (state->new.blink > state->old.blink) {
    EMIT("5");
  } else if (state->new.blink < state->old.blink) {
    EMIT("25");
  }

  if (state->new.inverse > state->old.inverse) {
    EMIT("7");
  } else if (state->new.inverse < state->old.inverse) {
    EMIT("27");
  }

  if (state->new.hide > state->old.hide) {
    EMIT("8");
  } else if (state->new.hide < state->old.hide) {
    EMIT("28");
  }

  if (state->new.crossedout > state->old.crossedout) {
    EMIT("9");
  } else if (state->new.crossedout < state->old.crossedout) {
    EMIT("29");
  }

  if (state->new.bold > state->old.bold) {
    EMIT("1");
  } else if (state->new.bold < state->old.bold) {
    EMIT("22");
  }

  if (state->new.fg.col == 0 && state->old.fg.col != 0) {
    EMIT("39");
  } else if (DIFFERENT_COLOR(state->new.fg, state->old.fg)) {
    if (state->new.fg.col == CLI_COL_256) {
      snprintf(col, sizeof(col), "\033[38;5;%um", state->new.fg.r);
    } else if (state->new.fg.col == CLI_COL_RGB) {
      snprintf(col, sizeof(col), "\033[38;2;%u;%u;%um",
               state->new.fg.r, state->new.fg.g, state->new.fg.b);
    } else {
      snprintf(col, sizeof(col), "\033[%um", state->new.fg.col + 29);
    }
    EMITS(col);
  }

  if (state->new.bg.col == 0 && state->old.bg.col != 0) {
    EMIT("49");
  } else if (DIFFERENT_COLOR(state->new.bg, state->old.bg)) {
    if (state->new.bg.col == CLI_COL_256) {
      snprintf(col, sizeof(col), "\033[48;5;%um", state->new.bg.r);
    } else if (state->new.bg.col == CLI_COL_RGB) {
      snprintf(col, sizeof(col), "\033[48;2;%u;%u;%um",
               state->new.bg.r, state->new.bg.g, state->new.bg.b);
    } else {
      snprintf(col, sizeof(col), "\033[%um", state->new.bg.col + 39);
    }
    EMITS(col);
  }

  state->off = 0;
  state->old = state->new;
}

typedef void (*clic__start_callback_t)(const char *str,
                                       void *data);
typedef void (*clic__tag_callback_t)(const char *param,
                                     const char *intermed,
                                     const char *end,
                                     void *data);
typedef void (*clic__text_callback_t)(const char *str,
                                      const char *end,
                                      void *data);
typedef void (*clic__end_callback_t)(SEXP rstr,
                                     const char *str,
                                     void *data);

void clic__ansi_iterator(SEXP sx,
                         clic__start_callback_t start_cb,
                         clic__tag_callback_t tag_cb,
                         clic__text_callback_t text_cb,
                         clic__end_callback_t end_cb,
                         void *data) {

  R_xlen_t i, len = XLENGTH(sx);
  for (i = 0; i < len; i++) {
    SEXP str = STRING_ELT(sx, i);
    const char *ox = CHAR(str);
    const char *x = ox;
    const char *shaft = ox;
    const char *s_start;
    const char *s_param;
    const char *s_intermed;
    const char *s_end;

    if (start_cb) start_cb(ox, data);

    while (*x != 0) {
      if (*x == '\033' && *(x + 1) == '[') {
        s_start = x;
        s_param = s_intermed = x + 2;
        while (*s_intermed >= 0x30 && *s_intermed <= 0x3f) s_intermed++;
        s_end = s_intermed;
        while (*s_end >= 0x20 && *s_end <= 0x2f) s_end++;
        if (*s_end >= 0x40 && *s_end <= 0x7e) {
          if (s_start > shaft && text_cb) text_cb(shaft, s_start, data);
          if (tag_cb) tag_cb(s_param, s_intermed, s_end, data);
          x = shaft = s_end + 1;
        }
        x = *s_end ? s_end + 1 : s_end;
      } else {
        x++;
      }
    }

    if (x > shaft && text_cb) text_cb(shaft, x, data);

    if (end_cb) end_cb(str, ox, data);
  }
}

struct simplify_data {
  struct cli_ansi_state state;
  struct cli_buffer buffer;
  const char *str;
  R_xlen_t done;
  size_t num_tags;
  SEXP result;
};

static void simplify_cb_start(const char *str, void *vdata) {
  struct simplify_data *data = vdata;
  data->str = str;
  data->num_tags = 0;
  clic__buffer_reset(&data->buffer);
}

static void simplify_cb_tag(const char *param,
                            const char *intermed,
                            const char *end,
                            void *vdata) {
  struct simplify_data *data = vdata;
  data->num_tags ++;
  clic__ansi_update_state(param, intermed, end, &data->buffer, &data->state);
}

static void simplify_cb_text(const char *str,
                             const char *end,
                             void *vdata) {
  struct simplify_data *data = vdata;
  clic__state_update_buffer(&data->buffer, &data->state);
  clic__buffer_push_piece(&data->buffer, str, end);
}

static void simplify_cb_end(SEXP rstr,
                            const char *str,
                            void *vdata) {
  struct simplify_data *data = vdata;
  clic__state_update_buffer(&data->buffer, &data->state);
  if (data->num_tags == 0) {
    SET_STRING_ELT(data->result, data->done, rstr);

  } else {
    SET_STRING_ELT(
      data->result,
      data->done,
      Rf_mkCharLenCE(
        clic__buffer_get(&data->buffer),
        clic__buffer_size(&data->buffer),
        CE_NATIVE
      )
    );
  }

  data->done ++;
}

SEXP clic_ansi_simplify(SEXP sx) {
  struct simplify_data data;
  memset(&data.state, 0, sizeof(data.state));
  clic__buffer_init(&data.buffer);
  data.done = 0;
  data.result = PROTECT(allocVector(STRSXP, XLENGTH(sx)));

  clic__ansi_iterator(
    sx,
    simplify_cb_start,
    simplify_cb_tag,
    simplify_cb_text,
    simplify_cb_end, &data
  );

  clic__buffer_free(&data.buffer);

  UNPROTECT(1);
  return data.result;
}
