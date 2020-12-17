
#' Detect the number of ANSI colors to use
#'
#' @description
#' Certain Unix and Windows terminals, and also certain R GUIs, e.g.
#' RStudio, support styling terminal output using special control
#' sequences (ANSI sequences).
#'
#' `num_ansi_colors()` detects if the current R session supports ANSI
#' sequences, and if it does how many colors are supported.
#'
#' @details
#' The detection mechanism is quite involved and it is designed to work
#' out of the box on most systems. If it does not work on your system,
#' please report a bug. Setting options and environment variables to turn
#' on ANSI support is error prone, because they are inherited in other
#' environments, e.g. knitr, that might not have ANSI support.
#'
#' If you want to _turn off_ ANSI colors, set the `NO_COLOR` environment
#' variable to a non-empty value.
#'
#' The exact detection mechanism is as follows:
#' 1. If the `cli.num_colors` options is set, that is returned.
#' 1. If the `R_CLI_NUM_COLORS` env var is set to a non-empty value,
#'    then it is used.
#' 1. If the `crayon.enabled` option is set to `FALSE`, 1L is returned.
#'    (This is for compatibility with code that uses the crayon package.)
#' 1. If the `crayon.enabled` option is set to `TRUE` and the
#'    `crayon.colors` option is also set, then the latter is returned.
#'    (This is for compatibility with code that uses the crayon package.)
#' 1. If the `NO_COLOR` environment variable is set, then 1L is returned.
#' 1. If we are in knitr, then 1L is returned, to turn off colors in
#'    `.Rmd` chunks.
#' 1. If `stream` is `stderr()` and there is an active sink for it, then
#'    1L is returned.
#' 1. If R is running inside RGui on Windows, or R.app on macOS, then we
#'    return 1L.
#' 1. If R is running inside RStudio, with color support, then the
#'    appropriate number of colors is returned, usually 256L.
#' 1. If R is running on Windows, inside an Emacs version that is recent
#'    enough to support ANSI colors, then 8L is returned. (On Windows,
#'    Emacs has `isatty(stdout()) == FALSE`, so we need to check for this
#'    here before dealing with terminals.)
#' 1. If `stream` is not a terminal, then 1L is returned.
#' 1. If R is running on Unix, inside an Emacs version that is recent
#'    enough to support ANSI colors, then 8L is returned.
#' 1. If `stream` is not the standard output or error, then 1L is returned.
#' 1. If we are on Windows, under ComEmu or cmder, or ANSICON is loaded,
#'    then 8L is returned.
#' 1. Otherwise if we are on Windows, return 1L.
#' 1. Otherwise we are on Unix and try to run `tput colors` to determine
#'    the number of colors. If this succeeds, we return its return value,
#'    except if the `TERM` environment variable is `xterm` and `tput`
#'    returned 8L, we return 256L, because xterm compatible terminals
#'    tend to support 256 colors.
#' 1. If `tput colors` fails, we try to guess. If `COLORTERM` is set
#'    to any value, we return 8L.
#' 1. If `TERM` is set to `dumb`, we return 1L.
#' 1. If `TERM` starts with `screen`, `xterm`, or `vt100`, we return 8L.
#' 1. If `TERM` contains `color`, `ansi`, `cygwin` or `linux`, we return 8L.
#' 1. Otherwise we return 1L.
#'
#' @param stream The stream that will be used for output, an R connection
#' object. It can also be a string, one of `"auto"`, `"message"`,
#' `"stdout"`, `"stderr"`. `"auto"` will select `stdout()` if the session is
#' interactive and there are no sinks, otherwise it will select `stderr()`.
#' @return Integer, the number of ANSI colors the current R session
#' supports for `stream`.
#'
#' @family ANSI styling
#' @export
#' @examples
#' num_ansi_colors()

