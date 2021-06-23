
#include <Rinternals.h>
#include <cli/progress.h>

SEXP clitest__progress_crud(SEXP config) {
  SEXP bar = PROTECT(cli_progress_bar(10, config));
  int i;
  for (i = 0; i < 10; i++) {
    if (CLI_SHOULD_TICK) cli_progress_set(bar, i + 1);
  }
  cli_progress_done(bar);
  UNPROTECT(1);
  return ScalarLogical(!Rf_isNull(bar));
}

SEXP clitest__progress_sets() {
  SEXP bar = PROTECT(cli_progress_bar(10, NULL));
  cli_progress_set_name(bar, "new name");
  cli_progress_set_status(bar, "stats");
  cli_progress_set_type(bar, "tasks");
  cli_progress_set_format(bar, "{cli::pb_name}{cli::pb_status}{cli::pb_current}");
  cli_progress_set_clear(bar, FALSE);

  int i;
  for (i = 0; i < 10; i++) {
    if (CLI_SHOULD_TICK) cli_progress_set(bar, i + 1);
  }
  cli_progress_done(bar);
  UNPROTECT(1);
  return ScalarLogical(!Rf_isNull(bar));
}

SEXP clitest__progress_add() {
  SEXP bar = PROTECT(cli_progress_bar(10, NULL));
  int i;
  for (i = 0; i < 10; i++) {
    cli_progress_add(bar, 1);
  }
  cli_progress_done(bar);
  UNPROTECT(1);
  return ScalarLogical(!Rf_isNull(bar));
}

SEXP clitest__progress_num() {
  return ScalarInteger(cli_progress_num());
}

SEXP clitest__progress_sleep(SEXP s, SEXP ns) {
  cli_progress_sleep(INTEGER(s)[0], INTEGER(ns)[0]);
  return R_NilValue;
}

SEXP clitest__progress_update() {
  SEXP bar = PROTECT(cli_progress_bar(10, NULL));
  int i;
  for (i = 0; i < 10; i++) {
    cli_progress_update(bar, /* set= */ -1, /* inc= */ 1, /* force= */ 1);
  }
  cli_progress_done(bar);
  UNPROTECT(1);
  return ScalarLogical(!Rf_isNull(bar));
}

SEXP clitest__progress_update2() {
  SEXP bar = PROTECT(cli_progress_bar(10, NULL));
  int i;
  for (i = 0; i < 10; i++) {
    cli_progress_update(bar, /* set= */ i + 1, /* inc= */ 0, /* force= */ 1);
  }
  cli_progress_done(bar);
  UNPROTECT(1);
  return ScalarLogical(!Rf_isNull(bar));
}

SEXP clitest__progress_update3() {
  SEXP bar = PROTECT(cli_progress_bar(10, NULL));
  int i;
  for (i = 0; i < 10; i++) {
    cli_progress_update(bar, /* set= */ i + 1, /* inc= */ 0, /* force= */ 0);
  }
  cli_progress_done(bar);
  UNPROTECT(1);
  return ScalarLogical(!Rf_isNull(bar));
}
