
#include "cli.h"

void cli_progress_bar(int **ptr) {
  *ptr = cli_timer_flag;
}

void cli_progress_update() {
  REprintf(".");
  *cli_timer_flag = 0;
}
