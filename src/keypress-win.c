
/* Avoid warning about empty compilation unit. */
void keypress_win_dummy(void) { }

#ifdef WIN32

#include "errors.h"
#include "keypress.h"
#include "keypress-internal.h"
#include <windows.h>
#include <R_ext/Utils.h>		/* R_CheckUserInterrupt */

static HANDLE console_in, console_out;

static int enableRawMode(void) {
  if (!console_in) {
    HANDLE hin, hout;
    hin = GetStdHandle(STD_INPUT_HANDLE);
    if (hin == INVALID_HANDLE_VALUE) {
      R_THROW_SYSTEM_ERROR("Cannot get standard input handle");
    }
    hout = GetStdHandle(STD_OUTPUT_HANDLE);
    if (hout == INVALID_HANDLE_VALUE) {
      R_THROW_SYSTEM_ERROR("Cannot get standard output handle");
    }
    console_in = hin;
    console_out = hout;
  }
  return 0;
}

static int disableRawMode(void) {
  /* Nothing to do yet */
  return 0;
}

// Below not needed for Windows terminal

SEXP save_term_status(void) {
  return R_NilValue;
}

SEXP restore_term_status(void) {
  return R_NilValue;
}

SEXP set_term_echo(SEXP s_echo) {
  return R_NilValue;
}

SEXP test_single_char(SEXP s_bytes) {
  error("test_single_char is not supported on Windows");
  return R_NilValue;
}

SEXP test_function_key(SEXP s_bytes) {
  error("test_function_key is not supported on Windows");
  return R_NilValue;
}