num_ansi_colors <- function(stream = "auto") {
  stream <- get_real_output(stream)

  is_stdout <- is_stderr <- is_std <- FALSE
  std <- "nope"
  if (identical(stream, stdout())) {
    is_stdout <- is_std <- TRUE
    std <- "stdout"
  } else if (identical(stream, stderr())) {
    is_stderr <- is_std <- TRUE
    std <- "stderr"
  }

  # colors forced?
  opt <- getOption("cli.num_colors", NULL)
  if (!is.null(opt)) return(as.integer(opt))

  # forced via env var
  if ((env <- Sys.getenv("R_CLI_NUM_COLORS", "")) != "") {
    return(as.integer(env))
  }

  # compatiblity with crayon
  cray_opt_has <- getOption("crayon.enabled", NULL)
  cray_opt_num <- getOption("crayon.colors", NULL)
  if (!is.null(cray_opt_has) && !isTRUE(cray_opt_has)) return(1L)
  if (isTRUE(cray_opt_has) && !is.null(cray_opt_num)) {
    return(as.integer(cray_opt_num))
  }

  # NO_COLOR env var
  if (!is.na(Sys.getenv("NO_COLOR", NA_character_))) return(1L)

  # knitr?
  if (isTRUE(getOption("knitr.in.progress"))) return(1L)

  # If a sink is active for "output", then R changes the `stdout()`
  # stream, so we don't need to do anything here.
  # If a sink is active for "message" (ie. stderr), then R does not update
  # the `stderr()` stream, so we need to catch this case.
  if (is_stderr && sink.number("message") != 2) return(1L)

  # RGui or Rapp?
  if (.Platform$GUI == "Rgui" || .Platform$GUI == "AQUA") return(1L)

  # RStudio?
  rstudio <- rstudio$detect()
  rstudio_colors <- c(
    "rstudio_console",
    "rstudio_console_starting",
    "rstudio_build_pane"
  )
  if (rstudio$type %in% rstudio_colors && is_std) {
    return(rstudio$num_colors)
  }

  # Windows Emacs? The top R process will have `--ess` in ESS, but the
  # subprocesses won't. (Without ESS subprocesses will also report 8L
  # colors, this is a problem, but we expect most people use ESS in Emacs.)
  if (os_type() == "windows" &&
      "--ess" %in% commandArgs() &&
      is_emacs_with_color()) {
    return(8L)
  }

  # For the rest, we are either in a terminal, or there is no ANSI support.
  if (!isatty(stream)) return(1L)

  # If `stream` is not stdout or stderr then we give up here
  if (!is_std) return(1L)

  # Otherwise use/set the cache
  clienv$num_colors[[std]] <- clienv$num_colors[[std]] %||% detect_tty_colors()
  clienv$num_colors[[std]]
}

detect_tty_colors <- function() {
  # Emacs on Unix?
  if (os_type() == "unix" && is_emacs_with_color()) return(8L)

  # Windows terminal with native color support?
  if (os_type() == "windows" && win10_build() >= 16257) {
    # this is rather weird, but echo turns on color support :D
    system2("cmd", c("/c", "echo 1 >NUL"))
    return(256L)
  }

  # Windows terminal with 3rd party color support?
  if (os_type() == "windows") {
    if (Sys.getenv("ConEmuANSI") == "ON" ||
        Sys.getenv("CMDER_ROOT") != "") {
      return(8L)
    }
    if (Sys.getenv("ANSICON") != "") return(8L)

    ## Are we in another windows terminal or GUI? :(
    return(1L)
  }

  # Otherwise Unix terminal. Try to run tput colors. If it did not run, but
  # the terminal should still have colors, then we report 8.
  cols <- suppressWarnings(try(
    silent = TRUE,
    as.numeric(system("tput colors 2>/dev/null", intern = TRUE))[1]
  ))
  if (inherits(cols, "try-error") || !length(cols) || is.na(cols)) {
    return(guess_tty_colors())
  }
  if (cols %in% c(-1, 0, 1)) { return(1) }

  # If tput returns 8, but TERM is xterm, we return 256, as most xterm
  # compatible terminals in fact do support 256 colors.
  # There is some discussion about this here:
  # \url{https://github.com/r-lib/crayon/issues/17}
  if (cols == 8 && identical(Sys.getenv("TERM"), "xterm")) cols <- 256

  cols
}

guess_tty_colors <- function() {
  if ("COLORTERM" %in% names(Sys.getenv())) return(8L)

  term <- Sys.getenv("TERM")
  if (term == "dumb") return (1L)

  if (grepl(
    "^screen|^xterm|^vt100|color|ansi|cygwin|linux",
    term,
    ignore.case = TRUE,
    perl = TRUE
  )) {
    8L
  } else {
    1L
  }
}

is_emacs_with_color <- function() {
  (Sys.getenv("EMACS") != "" || Sys.getenv("INSIDE_EMACS") != "") &&
    ! is.na(emacs_version()[1]) && emacs_version()[1] >= 23
}

emacs_version <- function() {
  ver <- Sys.getenv("INSIDE_EMACS")
  if (ver == "") return(NA_integer_)

  ver <- gsub("'", "", ver)
  ver <- strsplit(ver, ",", fixed = TRUE)[[1]]
  ver <- strsplit(ver, ".", fixed = TRUE)[[1]]
  as.numeric(ver)
}

win10_build <- function() {
  os <- utils::sessionInfo()$running
  if (!grepl("^Windows 10 ", os)) return(0L)
  mch <- re_match(os, "[(]build (?<build>[0-9]+)[)]")
  mch <- suppressWarnings(as.integer(mch))
  if (is.na(mch)) return(0L)
  mch
}
