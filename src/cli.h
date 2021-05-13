
#ifndef CLI_H
#define CLI_H

#include <R.h>
#include <Rinternals.h>

extern int* cli_timer_flag;
void cli_progress_bar(int **ptr);
void cli_progress_update();

SEXP clic_start_thread(SEXP flag);
SEXP clic_stop_thread();
SEXP clic_tick_reset();

#endif
