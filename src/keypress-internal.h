
#ifndef KEYPRESS_INTERNAL_H
#define KEYPRESS_INTERNAL_H

SEXP save_term_status(void);
SEXP restore_term_status(void);
SEXP set_term_echo(SEXP s_echo);

SEXP test_single_char(SEXP s_bytes);
SEXP test_function_key(SEXP s_bytes);

#endif
