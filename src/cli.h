
#ifndef CLI_H
#define CLI_H

#include <R.h>
#include <Rinternals.h>

typedef volatile int vint;

extern volatile int* cli_timer_flag;
SEXP cli_progress_bar(vint **ptr, int total);
void cli_progress_set_name(SEXP bar, const char *name);
void cli_progress_set_status(SEXP bar, const char *name);
void cli_progress_set_type(SEXP bar, const char *name);
void cli_progress_set_format(SEXP bar, const char *name);
void cli_progress_set_estimate(SEXP bar, int estimate, int auto_estimate);
void cli_progress_set_clear(SEXP bar, int);
void cli_progress_set(SEXP bar, int set);
void cli_progress_add(SEXP bar, int inc);
void cli_progress_done(SEXP bar);
void cli_progress_sleep(int s, long ns);
int cli_progress_num();

SEXP cli__progress_update(SEXP bar);
void cli_init_altrep(DllInfo *dll);
SEXP clic_tick_along(SEXP seq, SEXP bar);

extern SEXP cli_pkgenv;

double clic__get_time();

SEXP clic_start_thread(SEXP pkgenv, SEXP tick, SEXP speed);
SEXP clic_stop_thread();
SEXP clic_tick_reset();
SEXP clic_get_time();
SEXP clic_tick_set(SEXP ticktime, SEXP speedtime);
SEXP clic_make_timer();

#endif
