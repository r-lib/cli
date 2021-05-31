
#include <Rinternals.h>

#include "cleancall.h"
#include <cli/progress.h>

SEXP test0() {
  int i;
  int res = 0;
  for (i = 0; i < 2000000000; i++) {
    res += i % 2;
  }
  return ScalarInteger(res);
}

SEXP test1() {
  int i;
  int res = 0;
  SEXP bar = PROTECT(cli_progress_bar(2000000000, NULL));
  for (i = 0; i < 2000000000; i++) {
    if (SHOULD_TICK) cli_progress_set(bar, i);
    res += i % 2;
  }
  cli_progress_done(bar);
  UNPROTECT(1);
  return ScalarInteger(res);
}

SEXP testx() {
  int i;
  int res = 0;
  SEXP bar = PROTECT(cli_progress_bar(2000000000, NULL));
  cli_progress_set_format(
     bar,
     "{%d} package{?s} {cli::pb_bar} | {cli::pb_elapsed}",
     4
  );
  for (i = 0; i < 2000000000; i++) {
    if (SHOULD_TICK) cli_progress_set(bar, i);
    res += i % 2;
  }
  cli_progress_done(bar);
  UNPROTECT(1);
  return ScalarInteger(res);
}

SEXP test2() {
  int i = 0;
  int res = 0;
  SEXP bar = PROTECT(cli_progress_bar(2000000000, NULL));
  int s, final, step = 2000000000 / 100000;
  for (s = 0; s < 100000; s++) {
    if (SHOULD_TICK) cli_progress_set(bar, i);
    final = (s + 1) * step;
    for (i = s * step; i < final; i++) {
      res += i % 2;
    }
  }
  cli_progress_done(bar);
  UNPROTECT(1);
  return ScalarInteger(res);
}

SEXP testc() {
  int i;
  int res = 0;
  SEXP bar = PROTECT(cli_progress_bar(2000000000, NULL));
  for (i = 0; i < 2000000000; i++) {
    if (SHOULD_TICK) cli_progress_set(bar, i);
    res += i % 2;
  }
  error("sorry, can't do this any more");
  cli_progress_done(bar);
  UNPROTECT(1);
  return ScalarInteger(res);
}

static const R_CallMethodDef CallEntries[] = {
  CLEANCALL_METHOD_RECORD,
  { "test0", (DL_FUNC) test0, 0 },
  { "test1", (DL_FUNC) test1, 0 },
  { "test2", (DL_FUNC) test2, 0 },
  { "testx", (DL_FUNC) testx, 0 },
  { "testc", (DL_FUNC) testc, 0 },
  { NULL, NULL, 0 }
};

void R_init_progresstest(DllInfo *dll) {
  R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
  R_forceSymbols(dll, TRUE);
  cleancall_fns_dot_call = Rf_findVar(Rf_install(".Call"), R_BaseEnv);
}
