
#include "cli.h"
#include <R_ext/Rdynload.h>

SEXP clic_unload() {
  clic_stop_thread();
  return R_NilValue;
}

static const R_CallMethodDef callMethods[]  = {
  { "clic_start_thread", (DL_FUNC) clic_start_thread, 1 },
  { "clic_stop_thread",  (DL_FUNC) clic_stop_thread,  0 },
  { "clic_tick_reset",   (DL_FUNC) clic_tick_reset,   0 },
  { "clic_unload",       (DL_FUNC) clic_unload,       0 },
  { NULL, NULL, 0 }
};

void R_init_cli(DllInfo *dll) {
  R_registerRoutines(dll, NULL, callMethods, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
  R_forceSymbols(dll, TRUE);

  R_RegisterCCallable("cli",
                      "cli_progress_bar",
                      (DL_FUNC) &cli_progress_bar);
  R_RegisterCCallable("cli",
                      "cli_progress_set",
                      (DL_FUNC) &cli_progress_set);
  R_RegisterCCallable("cli",
                      "cli_progress_add",
                      (DL_FUNC) &cli_progress_add);
  R_RegisterCCallable("cli",
                      "cli_progress_done",
                      (DL_FUNC) &cli_progress_done);
}
