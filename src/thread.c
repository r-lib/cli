
#include "cli.h"

#include <pthread.h>
#include <time.h>
#ifndef _WIN32
#include <signal.h>
#endif

SEXP cli_pkgenv = 0;
static SEXP pflag = 0;
static pthread_t tick_thread = { 0 };
int* cli_timer_flag = 0;
static struct timespec cli__tick_ts;
double cli_speed_time = 1.0;

void* clic_thread_func(void *arg) {
  cli_timer_flag = (int*) arg;

#ifndef _WIN32
  sigset_t set;
  sigfillset(&set);
  int ret = pthread_sigmask(SIG_SETMASK, &set, NULL);
  /* We chicken out if the signals cannot be blocked. */
  if (ret) return NULL;
#endif

  int old;
  pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, &old);

  while (1) {
    /* TODO: handle signals */
    nanosleep(&cli__tick_ts, NULL);
    *cli_timer_flag = 1;
  }
}

static int start_thread(SEXP ticktime, SEXP speedtime) {
  cli_speed_time = REAL(speedtime)[0];
  int cticktime = INTEGER(ticktime)[0] / REAL(speedtime)[0];
  if (cticktime == 0) cticktime = 1;
  cli__tick_ts.tv_sec = cticktime / 1000;
  cli__tick_ts.tv_nsec = (cticktime % 1000) * 1000 * 1000;

  int ret = pthread_create(
    & tick_thread,
    /* attr = */ 0,
    clic_thread_func,
    /* arg = */ LOGICAL(pflag)
  );

  return ret;
}

SEXP clic_start_thread(SEXP pkg, SEXP ticktime, SEXP speedtime) {
  R_PreserveObject(pkg);
  cli_pkgenv = pkg;
  pflag = flag;

  int ret = start_thread(ticktime, speedtime);
  if (ret) warning("Cannot create cli tick thread");

  return R_NilValue;
}

static int kill_thread() {
  int ret = 0;
  /* This should not happen, but be extra careful */
  if (tick_thread) {
    ret = pthread_cancel(tick_thread);
    if (ret) {
      /* If we could not cancel, then accept the memory leak.
	 We do not try to free the R object, because the tick
	 thread might refer to it, still.
	 The tick thread is always cancellable, so this should
	 not happen. */
      warning("Could not cancel cli thread");
      return ret;
    } else {
      /* Wait for it to finish. Otherwise releasing the flag
	 is risky because the tick thread might just use it. */
      ret = pthread_join(tick_thread, NULL);
    }
  }

  return ret;
}

SEXP clic_stop_thread() {
  int ret = kill_thread();
  if (!ret && pflag) {
    R_ReleaseObject(cli_pkgenv);
    R_ReleaseObject(pflag);
    pflag = 0;
  }

  return R_NilValue;
}

SEXP clic_tick_reset() {
  if (cli_timer_flag) *cli_timer_flag = 0;
  return R_NilValue;
}

SEXP clic_tick_set(SEXP ticktime, SEXP speedtime) {
  if (cli_timer_flag) *cli_timer_flag = 1;

  int ret = kill_thread();
  if (ret) error("Cannot terminate progress thread");

  ret = start_thread(ticktime, speedtime);
  if (ret) warning("Cannot create progress thread");

  return R_NilValue;
}

SEXP clic_should_tick() {
  return Rf_ScalarLogical(cli__timer_flag);
}
