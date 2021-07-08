
#include "cli.h"
#include "errors.h"
#include "cleancall.h"

#include <string.h>
#include <stdlib.h>

#define BUFFER_SIZE 4096

struct cli_ansi_state {
  char new_off;
  char bold, new_bold;
  char faint, new_faint;
  char italic, new_italic;
  char underline, new_underline;
  char blink, new_blink;
  char inverse, new_inverse;
  char hide, new_hide;
  char crossedout, new_crossedout;
  char col_fg, new_col_fg;      /* 1-8, 9 is 8 bit, 10 is 24 bit */
  char col_bg, new_col_bg;      /* 1-8, 9 is 8 bit, 10 is 24 bit */
  /* TODO: 8 bit colors */
  /* TODO: 24 bit colors */
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

void clic__ansi_process(const char *param,
                        const char *intermed,
                        const char *end,
                        char **buffer,
                        char **bptr,
                        size_t *buffer_size,
                        struct cli_ansi_state *state) {
  char *endptr;
  long num = strtol(param, &endptr, 10);
  if (endptr == param && num == 0) {
    if (state->bold || state->faint || state->italic || state->underline ||
        state->blink || state->inverse || state->inverse || state->hide ||
        state->crossedout || state->col_fg || state->col_bg) {
      EMIT("0");
      memset(state, 0, sizeof(*state));
    }

  } else if (num == 1) {
    if (!state->bold) {
      state->bold = 1;
      EMIT("1");
    }

  } else if (num == 2) {
    if (!state->faint) {
      state->faint = 1;
      EMIT("2");
    }

  } else if (num == 3) {
    if (!state->italic) {
      state->italic = 1;
      EMIT("3");
    }

  } else if (num == 4) {
    if (!state->underline) {
      state->underline = 1;
      EMIT("4");
    }

  } else if (num == 5) {
    if (!state->blink) {
      state->blink = 1;
      EMIT("5");
    }

  } else if (num == 7) {
    if (!state->inverse) {
      state->inverse = 1;
      EMIT("7");
    }

  } else if (num == 8) {
    if (state->hide) {
      state->hide = 1;
      EMIT("8");
    }

  } else if (num == 9) {
    if (state->crossedout) {
      state->crossedout = 1;
      EMIT("9");
    }

  } else if (num == 22) {
    if (state->bold || state->faint) {
      state->bold = state->faint = 0;
      EMIT("22");
    }

  } else if (num == 23) {
    if (state->italic) {
      state->italic = 0;
      EMIT("23");
    }

  } else if (num == 24) {
    if (state->underline) {
      state->underline = 0;
      EMIT("24");
    }

  } else if (num == 25) {
    if (state->blink) {
      state->blink = 0;
      EMIT("25");
    }

  } else if (num == 27) {
    if (state->inverse) {
      state->inverse = 0;
      EMIT("27");
    }

  } else if (num == 28) {
    if (state->hide) {
      state->hide = 0;
      EMIT("28");
    }

  } else if (num == 29) {
    if (state->crossedout) {
      state->crossedout = 0;
      EMIT("29");
    }

  } else if (num >= 30 && num <= 37) {
    int col = num - 30 + 1;
    if (state->col_fg != col) {
      char str[10];
      state->col_fg = col;
      snprintf(str, sizeof(str), "\033[%ldm", num);
      EMITS(str);
    }

    /* } else if (num == 38) { */
    /* TODO */

  } else if (num == 39) {
    if (state->col_fg) {
      state->col_fg = 0;
      EMIT("39");
    }

  } else if (num >= 40 && num <= 47) {
    int col = num - 40 + 1;
    if (state->col_bg != col) {
      char str[10];
      state->col_bg = col;
      snprintf(str, sizeof(str), "\033[%ldm", num);
      EMITS(str);
    }

    /* } else if (num == 48) { */
    /* TODO */

  } else if (num == 49) {
    if (state->col_bg != 0) {
      state->col_bg = 0;
      EMIT("49");
    }

  } else {
    /* Keep tag as is */
    EMITL(param - 2, end);
  }
}

SEXP clic_ansi_simplify(SEXP sx) {
  struct cli_ansi_state state = { 0 };
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
