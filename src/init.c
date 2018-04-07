
#include <R.h>
#include <Rinternals.h>
#include <R_ext/Rdynload.h>
#include "cli.h"

static const R_CallMethodDef callMethods[]  = {
  {"get_screen_size", (DL_FUNC) &get_screen_size, 0},
  {NULL, NULL, 0}
};

void R_init_cli(DllInfo *dll) {
  R_registerRoutines(dll, NULL, callMethods, NULL, NULL);
  R_useDynamicSymbols(dll, FALSE);
  R_forceSymbols(dll, TRUE);
}
