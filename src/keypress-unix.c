
/* Avoid warning about empty compilation unit. */
void keypress_unix_dummy(void) { }

#ifndef _WIN32

#include "errors.h"
#include "keypress.h"
#include "keypress-internal.h"
#include "cleancall.h"
#include <unistd.h>
#include <termios.h>
#include <string.h>
#include <fcntl.h>
#include <poll.h>
#include <errno.h>
#include <sys/time.h>
#include <R_ext/Utils.h>		/* R_CheckUserInterrupt */

/* Milliseconds since some unspecified epoch, used to track timeouts. */
static double keypress_now_ms(void) {
  struct timeval tv;
  gettimeofday(&tv, NULL);
  return (double) tv.tv_sec * 1000.0 + (double) tv.tv_usec / 1000.0;
}

keypress_key_t single_char(const char *buf) {

  int ch = buf[0];

  switch(ch) {
  case   1: return keypress_special(KEYPRESS_CTRL_A);
  case   2: return keypress_special(KEYPRESS_CTRL_B);
  case   3: return keypress_special(KEYPRESS_CTRL_C);
  case   4: return keypress_special(KEYPRESS_CTRL_D);
  case   5: return keypress_special(KEYPRESS_CTRL_E);
  case   6: return keypress_special(KEYPRESS_CTRL_F);
  case   8: return keypress_special(KEYPRESS_CTRL_H);
  case   9: return keypress_special(KEYPRESS_TAB);
  case  10: return keypress_special(KEYPRESS_ENTER);
  case  11: return keypress_special(KEYPRESS_CTRL_K);
  case  12: return keypress_special(KEYPRESS_CTRL_L);
  case  13: return keypress_special(KEYPRESS_ENTER);
  case  14: return keypress_special(KEYPRESS_CTRL_N);
  case  16: return keypress_special(KEYPRESS_CTRL_P);
  case  20: return keypress_special(KEYPRESS_CTRL_T);
  case  21: return keypress_special(KEYPRESS_CTRL_U);
  case  23: return keypress_special(KEYPRESS_CTRL_W);
  case  27: return keypress_special(KEYPRESS_ESCAPE);
  case 127: return keypress_special(KEYPRESS_BACKSPACE);
  default : return keypress_utf8(buf);
  }
}

keypress_key_t function_key(const char *buf, size_t buf_size) {
  buf++;			/* escape character */
  buf_size -= 2;		/* minus first escape and trailing zero */

  /* xterm */
  if (! strncmp(buf, "[A", buf_size)) {
    return keypress_special(KEYPRESS_UP);
  } else if (!strncmp(buf, "[B", buf_size)) {
    return keypress_special(KEYPRESS_DOWN);
  } else if (!strncmp(buf, "[C", buf_size)) {
    return keypress_special(KEYPRESS_RIGHT);
  } else if (!strncmp(buf, "[D", buf_size)) {
    return keypress_special(KEYPRESS_LEFT);
  } else if (!strncmp(buf, "[F", buf_size)) {
    return keypress_special(KEYPRESS_END);
  } else if (!strncmp(buf, "[H", buf_size)) {
    return keypress_special(KEYPRESS_HOME);

    /* xterm/gnome */
  } else if (!strncmp(buf, "OA", buf_size)) {
    return keypress_special(KEYPRESS_UP);
  } else if (!strncmp(buf, "OB", buf_size)) {
    return keypress_special(KEYPRESS_DOWN);
  } else if (!strncmp(buf, "OC", buf_size)) {
    return keypress_special(KEYPRESS_RIGHT);
  } else if (!strncmp(buf, "OD", buf_size)) {
    return keypress_special(KEYPRESS_LEFT);
  } else if (!strncmp(buf, "OF", buf_size)) {
    return keypress_special(KEYPRESS_END);
  } else if (!strncmp(buf, "OH", buf_size)) {
    return keypress_special(KEYPRESS_HOME);

    /* xterm/rxvt */
  } else if (!strncmp(buf, "[1~", buf_size)) {
    return keypress_special(KEYPRESS_HOME);
  } else if (!strncmp(buf, "[2~", buf_size)) {
    return keypress_special(KEYPRESS_INSERT);
  } else if (!strncmp(buf, "[3~", buf_size)) {
    return keypress_special(KEYPRESS_DELETE);
  } else if (!strncmp(buf, "[4~", buf_size)) {
    return keypress_special(KEYPRESS_END);
  } else if (!strncmp(buf, "[5~", buf_size)) {
    return keypress_special(KEYPRESS_PAGEUP);
  } else if (!strncmp(buf, "[6~", buf_size)) {
    return keypress_special(KEYPRESS_PAGEDOWN);

    /* putty */
  } else if (!strncmp(buf, "[[5~", buf_size)) {
    return keypress_special(KEYPRESS_PAGEUP);
  } else if (!strncmp(buf, "[[6~", buf_size)) {
    return keypress_special(KEYPRESS_PAGEDOWN);

    /* rxvt */
  } else if (!strncmp(buf, "[[7~", buf_size)) {
    return keypress_special(KEYPRESS_HOME);
  } else if (!strncmp(buf, "[[8~", buf_size)) {
    return keypress_special(KEYPRESS_END);

    /* xterm/gnome */
  } else if (!strncmp(buf, "OP", buf_size)) {
    return keypress_special(KEYPRESS_F1);
  } else if (!strncmp(buf, "OQ", buf_size)) {
    return keypress_special(KEYPRESS_F2);
  } else if (!strncmp(buf, "OR", buf_size)) {
    return keypress_special(KEYPRESS_F3);
  } else if (!strncmp(buf, "OS", buf_size)) {
    return keypress_special(KEYPRESS_F4);

    /* common */
  } else if (!strncmp(buf, "[15~", buf_size)) {
    return keypress_special(KEYPRESS_F5);
  } else if (!strncmp(buf, "[17~", buf_size)) {
    return keypress_special(KEYPRESS_F6);
  } else if (!strncmp(buf, "[18~", buf_size)) {
    return keypress_special(KEYPRESS_F7);
  } else if (!strncmp(buf, "[19~", buf_size)) {
    return keypress_special(KEYPRESS_F8);
  } else if (!strncmp(buf, "[20~", buf_size)) {
    return keypress_special(KEYPRESS_F9);
  } else if (!strncmp(buf, "[21~", buf_size)) {
    return keypress_special(KEYPRESS_F10);
  } else if (!strncmp(buf, "[23~", buf_size)) {
    return keypress_special(KEYPRESS_F11);
  } else if (!strncmp(buf, "[24~", buf_size)) {
    return keypress_special(KEYPRESS_F12);

    /* xterm / rxvt */
  } else if (!strncmp(buf, "[11~", buf_size)) {
    return keypress_special(KEYPRESS_F1);
  } else if (!strncmp(buf, "[12~", buf_size)) {
    return keypress_special(KEYPRESS_F2);
  } else if (!strncmp(buf, "[13~", buf_size)) {
    return keypress_special(KEYPRESS_F3);
  } else if (!strncmp(buf, "[14~", buf_size)) {
    return keypress_special(KEYPRESS_F4);

  } else if (strlen(buf) == 0) {
    return keypress_special(KEYPRESS_ESCAPE);

  } else {
    return keypress_utf8(buf - 1);
  }

  return keypress_special(KEYPRESS_UNKNOWN);
}