keypress_key_t getWinChar(int block, double timeout) {
  INPUT_RECORD rec;
  DWORD count;
  DWORD waitres;
  int infinite = timeout < 0 || !R_FINITE(timeout);
  ULONGLONG deadline =
    infinite ? 0 : GetTickCount64() + (ULONGLONG)(timeout * 1000.0);
  char buf[KEYPRESS_UTF8_BUFFER_SIZE + 1] = { 0 };
  WCHAR wbuf[2];
  int wlen;
  int chr;
  /* Holds a pending UTF-16 high surrogate between two key events, since
     characters outside the BMP (e.g. emoji) arrive as two WCHARs. */
  static WCHAR high_surrogate = 0;

  for (;;) {

    GetNumberOfConsoleInputEvents(console_in, &count);

    if (count == 0) {
      if (block == NON_BLOCKING) {
        return keypress_special(KEYPRESS_NONE);
      }
      /* Interruptible wait, the Windows equivalent of poll() on Unix.
         The console input handle is signalled when input is available.
         We wait in chunks of at most 100ms so we can check for an R user
         interrupt (e.g. Ctrl+C / Esc in RStudio) between waits, while
         honouring the overall timeout (if any). */
      DWORD wait_ms = 100;
      if (!infinite) {
        ULONGLONG now = GetTickCount64();
        if (now >= deadline) return keypress_special(KEYPRESS_NONE);
        ULONGLONG remaining = deadline - now;
        if (remaining < wait_ms) wait_ms = (DWORD) remaining;
      }
      waitres = WaitForSingleObject(console_in, wait_ms);
      if (waitres == WAIT_TIMEOUT) {
        R_CheckUserInterrupt();
        continue;
      } else if (waitres == WAIT_FAILED) {
        R_THROW_SYSTEM_ERROR("Cannot wait for console input");
      }
    }

    if (! ReadConsoleInputW(console_in, &rec, 1, &count)) {
      R_THROW_SYSTEM_ERROR("Cannot read from console");
    }
    if (rec.EventType != KEY_EVENT) continue;
    if (! rec.Event.KeyEvent.bKeyDown) continue;
    chr = rec.Event.KeyEvent.uChar.UnicodeChar;

    switch (rec.Event.KeyEvent.wVirtualKeyCode) {

    case VK_RETURN: return keypress_special(KEYPRESS_ENTER);
    case VK_BACK:   return keypress_special(KEYPRESS_BACKSPACE);
    case VK_LEFT:   return keypress_special(KEYPRESS_LEFT);
    case VK_RIGHT:  return keypress_special(KEYPRESS_RIGHT);
    case VK_UP:     return keypress_special(KEYPRESS_UP);
    case VK_DOWN:   return keypress_special(KEYPRESS_DOWN);
    case VK_INSERT: return keypress_special(KEYPRESS_INSERT);
    case VK_DELETE: return keypress_special(KEYPRESS_DELETE);
    case VK_HOME:   return keypress_special(KEYPRESS_HOME);
    case VK_END:    return keypress_special(KEYPRESS_END);
    case VK_ESCAPE: return keypress_special(KEYPRESS_ESCAPE);

    case VK_F1:     return keypress_special(KEYPRESS_F1);
    case VK_F2:     return keypress_special(KEYPRESS_F2);
    case VK_F3:     return keypress_special(KEYPRESS_F3);
    case VK_F4:     return keypress_special(KEYPRESS_F4);
    case VK_F5:     return keypress_special(KEYPRESS_F5);
    case VK_F6:     return keypress_special(KEYPRESS_F6);
    case VK_F7:     return keypress_special(KEYPRESS_F7);
    case VK_F8:     return keypress_special(KEYPRESS_F8);
    case VK_F9:     return keypress_special(KEYPRESS_F9);
    case VK_F10:    return keypress_special(KEYPRESS_F10);
    case VK_F11:    return keypress_special(KEYPRESS_F11);
    case VK_F12:    return keypress_special(KEYPRESS_F12);

    default:
      if (rec.Event.KeyEvent.dwControlKeyState &
	  (LEFT_CTRL_PRESSED | RIGHT_CTRL_PRESSED)) {
	switch (chr) {
	case 1: return keypress_special(KEYPRESS_CTRL_A);
	case 2: return keypress_special(KEYPRESS_CTRL_B);
	case 3: return keypress_special(KEYPRESS_CTRL_C);
	case 4: return keypress_special(KEYPRESS_CTRL_D);
	case 5: return keypress_special(KEYPRESS_CTRL_E);
	case 6: return keypress_special(KEYPRESS_CTRL_F);
	case 8: return keypress_special(KEYPRESS_CTRL_H);
	case 9: return keypress_special(KEYPRESS_TAB);
	case 11: return keypress_special(KEYPRESS_CTRL_K);
	case 12: return keypress_special(KEYPRESS_CTRL_L);
	case 14: return keypress_special(KEYPRESS_CTRL_N);
	case 16: return keypress_special(KEYPRESS_CTRL_P);
	case 20: return keypress_special(KEYPRESS_CTRL_T);
	case 21: return keypress_special(KEYPRESS_CTRL_U);
	case 22: return keypress_special(KEYPRESS_CTRL_W);
	}
      } else if (chr) {
	/* Combine surrogate pairs into a single code point. A high
	   surrogate is buffered until its low surrogate arrives. */
	if (chr >= 0xD800 && chr <= 0xDBFF) {
	  high_surrogate = (WCHAR) chr;
	  continue;
	}
	if (chr >= 0xDC00 && chr <= 0xDFFF) {
	  if (!high_surrogate) continue;   /* lone low surrogate, ignore */
	  wbuf[0] = high_surrogate;
	  wbuf[1] = (WCHAR) chr;
	  wlen = 2;
	  high_surrogate = 0;
	} else {
	  high_surrogate = 0;
	  wbuf[0] = (WCHAR) chr;
	  wlen = 1;
	}
	count = WideCharToMultiByte(
	  CP_UTF8, 0, wbuf, wlen, buf, KEYPRESS_UTF8_BUFFER_SIZE, NULL, NULL);
	if (count == 0) continue;        /* conversion failed, skip */
	buf[count] = '\0';
	return keypress_utf8(buf);
      }
    }

  }
}

keypress_key_t keypress_read_timeout(int block, double timeout) {

  keypress_key_t res;

  CONSOLE_SCREEN_BUFFER_INFO inf;

  enableRawMode();

  if (! GetConsoleScreenBufferInfo(console_out, &inf)) {
    R_THROW_SYSTEM_ERROR("Cannot query console information");
  }

  res = getWinChar(block, timeout);

  disableRawMode();

  return res;
}

#endif
