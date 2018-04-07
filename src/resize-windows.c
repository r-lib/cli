
/* Avoid warning about empty compilation unit. */
void cli_resize_win_dummy() { }

#ifdef _WIN32

#include <R.h>
#include <Rinternals.h>

#include <stdio.h>
#include <windows.h>

SEXP get_screen_size() {
  int columns, rows;
  CONSOLE_SCREEN_BUFFER_INFO info;
  HANDLE tmpConsole = CreateConsoleScreenBuffer(GENERIC_READ, 0, NULL,
						CONSOLE_TEXTMODE_BUFFER,
						NULL);
  GetConsoleScreenBufferInfo(tmpConsole, &info);
  CloseHandle(tmpConsole);

  columns = info.dwMaximumWindowSize.X;
  rows = info.dwMaximumWindowSize.Y;

  Rprintf("COLUMNS=%d;\nLINES=%d;\n", columns, rows);

  return R_NilValue;
}

#endif
