#ifndef R_CLI_PROGRESS_H
#define R_CLI_PROGRESS_H

#include <R_ext/Rdynload.h>
#include <stdarg.h>

typedef volatile int vint;

static vint cli__false = 0;
static vint *cli__should_tick = &cli__false;

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

static R_INLINE void cli_progress_done(SEXP bar) {
  static void (*ptr)(SEXP) = NULL;
  if (ptr == NULL) {
    ptr = (void (*)(SEXP)) R_GetCCallable("cli", "cli_progress_done");
  }
  ptr(bar);
}

static void cli_progress_done2(SEXP bar) {
  static void (*ptr)(SEXP) = NULL;
  if (ptr == NULL) {
    ptr = (void (*)(SEXP)) R_GetCCallable("cli", "cli_progress_done");
  }
  ptr(bar);
}

static R_INLINE SEXP cli_progress_bar(int total) {
  static SEXP (*ptr)(vint **, int) = NULL;
  if (ptr == NULL) {
    ptr = (SEXP (*)(vint **, int)) R_GetCCallable("cli", "cli_progress_bar");
  }

  SEXP bar = PROTECT(ptr(&cli__should_tick, total));

#ifdef R_CLEANCALL_SUPPORT
  if (r_cleancall_is_active()) {
    r_call_on_early_exit((void (*)(void *)) cli_progress_done2, (void*) bar);
  }
#endif

  UNPROTECT(1);
  return bar;
}

static R_INLINE void cli_progress_set_name(SEXP bar, const char *name) {
  static void (*ptr)(SEXP, const char*) = NULL;
  if (ptr == NULL) {
    ptr = (void (*)(SEXP, const char*))
      R_GetCCallable("cli", "cli_progress_set_name");
  }
  ptr(bar, name);
}

static R_INLINE void cli_progress_set_status(SEXP bar, const char *status) {
  static void (*ptr)(SEXP, const char*) = NULL;
  if (ptr == NULL) {
    ptr = (void (*)(SEXP, const char*))
      R_GetCCallable("cli", "cli_progress_set_status");
  }
  ptr(bar, status);
}

static R_INLINE void cli_progress_set_type(SEXP bar, const char *type) {
  static void (*ptr)(SEXP, const char*) = NULL;
  if (ptr == NULL) {
    ptr = (void (*)(SEXP, const char*))
      R_GetCCallable("cli", "cli_progress_set_type");
  }
  ptr(bar, type);
}

static R_INLINE void cli_progress_set_estimate(SEXP bar,
                                               int estimate,
                                               int auto_estimate) {
  static void (*ptr)(SEXP, int, int) = NULL;
  if (ptr == NULL) {
    ptr = (void (*)(SEXP, int, int))
      R_GetCCallable("cli", "cli_progress_set_estimate");
  }
  ptr(bar, estimate, auto_estimate);
}

static R_INLINE void cli_progress_set_clear(SEXP bar, int clear) {
  static void (*ptr)(SEXP, int) = NULL;
  if (ptr == NULL) {
    ptr = (void (*)(SEXP, int))
      R_GetCCallable("cli", "cli_progress_set_clear");
  }
  ptr(bar, clear);
}

static R_INLINE void cli_progress_set(SEXP bar, int set) {
  static void (*ptr)(SEXP, int) = NULL;
  if (ptr == NULL) {
    ptr = (void (*)(SEXP, int)) R_GetCCallable("cli", "cli_progress_set");
  }
  ptr(bar, set);
}

static R_INLINE void cli_progress_set_format(SEXP bar, const char *format, ...) {
  static void (*ptr)(SEXP, const char*) = NULL;
  static char str[1024];
  if (ptr == NULL) {
    ptr = (void (*)(SEXP, const char*))
      R_GetCCallable("cli", "cli_progress_set_format");
  }

  va_list ap;
  va_start(ap, format);
  vsnprintf(str, sizeof(str) / sizeof(char), format, ap);

  ptr(bar, str);
}

static R_INLINE void cli_progress_add(SEXP bar, int inc) {
  static void (*ptr)(SEXP, int) = NULL;
  if (ptr == NULL) {
    ptr = (void (*)(SEXP, int)) R_GetCCallable("cli", "cli_progress_add");
  }
  ptr(bar, inc);
}

static R_INLINE int cli_progress_num() {
  static int (*ptr)() = NULL;
  if (ptr == NULL) {
    ptr = (int (*)()) R_GetCCallable("cli", "cli_progress_num");
  }
  return ptr();
}

static R_INLINE void cli_progress_sleep(int s, long ns) {
  static void (*ptr)(int, long) = NULL;
  if (ptr == NULL) {
    ptr = (void (*)(int, long)) R_GetCCallable("cli", "cli_progress_sleep");
  }
  ptr(s, ns);
}

#endif
