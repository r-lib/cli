
#include "cli.h"
#include "errors.h"
#include "cleancall.h"

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

static R_INLINE SEXP new_env() {
  SEXP env;
  PROTECT(env = allocSExp(ENVSXP));
  SET_FRAME(env, R_NilValue);
  SET_ENCLOS(env, R_EmptyEnv);
  SET_HASHTAB(env, R_NilValue);
  SET_ATTRIB(env, R_NilValue);
  UNPROTECT(1);
  return env;
}

double clic__get_time() {
  struct timespec t;
  int ret = cli_clock_gettime(CLOCK_MONOTONIC, &t);
  if (ret) R_THROW_POSIX_ERROR("Cannot query monotonic clock");
  return (double) t.tv_sec + 1e-9 * (double) t.tv_nsec;
}

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

void cli_progress_init_timer(vint **ptr) {
  *ptr = cli_timer_flag;
}

SEXP cli_progress_bar(vint **ptr, int total, SEXP config) {
  *ptr = cli_timer_flag;

  /* FALSE means no progress bar */
  if (config && Rf_isLogical(config) && LENGTH(config) == 1 &&
      !LOGICAL(config)[0]) {
    return R_NilValue;
  }

  /* If changes, synchronize with R API in progress-client.R */
  double now = clic__get_time();
  SEXP bar = PROTECT(new_env());
  SEXP show_after = PROTECT(Rf_GetOption1(Rf_install("cli.progress_show_after")));
  double sa = 2;
  if (!isNull(show_after)) sa = REAL(show_after)[0];
  SEXP clear = PROTECT(Rf_GetOption1(Rf_install("cli.progress_clear")));
  int cl = 1;
  if (!isNull(clear)) cl = LOGICAL(clear)[0];

  Rf_defineVar(Rf_install("name"),          Rf_mkString(""),         bar);
  Rf_defineVar(Rf_install("status"),        Rf_mkString(""),         bar);
  Rf_defineVar(Rf_install("type"),          Rf_mkString("iterator"), bar);
  Rf_defineVar(Rf_install("total"),         Rf_ScalarInteger(total), bar);
  Rf_defineVar(Rf_install("show_after"),    Rf_ScalarReal(now + sa), bar);
  Rf_defineVar(Rf_install("format"),        R_NilValue,              bar);
  Rf_defineVar(Rf_install("format_done"),   R_NilValue,              bar);
  Rf_defineVar(Rf_install("format_failed"), R_NilValue,              bar);
  Rf_defineVar(Rf_install("clear"),         Rf_ScalarLogical(cl),    bar);
  Rf_defineVar(Rf_install("auto_terminate"), Rf_ScalarLogical(1),    bar);
  Rf_defineVar(Rf_install("envkey"),        R_NilValue,              bar);
  Rf_defineVar(Rf_install("current"),       Rf_ScalarInteger(0),     bar);
  Rf_defineVar(Rf_install("start"),         Rf_ScalarReal(now),      bar);
  Rf_defineVar(Rf_install("statusbar"),     R_NilValue,              bar);
  Rf_defineVar(Rf_install("tick"),          Rf_ScalarInteger(0),     bar);

  if (!config) {
    /* NULL pointer, use defaults */

  } else if (Rf_isLogical(config) && LENGTH(config) == 1) {
    /* TRUE, use defaults */

  } else if (TYPEOF(config) == VECSXP) {
    /* Proper config */
    int i, n = LENGTH(config);
    SEXP nms = getAttrib(config, R_NamesSymbol);
    if (isNull(nms)) {
      error("Invalid cli progress bar configuration, list elements must "
            "be named.");
    }
    for (i = 0; i < n; i++) {
      Rf_defineVar(
        Rf_install(CHAR(STRING_ELT(nms, i))),
        VECTOR_ELT(config, i),
        bar
     );
    }

  } else if (TYPEOF(config) == STRSXP) {
    /* String, use as name */
    Rf_defineVar(Rf_install("name"), config, bar);

  } else {
    error("Unknown cli progress bar configuation, see manual.");
  }

  UNPROTECT(3);
  return bar;
}

