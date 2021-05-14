
#ifndef CLI_H
#define CLI_H

#include <R.h>
#include <Rinternals.h>

extern int* cli_timer_flag;
SEXP cli_progress_bar(int **ptr);
void cli_progress_set(SEXP bar, int set);
void cli_progress_add(SEXP bar, int inc);
void cli_progress_done(SEXP bar);

SEXP clic_start_thread(SEXP flag);
SEXP clic_stop_thread();
SEXP clic_tick_reset();

#endif
