#ifndef R_CLI_PROGRESS_H
#define R_CLI_PROGRESS_H

#include <R_ext/Rdynload.h>

static int cli__false = 0;
static int *cli__should_tick = &cli__false;

#ifndef __has_builtin         // Optional of course.
  #define __has_builtin(x) 0  // Compatibility with non-clang compilers.
#endif

#if __has_builtin (__builtin_expect)
#   define CLI_UNLIKELY(a) __builtin_expect((a), 0)
#   define CLI_LIKELY(a)   __builtin_expect((a), 1)
# else
#   define CLI_UNLIKELY(a) a
#   define CLI_LIKELY(a)   a
#endif

#define SHOULD_TICK (CLI_UNLIKELY(*cli__should_tick))

static R_INLINE SEXP cli_progress_bar() {
  static SEXP (*ptr)(int **timer) = NULL;
  if (ptr == NULL) {
    ptr = (SEXP (*)(int **timer)) R_GetCCallable("cli", "cli_progress_bar");
  }
  return ptr(&cli__should_tick);
}

static R_INLINE void cli_progress_set(SEXP bar, int set) {
  static void (*ptr)(SEXP, int) = NULL;
  if (ptr == NULL) {
    ptr = (void (*)(SEXP, int)) R_GetCCallable("cli", "cli_progress_set");
  }
  ptr(bar, set);
}

static R_INLINE void cli_progress_add(SEXP bar, int inc) {
  static void (*ptr)(SEXP, int) = NULL;
  if (ptr == NULL) {
    ptr = (void (*)(SEXP, int)) R_GetCCallable("cli", "cli_progress_add");
  }
  ptr(bar, inc);
}

static R_INLINE void cli_progress_done(SEXP bar) {
  static void (*ptr)(SEXP) = NULL;
  if (ptr == NULL) {
    ptr = (void (*)(SEXP)) R_GetCCallable("cli", "cli_progress_done");
  }
  ptr(bar);
}

#endif
