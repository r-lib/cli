
#include "cli.h"
#include "errors.h"
#include "cleancall.h"

#include <string.h>
#include <stdlib.h>

#define BUFFER_SIZE 4096

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

static inline void check_len(size_t len,
                             char **buffer,
                             char **bptr,
                             size_t *buffer_size) {
  if (*bptr + len >= *buffer + *buffer_size) {
    size_t current = *bptr - *buffer;
    size_t prop = *buffer_size * 2;
    if (prop < current + len) prop = current + len;
    char *old = *buffer;
    if (*buffer_size == BUFFER_SIZE) {
      *buffer_size = prop;
      *buffer = malloc(*buffer_size);
      if (!*buffer) R_THROW_SYSTEM_ERROR("ANSI string error");
      memcpy(*buffer, old, current);
      *bptr = *buffer + current;
    } else {
      *buffer_size = prop;
      *buffer = realloc(*buffer, *buffer_size);
      if (!*buffer) R_THROW_SYSTEM_ERROR("ANSI string error");
      *bptr = *buffer + current;
    }
  }
}

#define EMIT(s) do {                                              \
    check_len(strlen("\033[" s "m"), buffer, bptr, buffer_size);  \
    *bptr = stpcpy(*bptr, "\033[" s "m");                         \
  } while (0);

#define EMITS(s) do {                                             \
    check_len(strlen(s), buffer, bptr, buffer_size);              \
    *bptr = stpcpy(*bptr, s);                                     \
  } while (0);

#define EMITL(from, to) do {                                      \
    size_t len = to - (from) + 1;                                 \
    check_len(len, buffer, bptr, buffer_size);                    \
    memcpy(*bptr, from, len);                                     \
    *bptr += len;                                                 \
  } while (0)

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

static void clic__ansi_process(const char *param,
                               const char *intermed,
                               const char *end,
                               char **buffer,
                               char **bptr,
                               size_t *buffer_size,
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
    EMITL(param - 2, end);
  }
}

static void clic__state_update(char **buffer,
                               char **bptr,
                               size_t *buffer_size,
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

SEXP clic_ansi_simplify(SEXP sx) {
  struct cli_ansi_state state;
  memset(&state, 0, sizeof(state));
  char buffer_[BUFFER_SIZE];
  size_t buffer_size = sizeof(buffer_);
  char *buffer = buffer_;
  char *bptr = buffer;
  R_xlen_t i, len = XLENGTH(sx);
  SEXP result = allocVector(STRSXP, len);
  for (i = 0; i < len; i++) {
    SEXP str = STRING_ELT(sx, i);
    const char *ox = CHAR(str);
    const char *x = ox;
    const char *shaft = ox;
    const char *s_start;
    const char *s_param;
    const char *s_intermed;
    const char *s_end;
    bptr = buffer;

    while (*x != 0) {
      if (*x == '\033' && *(x + 1) == '[') {
        s_start = x;
        s_param = s_intermed = x + 2;
        while (*s_intermed >= 0x30 && *s_intermed <= 0x3f) s_intermed++;
        s_end = s_intermed;
        while (*s_end >= 0x20 && *s_end <= 0x2f) s_end++;
        if (*s_end >= 0x40 && *s_end <= 0x7e) {
          size_t n = s_start - shaft;
          if (n > 0) {
            clic__state_update(&buffer, &bptr, &buffer_size, &state);
            check_len(n, &buffer, &bptr, &buffer_size);
            memcpy(bptr, shaft, n);
            bptr += n;
          }

          clic__ansi_process(s_param,
                             s_intermed,
                             s_end,
                             &buffer,
                             &bptr,
                             &buffer_size,
                             &state);

          x = shaft = s_end + 1;
        }
        x = *s_end ? s_end + 1 : s_end;
      } else {
        x++;
      }
    }

    if (shaft == ox) {
      SET_STRING_ELT(result, i, str);

    } else {
      clic__state_update(&buffer, &bptr, &buffer_size, &state);
      if (*shaft) {
        size_t n = x - shaft;
        if (n > 0) {
          check_len(n, &buffer, &bptr, &buffer_size);
          memcpy(bptr, shaft, n);
          bptr += n;
        }
      }
      SET_STRING_ELT(result, i, Rf_mkCharLenCE(buffer, bptr - buffer, CE_NATIVE));
    }
  }

  if (buffer_size != BUFFER_SIZE) free(buffer);

  return result;
}
