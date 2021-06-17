
#ifndef CLI_H
#define CLI_H

#include <R.h>
#include <Rinternals.h>
#include <Rversion.h>

typedef volatile int vint;

extern volatile int* cli_timer_flag;
extern int cli__reset;
void cli_progress_add(SEXP bar, int inc);
SEXP cli_progress_bar(vint **ptr, int total, SEXP config);
void cli_progress_done(SEXP bar);
void cli_progress_init_timer(vint **ptr);
int cli_progress_num();
void cli_progress_set(SEXP bar, int set);
void cli_progress_set_clear(SEXP bar, int);
void cli_progress_set_format(SEXP bar, const char *name);
void cli_progress_set_name(SEXP bar, const char *name);
void cli_progress_set_status(SEXP bar, const char *name);
void cli_progress_set_type(SEXP bar, const char *name);
void cli_progress_sleep(int s, long ns);
void cli_progress_update(SEXP bar, int set, int inc, int force);

SEXP cli__progress_update(SEXP bar);
SEXP clic_progress_along(SEXP seq, SEXP bar);
extern SEXP cli_pkgenv;

#if R_VERSION >= R_Version(3, 5, 0)
void cli_init_altrep(DllInfo *dll);
#endif

double clic__get_time();

SEXP clic_start_thread(SEXP pkgenv, SEXP tick, SEXP speed);
SEXP clic_stop_thread();
SEXP clic_tick_reset();
SEXP clic_get_time();
SEXP clic_tick_set(SEXP ticktime, SEXP speedtime);
SEXP clic_make_timer();
SEXP clic_update_due();

#endif
