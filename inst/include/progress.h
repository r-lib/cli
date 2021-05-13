#ifndef R_CLI_PROGRESS_H
#define R_CLI_PROGRESS_H

#include <R_ext/Rdynload.h>

static int cli__false = 0;
static int *cli__should_tick = &cli__false;

#if (defined(__GNUC__) && GCC_VERSION_MAJOR >= 3)
#  define CLI_UNLIKELY(a) __builtin_expect((a), 0)
#  define CLI_LIKELY(a)   __builtin_expect((a), 1)
#else
#  define CLI_UNLIKELY(a) a
#  define CLI_LIKELY(a)   a
#endif

#define SHOULD_TICK (CLI_UNLIKELY(*cli__should_tick))

static R_INLINE void cli_progress_bar() {
  static void (*ptr)(int **timer) = NULL;
  if (ptr == NULL) {
    ptr = (void (*)(int **timer)) R_GetCCallable("cli", "cli_progress_bar");
  }
  ptr(&cli__should_tick);
}

static R_INLINE void cli_progress_update() {
  static void (*ptr)() = NULL;
  if (ptr == NULL) {
    ptr = (void (*)()) R_GetCCallable("cli", "cli_progress_update");
  }
  ptr();
}

#endif
