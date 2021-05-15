
#include "cli.h"

#include <pthread.h>
#include <time.h>

SEXP cli_pkgenv = 0;
static SEXP pflag = 0;
static pthread_t tick_thread = { 0 };
int* cli_timer_flag = 0;

void* clic_thread_func(void *arg) {
  cli_timer_flag = (int*) arg;
  struct timespec sp;
  sp.tv_sec = 0;
  sp.tv_nsec = 100 * 1000 * 1000;

  while (1) {
    /* TODO: handle signals */
    nanosleep(&sp, NULL);
    *cli_timer_flag = 1;
  }
}

SEXP clic_start_thread(SEXP flag, SEXP pkg) {
  R_PreserveObject(pkg);
  R_PreserveObject(flag);
  cli_pkgenv = pkg;
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
