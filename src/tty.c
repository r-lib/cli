
#include "cli.h"
#include "errors.h"
#include "cleancall.h"

#ifdef WIN32
#include <windows.h>
#else
#include <sys/ioctl.h>
#include <stdio.h>
#include <unistd.h>
#endif

SEXP clic_tty_size() {
  SEXP result = NULL;

#ifdef WIN32
  CONSOLE_SCREEN_BUFFER_INFO info;
  BOOL ok = GetConsoleScreenBufferInfo(
    GetStdHandle(STD_OUTPUT_HANDLE),
    &info
  );
  if (!ok) R_THROW_SYSTEM_ERROR("Cannot determine terminal size");
  result = Rf_allocVector(INTSXP, 2);
  INTEGER(result)[0] = info.srWindow.Right  - info.srWindow.Left + 1;
  INTEGER(result)[1] = info.srWindow.Bottom - info.srWindow.Top + 1;
#else
  struct winsize w;
  int err = ioctl(STDOUT_FILENO, TIOCGWINSZ, &w);
  if (err == -1) R_THROW_SYSTEM_ERROR("Cannot determine terminale size");

  result = Rf_allocVector(INTSXP, 2);
  INTEGER(result)[0] = w.ws_col;
  INTEGER(result)[1] = w.ws_row;
#endif

  return result;
}
