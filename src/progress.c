
#include "cli.h"

SEXP cli_progress_bar(int **ptr) {
  *ptr = cli_timer_flag;
  return R_NilValue;
}

void cli_progress_set(SEXP bar, int set) {
  REprintf(".");
  *cli_timer_flag = 0;
}

void cli_progress_add(SEXP bar, int inc) {
  REprintf(".");
  *cli_timer_flag = 0;
}

void cli_progress_done(SEXP bar) {

}
