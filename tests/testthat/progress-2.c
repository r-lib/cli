
#include <Rinternals.h>
#include <cli/progress.h>

SEXP clitest__init_timer() {
  int before = CLI_SHOULD_TICK;
  cli_progress_init_timer();
  int after = CLI_SHOULD_TICK;
  SEXP ret = PROTECT(Rf_allocVector(INTSXP, 2));
  INTEGER(ret)[0] = before;
  INTEGER(ret)[1] = after;
  UNPROTECT(1);
  return ret;
}
