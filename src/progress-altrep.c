
#include "cli.h"

#include <Rversion.h>

#if R_VERSION < R_Version(3, 5, 0)

SEXP clic_tick_along(SEXP seq, SEXP bar) {
  error("internal cli error");
  return R_NilValue;
}

void cli_init_altrep(DllInfo *dll) { }

#else

#include <R_ext/Altrep.h>

R_altrep_class_t tick_along_t;

SEXP clic_tick_along(SEXP seq, SEXP bar) {
  SEXP val = R_new_altrep(tick_along_t, seq, bar);
  return val;
}

R_xlen_t tick_along_Length(SEXP x) {
  SEXP data1 = R_altrep_data1(x);
  return XLENGTH(data1);
}

SEXP tick_along_Duplicate(SEXP x, Rboolean deep) {
  SEXP data1 = R_altrep_data1(x);
  SEXP bar = R_altrep_data2(x);
  return clic_tick_along(data1, bar);
}

Rboolean tick_along_Inspect(SEXP x,
                            int pre,
                            int deep,
                            int pvec,
                            void (*inspect_subtree)(SEXP, int, int, int)) {

  Rprintf(" tick_along %s\n", type2char(TYPEOF(x)));
  return FALSE;
}

void* tick_along_Dataptr(SEXP x, Rboolean writeable) {
  SEXP data1 = R_altrep_data1(x);
  if (writeable) {
    return DATAPTR(data1);
  } else {
    return (void*) DATAPTR_RO(data1);
  }
}

const void* tick_along_Dataptr_or_null(SEXP x) {
  SEXP data1 = R_altrep_data1(x);
  return DATAPTR_OR_NULL(data1);
}

// TODO: long vector support?
int tick_along_Elt(SEXP x, R_xlen_t i) {
  if (*cli_timer_flag) {
    SEXP bar = R_altrep_data2(x);
    Rf_defineVar(Rf_install("current"), ScalarInteger((int) i), bar);
    cli__progress_update(bar);
    *cli_timer_flag = 0;
  }
  return (int) (i + 1);
}

R_xlen_t tick_along_Get_region(SEXP x, R_xlen_t i, R_xlen_t n, int *buf) {
  SEXP data1 = R_altrep_data1(x);
  return INTEGER_GET_REGION(data1, i, n, buf);
}

SEXP tick_along_Sum(SEXP x, Rboolean narm) {
  SEXP data1 = R_altrep_data1(x);
  R_xlen_t n = XLENGTH(data1);
  return ScalarReal(n * ( n + 1.0) / 2.0);
}

SEXP tick_along_Max(SEXP x, Rboolean narm) {
  SEXP data1 = R_altrep_data1(x);
  R_xlen_t n = XLENGTH(data1);
  return ScalarReal(n);
}

SEXP tick_along_Min(SEXP x, Rboolean narm) {
  SEXP data1 = R_altrep_data1(x);
  R_xlen_t n = XLENGTH(data1);
  if (n > 0) {
    return ScalarInteger(1);
  } else {
    return ScalarReal(R_PosInf);
  }
}

int tick_along_Is_sorted(SEXP x) {
  return SORTED_INCR;
}

void cli_init_altrep(DllInfo *dll) {
  R_altrep_class_t cls = R_make_altinteger_class("tick_along_t", "cli", dll);
  tick_along_t = cls;

  // override ALTREP methods
  R_set_altrep_Duplicate_method(tick_along_t, tick_along_Duplicate);
  R_set_altrep_Inspect_method(tick_along_t, tick_along_Inspect);
  R_set_altrep_Length_method(tick_along_t, tick_along_Length);

  // override ALTVEC methods
  R_set_altvec_Dataptr_method(tick_along_t, tick_along_Dataptr);
  R_set_altvec_Dataptr_or_null_method(tick_along_t, tick_along_Dataptr_or_null);

  // override ALTINTEGER methods
  R_set_altinteger_Elt_method(tick_along_t, tick_along_Elt);
  R_set_altinteger_Get_region_method(tick_along_t, tick_along_Get_region);
  R_set_altinteger_Sum_method(tick_along_t, tick_along_Sum);
  R_set_altinteger_Max_method(tick_along_t, tick_along_Max);
  // R_set_altinteger_Min_method(tick_along_t, tick_along_Min);
  // R_set_altinteger_No_NA_method(tick_along_t, tick_along_No_NA);
   R_set_altinteger_Is_sorted_method(tick_along_t, tick_along_Is_sorted);
}

#endif
