
#include "cli.h"

#include <pthread.h>
#ifdef __TERMUX__
#include <bthread.h>
#endif

#include <time.h>
#ifdef _WIN32
#include <errno.h>
#include <windows.h>
#else
#include <signal.h>
#endif

SEXP cli_pkgenv = 0;
pthread_t tick_thread = { 0 };
volatile int cli__timer_flag = 1;
volatile int* cli_timer_flag = &cli__timer_flag;
struct timespec cli__tick_ts;
double cli_speed_time = 1.0;
volatile int cli__reset = 1;
static int unloaded = 0;

#ifdef _WIN32
static HANDLE tick_stop_event = NULL;
#endif

void* clic_thread_func(void *arg) {
#ifdef _WIN32
  DWORD timeout = cli__tick_ts.tv_sec * 1000 + cli__tick_ts.tv_nsec / 1000000;
  /* Wake immediately on shutdown, even if the next tick is far away. */
  while (WaitForSingleObject(tick_stop_event, timeout) == WAIT_TIMEOUT) {
    if (cli__reset) cli__timer_flag = 1;
  }
  return NULL;
#else
  sigset_t set;
  sigfillset(&set);
  int ret = pthread_sigmask(SIG_SETMASK, &set, NULL);
  /* We chicken out if the signals cannot be blocked. */
  if (ret) return NULL;

  int old;
  pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, &old);

  while (1) {
    /* TODO: handle signals */
    nanosleep(&cli__tick_ts, NULL);
    if (cli__reset) cli__timer_flag = 1;
  }
#endif
}

int cli__start_thread(SEXP ticktime, SEXP speedtime) {
  cli_speed_time = REAL(speedtime)[0];
  int cticktime = INTEGER(ticktime)[0] / REAL(speedtime)[0];
  if (cticktime == 0) cticktime = 1;
  cli__tick_ts.tv_sec = cticktime / 1000;
  cli__tick_ts.tv_nsec = (cticktime % 1000) * 1000 * 1000;
  int ret = 0;

#ifdef __EMSCRIPTEN__
  cli__reset = 0;
#else
  if (! getenv("CLI_NO_THREAD")) {
#ifdef _WIN32
    tick_stop_event = CreateEvent(NULL, TRUE, FALSE, NULL);
    if (!tick_stop_event) return EAGAIN;
#endif
    ret = pthread_create(
      & tick_thread,
      /* attr = */ 0,
      clic_thread_func,
      /* arg = */ NULL
    );
#ifdef _WIN32
    if (ret) {
      CloseHandle(tick_stop_event);
      tick_stop_event = NULL;
      tick_thread = 0;
    }
#else
    /* Windows keeps the thread joinable so cleanup can wait for it. */
    if (!ret) pthread_detach(tick_thread);
#endif
  } else {
    cli__reset = 0;
  }
#endif

  return ret;
}

SEXP clic_start_thread(SEXP pkg, SEXP ticktime, SEXP speedtime) {
  R_PreserveObject(pkg);
  cli_pkgenv = pkg;

  int ret = cli__start_thread(ticktime, speedtime);
  if (ret) warning("Cannot create cli tick thread");

  return R_NilValue;
}

int cli__kill_thread(void) {

  int ret = 0;

#ifdef _WIN32
  if (!tick_thread) return 0;

  /* Do not asynchronously cancel a thread inside the Windows runtime.
   * Let it return normally, and wait before releasing its resources. */
  if (!SetEvent(tick_stop_event)) {
    ret = EINVAL;
  } else {
    ret = pthread_join(tick_thread, NULL);
  }
  if (ret) {
    warning("Could not stop cli thread");
    return ret;
  }
  CloseHandle(tick_stop_event);
  tick_stop_event = NULL;
  tick_thread = 0;
#else

  /* This should not happen, but be extra careful */
  if (tick_thread) {
    ret = pthread_cancel(tick_thread);
    if (ret) {
      /* If we could not cancel, then accept the memory leak.
	 We do not try to free the R object, because the tick
	 thread might refer to it, still.
	 The tick thread is always cancellable, so this should
	 not happen. */
      warning("Could not cancel cli thread"); // __NO_COVERAGE__
      return ret;                             // __NO_COVERAGE__
    }
  }
#endif

  return ret;
}

#ifndef __has_feature
  #define __has_feature(x) 0
#endif

SEXP clic_stop_thread(void) {
  if (unloaded) return R_NilValue;
  int ret = 1;
#if defined(__clang__) && defined(__has_feature) && !defined(_WIN32)
# if __has_feature(address_sanitizer)
  /* clang in ASAN, do nothing */
# else
  ret = cli__kill_thread();
# endif
#else
  ret = cli__kill_thread();
#endif
  if (!ret) {
    R_ReleaseObject(cli_pkgenv);
  }

  unloaded = 1;

  return R_NilValue;
}

SEXP clic_tick_reset(void) {
  if (cli__reset) {
    cli__timer_flag = 0;
  }
  return R_NilValue;
}

SEXP clic_tick_set(SEXP ticktime, SEXP speedtime) {
  cli__timer_flag = 1;

  int ret = cli__kill_thread();
  if (ret) error("Cannot terminate progress thread");

  ret = cli__start_thread(ticktime, speedtime);
  if (ret) warning("Cannot create progress thread");

  return R_NilValue;
}

SEXP clic_tick_pause(SEXP state) {
  cli__reset = 0;
  cli__timer_flag = LOGICAL(state)[0];
  return R_NilValue;
}

SEXP clic_tick_resume(SEXP state) {
  cli__timer_flag = LOGICAL(state)[0];
  cli__reset = 1;
  return R_NilValue;
}
