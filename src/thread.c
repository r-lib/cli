
#include "cli.h"

#include <pthread.h>
#include <time.h>

static SEXP pflag = 0;
static pthread_t tick_thread = { 0 };
static int* flag = 0;

/* TODO: this might not be monitonic. replace with better approach */
#if defined(__MACH__) && !defined(CLOCK_REALTIME)
#include <sys/time.h>
#define CLOCK_REALTIME 0
#define CLOCK_MONOTONIC 0
// clock_gettime is not implemented on older versions of OS X (< 10.12).
// If implemented, CLOCK_REALTIME will have already been defined.
int clock_gettime(int dummy, struct timespec* t) {
  struct timeval now;
  int rv = gettimeofday(&now, NULL);
  if (rv) return rv;
  t->tv_sec  = now.tv_sec;
  t->tv_nsec = now.tv_usec * 1000;
  return 0;
}
#endif

void* clic_thread_func(void *arg) {
  flag = (int*) arg;
  struct timespec sp;
  sp.tv_sec = 0;
  sp.tv_nsec = 100 * 1000 * 1000;

  while (1) {
    /* TODO: handle signals */
    nanosleep(&sp, NULL);
    *flag = 1;
  }
}

SEXP clic_start_thread(SEXP flag) {
  R_PreserveObject(flag);
  pflag = flag;
  int ret = pthread_create(
    & tick_thread,
    /* attr = */ 0,
    clic_thread_func,
    /* arg = */ LOGICAL(flag)
  );
  if (ret) warning("Cannot create cli tick thread");
  return R_NilValue;
}

SEXP clic_stop_thread() {
  if (tick_thread) pthread_cancel(tick_thread);
  memset(&tick_thread, 0, sizeof tick_thread);
  if (pflag) {
    R_ReleaseObject(pflag);
    pflag = 0;
  }
  return R_NilValue;
}

SEXP clic_tick_reset() {
  if (flag) *flag = 0;
  return R_NilValue;
}
