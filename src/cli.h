
#ifndef CLI_H
#define CLI_H

#include <R.h>
#include <Rinternals.h>

SEXP clic_start_thread(SEXP flag);
SEXP clic_stop_thread();
SEXP clic_tick_reset();

#endif
