
#include "cli.h"
#include "errors.h"

#include <errno.h>
#include <time.h>

/* ---------------------------------------------------------------------*/
/* Internals                                                            */
/* ---------------------------------------------------------------------*/

/* for older macOS versions */

#ifdef __MACH__
#include <mach/clock.h>
#include <mach/mach.h>
#include <mach/mach_time.h>
#include <sys/time.h>
/* It doesn't really matter what these are defined to, as long as they
   are defined */
#ifndef CLOCK_REALTIME
#define CLOCK_REALTIME 0
#endif
#ifndef CLOCK_MONOTONIC
#define CLOCK_MONOTONIC 1
#endif
static int cli_clock_gettime(int clk_id, struct timespec *t) {
  memset(t, 0, sizeof(*t));
  if (clk_id == CLOCK_REALTIME) {
    struct timeval now;
    int rv = gettimeofday(&now, NULL);
    if (rv) {
      return rv;
    }
    t->tv_sec = now.tv_sec;
    t->tv_nsec = now.tv_usec * 1000;
    return 0;

  } else if (clk_id == CLOCK_MONOTONIC) {
    static uint64_t clock_start_time = 0;
    static mach_timebase_info_data_t timebase_ifo = {0, 0};
    uint64_t now = mach_absolute_time();

    if (clock_start_time == 0) {
      kern_return_t mach_status = mach_timebase_info(&timebase_ifo);

      /* appease "unused variable" warning for release builds */
      (void)mach_status;

      clock_start_time = now;
    }

    now = (uint64_t)((double)(now - clock_start_time)
                     * (double)timebase_ifo.numer
                     / (double)timebase_ifo.denom);

    t->tv_sec = now / 1000000000;
    t->tv_nsec = now % 1000000000;
    return 0;
  }
  return EINVAL; /* EINVAL - Clock ID is unknown */
}
#else
#define cli_clock_gettime(a,b) clock_gettime(a,b)
#endif

SEXP clic_get_time() {
  struct timespec t;
  int ret = cli_clock_gettime(CLOCK_MONOTONIC, &t);
  if (ret) R_THROW_POSIX_ERROR("Cannot query monotonic clock");
  double ts = (double) t.tv_sec + 1e-9 * (double) t.tv_nsec;
  return Rf_ScalarReal(ts);
}

SEXP cli__progress_update(SEXP bar) {
  /* We can't throw a condition from C, unfortunately... */
  SEXP call = PROTECT(Rf_lang2(install("progress_c_update"), bar));
  SEXP retv = PROTECT(Rf_eval(call, cli_pkgenv));
  UNPROTECT(2);
  return retv;
}

/* ---------------------------------------------------------------------*/
/* Public API                                                           */
/* ---------------------------------------------------------------------*/

SEXP cli_progress_bar(int **ptr, int total) {
  *ptr = cli_timer_flag;

  /* If changes, synchronize with R API in progress-client.R */
  const char *names[] = {
#define PB_NAME 0
    "name",
#define PB_STATUS 1
    "status",
#define PB_TYPE 2
    "type",
#define PB_TOTAL 3
    "total",
#define PB_FORMAT 4
    "format",
#define PB_ESTIMATE 5
    "estimate",
#define PB_AUTO_ESTIMATE 6
    "auto_estimate",
#define PB_CLEAR 7
    "clear",
#define PB_ENVKEY 8
    "envkey",
#define PB_CURRENT 9
    "current",
#define PB_START 10
    "start",
#define PB_STATUSBAR 11
    "statusbar",
    ""
  };

  SEXP bar = PROTECT(Rf_mkNamed(VECSXP, names));

  SET_VECTOR_ELT(bar, PB_NAME,          Rf_mkString(""));
  SET_VECTOR_ELT(bar, PB_STATUS,        Rf_mkString(""));
  SET_VECTOR_ELT(bar, PB_TYPE,          Rf_mkString("iterator"));
  SET_VECTOR_ELT(bar, PB_TOTAL,         Rf_ScalarInteger(total));
  SET_VECTOR_ELT(bar, PB_FORMAT,        R_NilValue);
  SET_VECTOR_ELT(bar, PB_ESTIMATE,      R_NilValue);
  SET_VECTOR_ELT(bar, PB_AUTO_ESTIMATE, R_NilValue);
  SET_VECTOR_ELT(bar, PB_CLEAR,         Rf_ScalarLogical(1));
  SET_VECTOR_ELT(bar, PB_ENVKEY,        R_NilValue);
  SET_VECTOR_ELT(bar, PB_CURRENT,       Rf_ScalarInteger(0));
  SET_VECTOR_ELT(bar, PB_START,         clic_get_time());
  SET_VECTOR_ELT(bar, PB_STATUSBAR,     R_NilValue);

  UNPROTECT(1);
  return bar;
}

void cli_progress_set(SEXP bar, int set) {
  int *current = INTEGER(VECTOR_ELT(bar, PB_CURRENT));
  *current = set;
  if (*cli_timer_flag) {
    cli__progress_update(bar);
    *cli_timer_flag = 0;
  }
}

void cli_progress_add(SEXP bar, int inc) {
  int *current = INTEGER(VECTOR_ELT(bar, PB_CURRENT));
  (*current) += inc;
  if (*cli_timer_flag) {
    cli__progress_update(bar);
    *cli_timer_flag = 0;
  }
}

void cli_progress_done(SEXP bar) {
  /* TODO: if there is a status bar, remove it */
}
