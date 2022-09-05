
#include <string.h>

#include "errors.h"
#include "vtparse.h"

#define CUR(term) (((term)->cursor_y) * ((term)->width) + ((term)->cursor_x))
#define POS(term, x, y) ((y) * ((term)->width) + (x))

struct terminal {
  vtparse_t *vt;
  int width;
  int height;
  unsigned int *screen;
  int cursor_x;
  int cursor_y;
};

void cli_term_clear_screen(struct terminal *term) {
  int i, n = term->width * term->height;
  for (i = 0; i < n; i++) {
    term->screen[i] = ' ';
  }
}

int cli_term_init(struct terminal *term, int width, int height) {
  term->width = width;
  term->height = height;
  term->screen = (unsigned int *) R_alloc(width * height, sizeof(unsigned int));
  cli_term_clear_screen(term);
  return 0;
}

SEXP cli_term_lines(struct terminal *term) {
  SEXP res = PROTECT(Rf_allocVector(VECSXP, term->height));
  int i;

  for (i = 0; i < term->height; i++) {
    SEXP line = PROTECT(Rf_allocVector(INTSXP, term->width));
    memcpy(
      INTEGER(line),
      term->screen + POS(term, 0, i),
      sizeof(unsigned int) * term->width
    );
    SET_VECTOR_ELT(res, i, line);
    UNPROTECT(1);
  }

  UNPROTECT(1);
  return res;
}

void cli_term_move_cursor_down(struct terminal *term) {
  // scroll?
  if (term->cursor_y == term->height - 1) {
    // TODO
  }
  term->cursor_y += 1;
  term->cursor_x = 0;
}

void cli_term_execute(struct terminal *term, int ch) {
  // TODO: rest
  switch (ch) {

  case '\n':
    cli_term_move_cursor_down(term);
    break;

  case '\r':
    term->cursor_x = 0;
    break;

  default:
    break;
  }
}

void clic_vt_callback(vtparse_t *vt, vtparse_action_t action,
                      unsigned int ch) {

  struct terminal *term = (struct terminal*) vt->user_data;

  switch (action) {
  case VTPARSE_ACTION_EXECUTE:
    cli_term_execute(term, ch);
    break;

  case VTPARSE_ACTION_PRINT:
    term->screen[CUR(term)] = ch;
    term->cursor_x += 1;
    if (term->cursor_x == term->width) {
      term->cursor_x = 0;
      term->cursor_y += 1;
      // TODO: scroll if needed. Or should we scrool at the next character
      // only, so we can write at the bottom right corner?
    }
    break;

  default:
    break;
  }
}

SEXP clic_vt_simulate(SEXP bytes, SEXP width, SEXP height) {
  int c_width = INTEGER(width)[0];
  int c_height = INTEGER(height)[0];

  vtparse_t vt;
  struct terminal term = { 0 };
  if (cli_term_init(&term, c_width, c_height)) {
    R_THROW_ERROR("Cannot initialize vittual terminal");
  }
  term.vt = &vt;

  vtparse_init(&vt, clic_vt_callback);
  vt.user_data = &term;
  vtparse(&vt, RAW(bytes), LENGTH(bytes));

  return cli_term_lines(&term);
}
