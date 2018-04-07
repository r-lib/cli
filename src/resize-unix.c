
/*
 * Copyright 2003-2012,2013 by Thomas E. Dickey
 *
 *                         All Rights Reserved
 *
 * Permission is hereby granted, free of charge, to any person obtaining a
 * copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be included
 * in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
 * OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
 * IN NO EVENT SHALL THE ABOVE LISTED COPYRIGHT HOLDER(S) BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * Except as contained in this notice, the name(s) of the above copyright
 * holders shall not be used in advertising or otherwise to promote the
 * sale, use or other dealings in this Software without prior written
 * authorization.
 *
 *
 * Copyright 1987 by Digital Equipment Corporation, Maynard, Massachusetts.
 *
 *                         All Rights Reserved
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose and without fee is hereby granted,
 * provided that the above copyright notice appear in all copies and that
 * both that copyright notice and this permission notice appear in
 * supporting documentation, and that the name of Digital Equipment
 * Corporation not be used in advertising or publicity pertaining to
 * distribution of the software without specific, written prior permission.
 *
 *
 * DIGITAL DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING
 * ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO EVENT SHALL
 * DIGITAL BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR
 * ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
 * WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,
 * ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS
 * SOFTWARE.
 */

/* resize.c */

/* Avoid warning about empty compilation unit. */
void cli_resize_unix_dummy() { }

/* We try this on everything that is not windows */
#ifndef _WIN32

#ifdef __linux__
#define USE_TERMIOS 1
#endif

#include <R.h>
#include <Rinternals.h>

#include <stdio.h>
#include <ctype.h>

#ifdef USE_TERMIOS
#include <termios.h>
#endif
#include <sgtty.h>
#include <errno.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>
#include <sys/time.h>

int ignore_unused;
#define IGNORE_RC(func) ignore_unused = (int) func
#define GCC_UNUSED /**/
#define CharOf(n) ((unsigned char)(n))
#define ENVP_ARG /**/
#define CastMallocN(type,n) (type *)malloc(sizeof(type) + (size_t) (n))
#define TypeMallocN(type,n) (type *)malloc(sizeof(type) * (size_t) (n))
#define DFT_TERMTYPE "xterm"
#define UIntClr(dst,bits) dst = dst & (unsigned) ~(bits)

char *
x_basename(char *name)
{
  char *cp;
  cp = strrchr(name, '/');
  return (cp ? cp + 1 : name);
}

char *
x_strdup(const char *s)
{
  char *result = 0;
  if (s != 0)
    {
      char *t = CastMallocN(char, strlen(s) + 1);
      if (t != 0)
	{
	  strcpy(t, s);
	}
      result = t;
    }
  return result;
}

char*
x_skip_blanks(char* s)
{
  while (isspace(CharOf(*s)))
    ++s;
  return s;
}

char *
x_nonempty(char *s)
{
  if (s != 0)
    {
      if (*s == '\0')
	{
	  s = 0;
	}
      else
	{
	  s = x_skip_blanks(s);
	  if (*s == '\0')
	    s = 0;
	}
    }
  return s;
}

char *
x_getenv(const char *name)
{
  char *result;
  result = x_strdup(x_nonempty(getenv(name)));
  return result;
}

#ifndef USE_TERMINFO		/* avoid conflict with configure script */
#if defined(__QNX__) || defined(__SCO__) || defined(linux) || defined(__OpenBSD__) || defined(__UNIXWARE__)
#define USE_TERMINFO
#endif
#endif

#if defined(__QNX__)
#include <unix.h>
#endif

/*
 * Some OS's may want to use both, like SCO for example.  We catch here anyone
 * who hasn't decided what they want.
 */
#if !defined(USE_TERMCAP) && !defined(USE_TERMINFO)
#define USE_TERMINFO
#endif

#include <signal.h>
#include <pwd.h>

#ifdef USE_IGNORE_RC
int ignore_unused;
#endif

#ifdef __MVS__
#define ESCAPE(string) "\047" string
#else
#define ESCAPE(string) "\033" string
#endif

#define	EMULATIONS	2
#define	SUN		1
#define	VT100		0

#define	TIMEOUT		10

static const char *getsize[EMULATIONS] =
  {
    ESCAPE("7") ESCAPE("[r") ESCAPE("[999;999H") ESCAPE("[6n"),
    ESCAPE("[18t"),
  };
#if defined(USE_STRUCT_WINSIZE)
static const char *getwsize[EMULATIONS] =
  {				/* size in pixels */
    0,
    ESCAPE("[14t"),
  };
#endif /* USE_STRUCT_WINSIZE */
static const char *restore[EMULATIONS] =
  {
    ESCAPE("8"),
    0,
  };

#ifdef USE_ANY_SYSV_TERMIO
static struct termio tioorig;
#elif defined(USE_TERMIOS)
static struct termios tioorig;
#else
static struct sgttyb sgorig;
#endif /* USE_ANY_SYSV_TERMIO/USE_TERMIOS */

static const char *size[EMULATIONS] =
  {
    ESCAPE("[%d;%dR"),
    ESCAPE("[8;%d;%dt"),
  };
