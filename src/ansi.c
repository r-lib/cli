
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

static void clic__parse_color(char **ptr, const char *end, struct cli_color *col) {
  /* This can be:
   * - 5;<n>
   * - 2;<r>;<g>;<b>
   * TODO: handle empty paramters, which should be zero
   */

  char *txt = *ptr;

  col->r = col->g = col->b = 0;

  if (*txt != ';') return;
  txt++;

  char backup = *end;
  char *end2 = (char*) end;
  *end2 = '\0';
  int len = -1, ret = -1;

  unsigned int r = 0, g = 0, b = 0;

  if (*txt == '5' && *(txt + 1) == ';') {
    col->col = CLI_COL_256;
    ret = sscanf(txt, "5;%u%n", &r, &len);
    col->r = (unsigned char) r;
  } else if (*txt == '2' && *(txt + 1) == ';') {
    col->col = CLI_COL_RGB;
    ret = sscanf(txt, "2;%u;%u;%u%n", &r, &g, &b, &len);
    col->r = (unsigned char) r;
    col->g = (unsigned char) g;
    col->b = (unsigned char) b;
  }

  if (ret == -1) {
    /* unknown tag, we'll ignore the whole tag */
    *ptr = (char *) end;

  } else if (len == -1) {
    /* invalid or empty tag, we set missing colors to zero */
    if (*txt == '5') {
      txt += 2;
      /* we drop the parameter, whatever it is */
      while (txt < end && *txt != ';') txt++;
    } else if (*txt == '2') {
      txt += 2;
      /* we drop three parameters */
      while (txt < end && *txt != ';') txt++;
      if (*txt == ';') txt++;
      while (txt < end && *txt != ';') txt++;
      if (*txt == ';') txt++;
      while (txt < end && *txt != ';') txt++;
    }
    *ptr = txt;

  } else {
    /* everything is fine, correct tag */
    *ptr += len + 1;
  }

  *end2 = backup;
}

static void clic__ansi_update_state(const char *param,
                                    const char *intermed,
                                    const char *end,
                                    struct cli_buffer *buffer,
                                    struct cli_ansi_state *state) {

  char *startptr = (char*) param, *endptr;
  do {
    long num = strtol(startptr, &endptr, 10);
    if (endptr == startptr || num == 0) {
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
      clic__parse_color(&endptr, intermed, &state->new.fg);

    } else if (num == 39) {
      state->new.fg.col = 0;

    } else if (num >= 40 && num <= 47) {
      state->new.bg.col = num - 40 + 1;

    } else if (num == 48) {
      clic__parse_color(&endptr, intermed, &state->new.bg);

    } else if (num == 49) {
      state->new.bg.col = 0;

    } else {
      /* Keep tag as is, and emit it right away */
      clic__buffer_push_piece(buffer, param - 2, end);
    }

    /* The next attribute, if any */
    startptr = endptr + 1;
  } while (endptr < intermed && *endptr == ';');
}

#define EMIT(s) clic__buffer_push_str(buffer, "\033[" s "m")
#define EMITS(s) clic__buffer_push_str(buffer, (s))

static void clic__state_update_buffer(struct cli_buffer *buffer,
                                      struct cli_ansi_state *state) {

  char col[20];

  /* TODO: handle this better */
  if (state->off) {
    EMIT("0");
  }

  if (state->new.bold > state->old.bold) {
    EMIT("1");
  } else if (state->new.bold < state->old.bold) {
    /* This also closes faint, so don't close that again. */
    if (state->new.faint < state->old.faint) {
      state->new.faint = state->old.faint;
    }
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

typedef int (*clic__start_callback_t)(const char *str,
                                      void *data);
typedef int (*clic__tag_callback_t)(const char *param,
                                   const char *intermed,
                                   const char *end,
                                   void *data);
typedef int (*clic__text_callback_t)(const char *str,
                                      const char *end,
                                      void *data);
typedef int (*clic__end_callback_t)(SEXP rstr,
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

    if (start_cb) if (start_cb(ox, data)) goto end;

    while (*x != 0) {
      if (*x == '\033' && *(x + 1) == '[') {
        s_start = x;
        s_param = s_intermed = x + 2;
        while (*s_intermed >= 0x30 && *s_intermed <= 0x3f) s_intermed++;
        s_end = s_intermed;
        while (*s_end >= 0x20 && *s_end <= 0x2f) s_end++;
        if (*s_end == 'm') {
          if (s_start > shaft && text_cb) {
            if (text_cb(shaft, s_start, data)) goto end;
          }
          if (tag_cb) {
            if (tag_cb(s_param, s_intermed, s_end, data)) goto end;
          }
          x = shaft = s_end + 1;
        }
        x = *s_end ? s_end + 1 : s_end;
      } else {
        x++;
      }
    }

    if (x > shaft && text_cb) text_cb(shaft, x, data);

  end:
    if (end_cb) end_cb(str, ox, data);
  }
}

/* ---------------------------------------------------------------------- */

struct simplify_data {
  struct cli_ansi_state state;
  struct cli_buffer buffer;
  const char *str;
  R_xlen_t done;
  size_t num_tags;
  SEXP result;
};

static int simplify_cb_start(const char *str, void *vdata) {
  struct simplify_data *data = vdata;
  data->str = str;
  data->num_tags = 0;
  clic__buffer_reset(&data->buffer);
  return 0;
}

static int simplify_cb_tag(const char *param,
                           const char *intermed,
                           const char *end,
                           void *vdata) {
  struct simplify_data *data = vdata;
  data->num_tags ++;
  clic__ansi_update_state(param, intermed, end, &data->buffer, &data->state);
  return 0;
}

static int simplify_cb_text(const char *str,
                            const char *end,
                            void *vdata) {
  struct simplify_data *data = vdata;
  clic__state_update_buffer(&data->buffer, &data->state);
  clic__buffer_push_piece(&data->buffer, str, end);
  return 0;
}

static int simplify_cb_end(SEXP rstr,
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
  return 0;
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
    simplify_cb_end,
    &data
  );

  clic__buffer_free(&data.buffer);

  SEXP ocls = PROTECT(getAttrib(sx, R_ClassSymbol));
  int oclslen = LENGTH(ocls);
  int has_as = Rf_inherits(sx, "ansi_string");
  int has_ch = Rf_inherits(sx, "character");
  int i, j = 0, clslen = oclslen + !has_as + !has_ch;
  SEXP cls = PROTECT(allocVector(STRSXP, clslen));
  if (!has_as) SET_STRING_ELT(cls, j++, mkChar("ansi_string"));
  for (i = 0; i < oclslen; i++) {
    SET_STRING_ELT(cls, j++, STRING_ELT(ocls, i));
  }
  if (!has_ch) SET_STRING_ELT(cls, j++, mkChar("character"));
  setAttrib(data.result, R_ClassSymbol, cls);
  UNPROTECT(3);
  return data.result;
}