void cli_progress_set_name(SEXP bar, const char *name) {
  if (isNull(bar)) return;
  Rf_defineVar(Rf_install("name"), Rf_mkString(name), bar);
}

void cli_progress_set_status(SEXP bar, const char *status) {
  if (isNull(bar)) return;
  Rf_defineVar(Rf_install("status"), Rf_mkString(status), bar);
}

void cli_progress_set_type(SEXP bar, const char *type) {
  if (isNull(bar)) return;
  Rf_defineVar(Rf_install("type"), Rf_mkString(type), bar);
}

void cli_progress_set_format(SEXP bar, const char *format) {
  if (isNull(bar)) return;
  Rf_defineVar(Rf_install("format"), Rf_mkString(format), bar);
}

void cli_progress_set_clear(SEXP bar, int clear) {
  if (isNull(bar)) return;
  Rf_defineVar(Rf_install("clear"), Rf_ScalarLogical(clear), bar);
}

void cli_progress_set(SEXP bar, int set) {
  if (isNull(bar)) return;
  Rf_defineVar(Rf_install("current"), ScalarInteger(set), bar);
  if (*cli_timer_flag) {
    *cli_timer_flag = 0;
    double now = clic__get_time();
    SEXP show_after = Rf_findVarInFrame3(bar, Rf_install("show_after"), 1);
    if (now > REAL(show_after)[0]) cli__progress_update(bar);
  }
}

void cli_progress_add(SEXP bar, int inc) {
  if (isNull(bar)) return;
  int crnt = INTEGER(Rf_findVarInFrame3(bar, Rf_install("current"), 1))[0];
  Rf_defineVar(Rf_install("current"), ScalarInteger(crnt + inc), bar);
  if (*cli_timer_flag) {
    *cli_timer_flag = 0;
    double now = clic__get_time();
    SEXP show_after = Rf_findVarInFrame3(bar, Rf_install("show_after"), 1);
    if (now > REAL(show_after)[0]) cli__progress_update(bar);
  }
}

void cli_progress_done(SEXP bar) {
  if (isNull(bar)) return;
  SEXP call = PROTECT(Rf_lang2(install("progress_c_done"), bar));
  PROTECT(Rf_eval(call, cli_pkgenv));
  UNPROTECT(2);
}

int cli_progress_num() {
  SEXP clienv = Rf_findVarInFrame3(cli_pkgenv, Rf_install("clienv"), 1);
  SEXP bars = Rf_findVarInFrame3(clienv, Rf_install("progress"), 1);
  return LENGTH(bars);
}

extern double cli_speed_time;

void cli_progress_sleep(int s, long ns) {
  struct timespec ts;
  int s2 = s;
  long ns2 = ns;
  if (cli_speed_time != 1.0) {
    s2 = s / cli_speed_time;
    ns2 =
      (s / cli_speed_time - s2) * 1000 * 1000 * 1000 +
      ns / cli_speed_time;
  }
  ts.tv_sec = s2;
  ts.tv_nsec = ns2;
  nanosleep(&ts, NULL);
}

void cli_progress_update(SEXP bar, int set, int inc, int force) {
  if (isNull(bar)) return;
  if (set >= 0) {
    Rf_defineVar(Rf_install("current"), ScalarInteger(set), bar);
  } else {
    int crnt = INTEGER(Rf_findVarInFrame3(bar, Rf_install("current"), 1))[0];
    if (inc != 0) {
      Rf_defineVar(Rf_install("current"), ScalarInteger(crnt + inc), bar);
    }
  }
  if (force) {
    cli__progress_update(bar);
  } else if (*cli_timer_flag) {
    *cli_timer_flag = 0;
    double now = clic__get_time();
    SEXP show_after = Rf_findVarInFrame3(bar, Rf_install("show_after"), 1);
    if (now > REAL(show_after)[0]) cli__progress_update(bar);
  }
}