static int tty;
static FILE *ttyfp;

#if defined(USE_STRUCT_WINSIZE)
static const char *wsize[EMULATIONS] = {
    0,
    ESCAPE("[4;%hd;%hdt"),
  };
#endif /* USE_STRUCT_WINSIZE */


static void failed(const char *s) {
  error(s);
}


/* ARGSUSED */
static void
onintr(int sig GCC_UNUSED) {
#ifdef USE_ANY_SYSV_TERMIO
  (void) ioctl(tty, TCSETAW, &tioorig);
#elif defined(USE_TERMIOS)
  (void) tcsetattr(tty, TCSADRAIN, &tioorig);
#else /* not USE_TERMIOS */
  (void) ioctl(tty, TIOCSETP, &sgorig);
#endif /* USE_ANY_SYSV_TERMIO/USE_TERMIOS */
}


static void resize_timeout(int sig) {
  onintr(sig);
  error("get_sceen_size: time out occurred");
}

#ifdef USE_TERMCAP

static void print_termcap(const char *termcap) {
  int ch;

  Rprintf("'");
  while ((ch = *termcap++) != '\0') {
    switch (ch & 0xff) {
    case 127:		/* undo bug in GNU termcap */
      Rprintf("^?");
      break;
    case '\'':		/* must escape anyway (unlikely) */
      /* FALLTHRU */
    case '!':		/* must escape for SunOS csh */
      Rprintf("\\");
      /* FALLTHRU */
    default:
      Rprintf(ch);
      break;
    }
  }
  Rprintf("'");
}
#endif /* USE_TERMCAP */


static void readstring(FILE *fp, char *buf, const char *str) {
  int last, c;
#if !defined(USG)
  /* What is the advantage of setitimer() over alarm()? */
  struct itimerval it;
#endif

  signal(SIGALRM, resize_timeout);
#if defined(USG)
  alarm(TIMEOUT);
#else
  memset((char *) &it, 0, sizeof(struct itimerval));
  it.it_value.tv_sec = TIMEOUT;
  setitimer(ITIMER_REAL, &it, (struct itimerval *) NULL);
#endif
  if ((c = getc(fp)) == 0233) {	/* meta-escape, CSI */
    c = ESCAPE("")[0];
    *buf++ = (char) c;
    *buf++ = '[';
  } else {
    *buf++ = (char) c;
  }
  if (c != *str) {
    onintr(0);
    error("get_screen_size: unknown character, exiting");
  }
  last = str[strlen(str) - 1];
  while ((*buf++ = (char) getc(fp)) != last) {
    ;
  }
#if defined(USG)
  alarm(0);
#else
  memset((char *) &it, 0, sizeof(struct itimerval));
  setitimer(ITIMER_REAL, &it, (struct itimerval *) NULL);
#endif
  *buf = 0;
}

/*
  resets termcap string to reflect current screen size
*/