/* ---------------------------------------------------------------------- */

struct substr_data {
  struct cli_ansi_state state;
  struct cli_buffer buffer;
  const char *str;
  R_xlen_t done;
  SEXP result;
  int *start;
  int *stop;
  int pos;
};

static int substr_cb_start(const char *str, void *vdata) {
  struct substr_data *data = vdata;
  data->str = str;
  data->pos = 1;
  clic__buffer_reset(&data->buffer);
  return 0;
}

static int substr_cb_tag(const char *param,
                         const char *intermed,
                         const char *end,
                         void *vdata) {
  struct substr_data *data = vdata;
  clic__ansi_update_state(param, intermed, end, &data->buffer, &data->state);
  return 0;
}

static int substr_cb_text(const char *str,
                          const char *end,
                          void *vdata) {
  struct substr_data *data = vdata;
  int start = data->start[data->done];
  int stop = data->stop[data->done];

  /* Skip before start */
  while (data->pos < start && str < end) {
    int len = UTF8LITE_UTF8_TOTAL_LEN(*str);
    str += len;
    data->pos++;
  }

  /* Add before stop */
  const char *from = str;
  while (data->pos <= stop && str < end) {
    int len = UTF8LITE_UTF8_TOTAL_LEN(*str);
    str += len;
    data->pos++;
  }
  if (from < str) {
    clic__state_update_buffer(&data->buffer, &data->state);
    clic__buffer_push_piece(&data->buffer, from, str);
  }

  /* If we are done, then just close all open tags */
  if (data->pos > stop) {
    memset(&data->state.new, 0, sizeof(struct cli_sgr_state));
    clic__state_update_buffer(&data->buffer, &data->state);
    return 1;
  } else {
    return 0;
  }
}

static int substr_cb_end(SEXP rstr,
                         const char *str,
                         void *vdata) {
  struct substr_data *data = vdata;
  clic__state_update_buffer(&data->buffer, &data->state);
  SET_STRING_ELT(
    data->result,
    data->done,
    Rf_mkCharLenCE(
      clic__buffer_get(&data->buffer),
      clic__buffer_size(&data->buffer),
      CE_NATIVE
    )
  );

  data->done++;
  return 0;
}

SEXP clic_ansi_substr(SEXP sx, SEXP start, SEXP stop) {
  struct substr_data data;
  memset(&data.state, 0, sizeof(data.state));
  clic__buffer_init(&data.buffer);
  data.done = 0;
  data.result = PROTECT(allocVector(STRSXP, XLENGTH(sx)));
  data.start = INTEGER(start);
  data.stop = INTEGER(stop);

  clic__ansi_iterator(
    sx,
    substr_cb_start,
    substr_cb_tag,
    substr_cb_text,
    substr_cb_end,
    &data
  );

  clic__buffer_free(&data.buffer);

  SEXP ocls = PROTECT(getAttrib(sx, R_ClassSymbol));
  int oclslen = LENGTH(ocls);
  int has_as = Rf_inherits(sx, "ansi_string");
  int has_ch = Rf_inherits(sx, "character");
  int i, j = 0, clslen = oclslen + !has_as + !has_ch;
  SEXP cls = PROTECT(allocVector(STRSXP, clslen));
  if (!has_as) SET_STRING_ELT(cls, j++, mkChar("ansi_string"));
  for (i = 0; i < oclslen; i++) {
    SET_STRING_ELT(cls, j++, STRING_ELT(ocls, i));
  }
  if (!has_ch) SET_STRING_ELT(cls, j++, mkChar("character"));
  setAttrib(data.result, R_ClassSymbol, cls);
  UNPROTECT(3);
  return data.result;
}

/* ---------------------------------------------------------------------- */
