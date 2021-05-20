
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
  return R_new_altrep(tick_along_t, seq, bar);
}

static R_xlen_t tick_along_Length(SEXP x) {
  SEXP data1 = R_altrep_data1(x);
  if (ALTREP(data1)) {
    return ALTREP_LENGTH(data1);
  } else {
    return XLENGTH_EX(data1);
  }
}

static int tick_along_integer_Elt(SEXP x, R_xlen_t i) {
  if (*cli_timer_flag) {
    SEXP bar = R_altrep_data2(x);
    int *current = INTEGER(Rf_findVar(Rf_install("current"), bar));
    *current = i;
    cli__progress_update(bar);
    *cli_timer_flag = 0;
  }
  return i;
}

void cli_init_altrep(DllInfo *dll) {
  tick_along_t = R_make_altinteger_class("tick_along_t", "base", dll);

  // override ALTREP methods
  // R_set_altrep_Duplicate_method(tick_along_t, tick_along_Duplicate);
  // R_set_altrep_Inspect_method(tick_along_t, tick_along_Inspect);
  R_set_altrep_Length_method(tick_along_t, tick_along_Length);

  // override ALTVEC methods
  // R_set_altvec_Dataptr_method(tick_along_t, tick_along_Dataptr);
  // R_set_altvec_Dataptr_or_null_method(tick_along_t, tick_along_Dataptr_or_null);

  // override ALTINTEGER methods
  R_set_altinteger_Elt_method(tick_along_t, tick_along_integer_Elt);
  // R_set_altinteger_Get_region_method(tick_along_t, tick_along_integer_Get_region);
  // R_set_altinteger_Sum_method(tick_along_t, tick_along_integer_Sum);
  // R_set_altinteger_Max_method(tick_along_t, tick_along_integer_Max);
  // R_set_altinteger_Min_method(tick_along_t, tick_along_integer_Min);
  // R_set_altinteger_No_NA_method(tick_along_t, tick_along_integer_No_NA);
  // R_set_altinteger_Is_sorted_method(tick_along_t, tick_along_integer_Sorted);
}

#endif