SEXP get_screen_size() {

#ifdef USE_TERMCAP
  char *env;
#endif
  int emu = VT100;
  int rc;
  int rows, cols;
#ifdef USE_ANY_SYSV_TERMIO
  struct termio tio;
#elif defined(USE_TERMIOS)
  struct termios tio;
#else
  struct sgttyb sg;
#endif /* USE_ANY_SYSV_TERMIO/USE_TERMIOS */
#ifdef USE_TERMCAP
  int ok_tcap = 1;
  char termcap[TERMCAP_SIZE];
  char newtc[TERMCAP_SIZE];
#endif /* USE_TERMCAP */
  char buf[BUFSIZ];
#ifdef TTYSIZE_STRUCT
  TTYSIZE_STRUCT ts;
#endif
  char *name_of_tty;
#ifdef CANT_OPEN_DEV_TTY
  extern char *ttyname();
#endif

#ifdef CANT_OPEN_DEV_TTY
  if ((name_of_tty = ttyname(fileno(stderr))) == NULL)
#endif
    name_of_tty = x_strdup("/dev/tty");

  if ((ttyfp = fopen(name_of_tty, "r+")) == NULL) {
    error("get_screen_size:  can't open terminal %s", name_of_tty);
  }
  tty = fileno(ttyfp);
#ifdef USE_TERMCAP
  if ((env = x_getenv("TERM")) == 0) {
    env = DFT_TERMTYPE;
  }
  termcap[0] = 0;		/* ...just in case we've accidentally gotten terminfo */
  if (tgetent(termcap, env) <= 0 || termcap[0] == 0) {
    ok_tcap = 0;
  }
#endif /* USE_TERMCAP */
#ifdef USE_TERMINFO
#endif /* USE_TERMINFO */

#ifdef USE_ANY_SYSV_TERMIO
  rc = ioctl(tty, TCGETA, &tioorig);
  tio = tioorig;
  UIntClr(tio.c_iflag, (ICRNL | IUCLC));
  UIntClr(tio.c_lflag, (ICANON | ECHO));
  tio.c_cflag |= CS8;
  tio.c_cc[VMIN] = 6;
  tio.c_cc[VTIME] = 1;
#elif defined(USE_TERMIOS)
  rc = tcgetattr(tty, &tioorig);
  tio = tioorig;
  UIntClr(tio.c_iflag, ICRNL);
  UIntClr(tio.c_lflag, (ICANON | ECHO));
  tio.c_cflag |= CS8;
  tio.c_cc[VMIN] = 6;
  tio.c_cc[VTIME] = 1;
#else /* not USE_TERMIOS */
  rc = ioctl(tty, TIOCGETP, &sgorig);
  sg = sgorig;
  sg.sg_flags |= RAW;
  UIntClr(sg.sg_flags, ECHO);
#endif /* USE_ANY_SYSV_TERMIO/USE_TERMIOS */
  if (rc != 0)
    failed("get tty settings");

  signal(SIGINT, onintr);
  signal(SIGQUIT, onintr);
  signal(SIGTERM, onintr);

#ifdef USE_ANY_SYSV_TERMIO
  rc = ioctl(tty, TCSETAW, &tio);
#elif defined(USE_TERMIOS)
  rc = tcsetattr(tty, TCSADRAIN, &tio);
#else /* not USE_TERMIOS */
  rc = ioctl(tty, TIOCSETP, &sg);
#endif /* USE_ANY_SYSV_TERMIO/USE_TERMIOS */
  if (rc != 0)
    failed("set tty settings");

  IGNORE_RC(write(tty, getsize[emu], strlen(getsize[emu])));
  readstring(ttyfp, buf, size[emu]);
  if (sscanf(buf, size[emu], &rows, &cols) != 2) {
    onintr(0);
    error("get_screen_size: Can't get rows and columns");
  }
  if (restore[emu])
    IGNORE_RC(write(tty, restore[emu], strlen(restore[emu])));
#if defined(USE_STRUCT_WINSIZE)
  /* finally, set the tty's window size */
  if (getwsize[emu]) {
    /* get the window size in pixels */
    IGNORE_RC(write(tty, getwsize[emu], strlen(getwsize[emu])));
    readstring(ttyfp, buf, wsize[emu]);
    if (sscanf(buf, wsize[emu], &ts.ws_xpixel, &ts.ws_ypixel) != 2) {
      onintr(0);
      error("get_screen_size: Can't get window size");
    }
    TTYSIZE_ROWS(ts) = (ttySize_t) rows;
    TTYSIZE_COLS(ts) = (ttySize_t) cols;
    SET_TTYSIZE(tty, ts);
  } else if (ioctl(tty, TIOCGWINSZ, &ts) != -1) {
    /* we don't have any way of directly finding out
       the current height & width of the window in pixels.  We try
       our best by computing the font height and width from the "old"
       window-size values, and multiplying by these ratios... */
    if (TTYSIZE_COLS(ts) != 0)
      ts.ws_xpixel = (ttySize_t) (cols * (ts.ws_xpixel / TTYSIZE_COLS(ts)));
    if (TTYSIZE_ROWS(ts) != 0)
      ts.ws_ypixel = (ttySize_t) (rows * (ts.ws_ypixel / TTYSIZE_ROWS(ts)));
    TTYSIZE_ROWS(ts) = (ttySize_t) rows;
    TTYSIZE_COLS(ts) = (ttySize_t) cols;
    SET_TTYSIZE(tty, ts);
  }
#endif /* USE_STRUCT_WINSIZE */

#ifdef USE_ANY_SYSV_TERMIO
  rc = ioctl(tty, TCSETAW, &tioorig);
#elif defined(USE_TERMIOS)
  rc = tcsetattr(tty, TCSADRAIN, &tioorig);
#else /* not USE_TERMIOS */
  rc = ioctl(tty, TIOCSETP, &sgorig);
#endif /* USE_ANY_SYSV_TERMIO/USE_TERMIOS */
  if (rc != 0)
    failed("set tty settings");

  signal(SIGINT, SIG_DFL);
  signal(SIGQUIT, SIG_DFL);
  signal(SIGTERM, SIG_DFL);

#ifdef USE_TERMCAP
  if (ok_tcap) {
    /* update termcap string */
    /* first do columns */
    if ((ptr = x_strindex(termcap, "co#")) == NULL) {
      error("get_screen_size: No `co#'");
    }

    i = ptr - termcap + 3;
    strncpy(newtc, termcap, (size_t) i);
    sprintf(newtc + i, "%d", cols);
    ptr = strchr(ptr, ':');
    strcat(newtc, ptr);

    /* now do lines */
    if ((ptr = x_strindex(newtc, "li#")) == NULL) {
      error("get_screen_size: No `li#'");
    }

    i = ptr - newtc + 3;
    strncpy(termcap, newtc, (size_t) i);
    sprintf(termcap + i, "%d", rows);
    ptr = strchr(ptr, ':');
    strcat(termcap, ptr);
  }
#endif /* USE_TERMCAP */

#ifdef USE_TERMCAP
  if (ok_tcap) {
    print_termcap(termcap);
  }
#endif /* USE_TERMCAP */
#ifdef USE_TERMINFO
  Rprintf("COLUMNS=%d;\nLINES=%d;\n", cols, rows);
#endif /* USE_TERMINFO */


  return R_NilValue;
}

#endif
