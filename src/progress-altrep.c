
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
R_altrep_class_t disable_gc_t;
R_altrep_class_t cli_timer_t;

static SEXP cli__current_progress_bar = 0;
static SEXP cli__disable_gc = 0;

void *disable_gc_DataPtr(SEXP x, Rboolean writeable) {
  /* We can't throw a condition from C, unfortunately... */
  SEXP call = PROTECT(Rf_lang2(install("progress_altrep_update"),
                               cli__current_progress_bar));
  Rf_eval(call, cli_pkgenv);
  UNPROTECT(1);
  return NULL;
}

/* --------------------------------------------------------------------- */

static SEXP cli__timer = 0;

SEXP clic_make_timer() {
  return cli__timer;
}

R_xlen_t cli_timer_Length(SEXP x) {
  return 1;
}

void* cli_timer_DataPtr(SEXP x, Rboolean writeable) {
  return (void*) cli_timer_flag;
}

int cli_timer_Elt(SEXP x, R_xlen_t i) {
  return *cli_timer_flag;
}

/* --------------------------------------------------------------------- */

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
    *cli_timer_flag = 0;
    SEXP bar = R_altrep_data2(x);
    double now = clic__get_time();
    Rf_defineVar(Rf_install("current"), ScalarInteger((int) i), bar);
    cli__current_progress_bar = bar;
    SEXP show_after = Rf_findVarInFrame3(bar, Rf_install("show_after"), 1);
    if (now > REAL(show_after)[0]) DATAPTR(cli__disable_gc);
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

  // -- tick_along_t --------------------------------------------------

  tick_along_t = R_make_altinteger_class("tick_along_t", "cli", dll);

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

  // -- disable_gc_t --------------------------------------------------

  disable_gc_t = R_make_altinteger_class("disable_gc_t", "cli", dll);
  R_set_altvec_Dataptr_method(disable_gc_t, disable_gc_DataPtr);

  cli__disable_gc = R_new_altrep(disable_gc_t, R_NilValue, R_NilValue);
  R_PreserveObject(cli__disable_gc);

  // -- cli_timer_t ---------------------------------------------------

  cli_timer_t = R_make_altlogical_class("cli_timer_t", "cli", dll);
  R_set_altrep_Length_method(cli_timer_t, cli_timer_Length);
  R_set_altvec_Dataptr_method(cli_timer_t, cli_timer_DataPtr);
  R_set_altlogical_Elt_method(cli_timer_t, cli_timer_Elt);

  cli__timer = R_new_altrep(cli_timer_t, R_NilValue, R_NilValue);
  MARK_NOT_MUTABLE(cli__timer);
  R_PreserveObject(cli__timer);
}

#endif