static struct termios orig_term = { 0 };

SEXP save_term_status(void) {
  if (tcgetattr(0, &orig_term) < 0) {
    R_THROW_SYSTEM_ERROR("Cannot query terminal flags");
  }
  return R_NilValue;
}

SEXP restore_term_status(void) {
  if (tcsetattr(0, TCSANOW, &orig_term) < 0) {
    R_THROW_SYSTEM_ERROR("Cannot restore terminal flags");
  }
  return R_NilValue;
}

SEXP set_term_echo(SEXP s_echo) {
  int echo = LOGICAL(s_echo)[0];

  struct termios term = { 0 };
  if (tcgetattr(0, &term) < 0) {
    R_THROW_SYSTEM_ERROR("Cannot query terminal flags");
  }

  if (echo == 0) term.c_lflag &= ~ECHO;
  else term.c_lflag |= ECHO;

  if (tcsetattr(0, TCSANOW, &term) < 0) {
    R_THROW_SYSTEM_ERROR("Cannot query terminal flags");
  }

  return R_NilValue;
}

static struct keypress_term_state {
  struct termios term;
  int flags;
  int active;
} keypress_state = { { 0 }, 0, 0 };

static void keypress_restore(void *data) {
  struct keypress_term_state *st = data;
  if (!st->active) return;
  st->active = 0;
  fcntl(0, F_SETFL, st->flags);
  tcsetattr(0, TCSADRAIN, &st->term);
}

