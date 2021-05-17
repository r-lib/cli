
#ifndef CLI_H
#define CLI_H

#include <R.h>
#include <Rinternals.h>

extern int* cli_timer_flag;
SEXP cli_progress_bar(int **ptr, int total);
void cli_progress_set_name(SEXP bar, const char *name);
void cli_progress_set_status(SEXP bar, const char *name);
void cli_progress_set_type(SEXP bar, const char *name);
void cli_progress_set_format(SEXP bar, const char *name);
void cli_progress_set_estimate(SEXP bar, int estimate, int auto_estimate);
void cli_progress_set_clear(SEXP bar, int);
void cli_progress_set(SEXP bar, int set);
void cli_progress_add(SEXP bar, int inc);
void cli_progress_done(SEXP bar);

extern SEXP cli_pkgenv;

SEXP clic_start_thread(SEXP flag, SEXP pkgenv, SEXP ticktime);
SEXP clic_stop_thread();
SEXP clic_tick_reset();
SEXP clic_get_time();

#endif
