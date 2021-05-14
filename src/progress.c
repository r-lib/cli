
#include "cli.h"
#include "errors.h"

#include <errno.h>
#include <time.h>

/* --------------------------------------------------------------------- */
/* for older macOS versions                                              */
/* --------------------------------------------------------------------- */

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

SEXP cli_progress_bar(int **ptr, int total) {
  *ptr = cli_timer_flag;

  /* If changes, synchronize with R API in progress-client.R */
  const char *names[] = {
    "name",
    "status",
    "type",
    "total",
    "format",
    "estimate",
    "auto_estimate",
    "clear",
    "envkey",
    "current",
    "start",
    "statusbar",
    ""
  };

  SEXP bar = PROTECT(Rf_mkNamed(VECSXP, names));

  SET_VECTOR_ELT(bar,  0, /* name          */ Rf_mkString(""));
  SET_VECTOR_ELT(bar,  1, /* status        */ Rf_mkString(""));
  SET_VECTOR_ELT(bar,  2, /* type          */ Rf_mkString("iterator"));
  SET_VECTOR_ELT(bar,  3, /* total         */ Rf_ScalarInteger(total));
  SET_VECTOR_ELT(bar,  4, /* format        */ R_NilValue);
  SET_VECTOR_ELT(bar,  5, /* estimate      */ R_NilValue);
  SET_VECTOR_ELT(bar,  6, /* auto_estimate */ R_NilValue);
  SET_VECTOR_ELT(bar,  7, /* clear         */ Rf_ScalarLogical(1));
  SET_VECTOR_ELT(bar,  8, /* envkey        */ R_NilValue);
  SET_VECTOR_ELT(bar,  9, /* current       */ Rf_ScalarInteger(0));
  SET_VECTOR_ELT(bar, 10, /* start         */ clic_get_time());
  SET_VECTOR_ELT(bar, 11, /* statusbar     */ R_NilValue);

  return bar;
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
  /* TODO: if there is a status bar, remove it */
}