keypress_key_t keypress_read_timeout(int block, double timeout) {

  char buf[11] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
  struct termios term = { 0 };
  int flags = fcntl(0, F_GETFL, 0);

  if (tcgetattr(0, &term) < 0) {
    R_THROW_SYSTEM_ERROR("Cannot query terminal flags");
  }

  /* Original state to restore */
  keypress_state.term = term;
  keypress_state.flags = flags;
  keypress_state.active = 1;
  r_call_on_exit(keypress_restore, &keypress_state);

  term.c_lflag &= ~ICANON;
  term.c_lflag &= ~ECHO;
  term.c_cc[VMIN] = 1;
  term.c_cc[VTIME] = 0;

  if (tcsetattr(0, TCSANOW, &term) < 0) {
    R_THROW_SYSTEM_ERROR("Cannot set canonical mode");
  }

  if (block) {
    /* Interruptible read, optionally bounded by a timeout. We poll in
       chunks of at most 100ms so we can check for an R user interrupt
       between waits; an infinite timeout (negative or non-finite) just
       keeps polling forever. */
    struct pollfd pfd = { 0, POLLIN, 0 };
    int infinite = timeout < 0 || !R_FINITE(timeout);
    double deadline = infinite ? 0 : keypress_now_ms() + timeout * 1000.0;
    for (;;) {
      int wait_ms = 100;
      if (!infinite) {
        double remaining = deadline - keypress_now_ms();
        /* Timed out: the registered cleanup restores the terminal. */
        if (remaining <= 0) return keypress_special(KEYPRESS_NONE);
        if (remaining < wait_ms) wait_ms = (int) remaining;
      }
      int ret = poll(&pfd, 1, wait_ms);
      if (ret > 0) break;
      if (ret < 0 && errno != EINTR) {
        R_THROW_SYSTEM_ERROR("Cannot poll terminal");
      }
      R_CheckUserInterrupt();
    }
  } else {
    if (fcntl(0, F_SETFL, flags | O_NONBLOCK) == -1) {
      R_THROW_SYSTEM_ERROR("Cannot set terminal to non-blocking");
    }
  }

  if (read(0, buf, 1) < 0) {
    if (block) {
      R_THROW_SYSTEM_ERROR("Cannot read key");
    } else {
      return keypress_special(KEYPRESS_NONE);
    }
  }

  /* If an escape sequence, then we read the rest.
     We cannot read everything in one go, because of
     copy-and-paste. This way for a copy-and-paste
     we only read the first character. */

  if (buf[0] == '\033') {
    /* At least two more characters are needed. We do a non-blocking
       read to detect if the user only pressed ESC */
    ssize_t chars = 0;
    if (fcntl(0, F_SETFL, flags | O_NONBLOCK) == -1) {
      R_THROW_SYSTEM_ERROR("Cannot set terminal flags");
    }
    chars = read(0, buf + 1, 2);
    if (fcntl(0, F_SETFL, flags) == -1) {
      R_THROW_SYSTEM_ERROR("Cannot set terminal flags");
    }
    if (chars == 2 && buf[1] == '[' && buf[2] >= '1' && buf[2] <= '6') {
      /* A third one is needed, too */
      if (read(0, buf + 3, 1) < 0) {
        R_THROW_SYSTEM_ERROR("Cannot read from terminal");
      }
      if (buf[3] >= '0' && buf[3] <= '9') {
        /* A fourth one is needed, too */
        if (read(0, buf + 4, 1) < 0) {
          R_THROW_SYSTEM_ERROR("Cannot read from terminal");
        }
      }
    } else if (chars == 2 && buf[1] == '[' && buf[2] == '[') {
      /* Two more is needed if it starts with [[ */
      if (read(0, buf + 3, 2) < 0) {
        R_THROW_SYSTEM_ERROR("Cannot read from terminal");
      }
    }
  }

  /* For UTF8 characters, we might need to read more bytes
     We don't handle errors here, if there are not enough bytes
     to read, we'll just return whatever is available. */
  if ((buf[0] & 0x80) == 0) {
    /* Nothing to do */
  } else if ((buf[0] & 0xe0) == 0xc0) {
    if (read(0, &buf[1], 1) < 0) {
      R_THROW_SYSTEM_ERROR("Cannot read from terminal");
    }
  } else if ((buf[0] & 0xf0) == 0xe0) {
    if (read(0, &buf[1], 2) < 0) {
      R_THROW_SYSTEM_ERROR("Cannot read from terminal");
    }
  } else if ((buf[0] & 0xf8) == 0xf0) {
    if (read(0, &buf[1], 3) < 0) {
      R_THROW_SYSTEM_ERROR("Cannot read from terminal");
    }
  }

  if (buf[0] == '\033') {
    /* Some excape sequence */
    return function_key(buf, sizeof(buf));
  }  else {
    /* Single character */
    return single_char(buf);
  }
}

static SEXP key_to_sexp(keypress_key_t key) {
  if (key.code == KEYPRESS_CHAR) {
    return ScalarString(mkCharCE(key.utf8, CE_UTF8));
  } else {
    return ScalarString(mkCharCE(keypress_key_names[key.code], CE_UTF8));
  }
}

SEXP test_single_char(SEXP s_bytes) {
  if (TYPEOF(s_bytes) != RAWSXP || XLENGTH(s_bytes) < 1) {
    error("'bytes' must be a raw vector of length >= 1");
  }
  char buf[2] = { 0, 0 };
  buf[0] = (char) RAW(s_bytes)[0];
  return key_to_sexp(single_char(buf));
}

SEXP test_function_key(SEXP s_bytes) {
  if (TYPEOF(s_bytes) != RAWSXP) {
    error("'bytes' must be a raw vector");
  }
  char buf[11] = { 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
  buf[0] = '\033';
  R_xlen_t n = XLENGTH(s_bytes);
  if (n > 9) n = 9;
  if (n > 0) memcpy(buf + 1, RAW(s_bytes), (size_t) n);
  return key_to_sexp(function_key(buf, sizeof(buf)));
}

#endif
