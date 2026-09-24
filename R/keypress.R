#' Read a single keypress at the terminal
#'
#' It currently only works at Linux/Unix and OSX terminals,
#' and at the Windows command line. see \code{\link{has_keypress_support}}.
#'
#' The following special keys are supported:
#' * Arrow keys: 'up', 'down', 'right', 'left'.
#' * Function keys: from 'f1' to 'f12'.
#' * Others: 'home', 'end', 'insert', 'delete', 'pageup', 'pagedown',
#'     'tab', 'enter', 'backspace' (same as 'delete' on OSX keyboards),
#'     'escape'.
#' * Control with one of the following keys: 'a', 'b', 'c', 'd', 'e', 'f',
#'     'h', 'k', 'l', 'n', 'p', 't', 'u', 'w'.
#'
#' @param block Whether to wait for a key press, if there is none
#'   available now.
#' @param timeout Maximum number of seconds to wait for a key press, if
#'   `block` is `TRUE`. The default `Inf` waits indefinitely. If no key
#'   is pressed before the timeout expires, `NA` is returned. Ignored
#'   for non-blocking reads (`block = FALSE`). The wait is interruptible
#'   regardless of the timeout.
#' @return The key pressed, a character scalar. `NA` is returned if no
#'   key is available: for non-blocking reads, or when a blocking read
#'   times out.
#'
#' @family keypress function
#' @export
#' @examplesIf FALSE
#' x <- keypress()
#' cat("You pressed key", x, "\n")
#'
#' # Wait at most five seconds for a key press
#' x <- keypress(timeout = 5)
#' if (is.na(x)) cat("No key pressed\n") else cat("You pressed key", x, "\n")

keypress <- function(block = TRUE, timeout = Inf) {
  if (!has_keypress_support()) {
    stop("Your platform/terminal does not support `keypress()`.")
  }
  block <- as.logical(block)
  if (length(block) != 1 || is.na(block)) {
    stop("'block' must be a logical scalar")
  }
  timeout <- as.double(timeout)
  if (length(timeout) != 1 || is.na(timeout) || timeout < 0) {
    stop("'timeout' must be a non-negative number of seconds")
  }
  ret <- call_with_cleanup(cli_keypress, block, timeout)
  if (ret == "none") NA_character_ else ret
}

call_with_cleanup <- function(ptr, ...) {
  .Call(cleancall_call, pairlist(ptr, ...), parent.frame())
}

#' Check if the current platform/terminal supports reading
#' single keys.
#'
#' @details
#' Supported platforms:
#' * Terminals in Windows and Unix.
#' * RStudio terminal.
#'
#' Not supported:
#' * RStudio (if not in the RStudio terminal).
#' * R.app on macOS.
#' * Rgui on Windows.
#' * Emacs ESS.
#' * Others.
#'
#' @return Whether there is support for waiting for individual
#' keypresses.
#'
#' @family keypress function
#' @export
#' @examples
#' has_keypress_support()

has_keypress_support <- function() {
  ## Supported if we have a terminal or RStudio terminal.
  ## Not supported otherwise in RStudio, R.app, Rgui or Emacs

  rs <- rstudio$detect()

  if (rs$type != "not_rstudio") {
    rs$has_canonical_mode
  } else {
    isatty(stdin()) &&
      Sys.getenv("R_GUI_APP_VERSION") == "" &&
      .Platform$GUI != "Rgui" &&
      !identical(getOption("STERM"), "iESS") &&
      Sys.getenv("EMACS") != "t" &&
      Sys.getenv("TERM") != "dumb"
  }
}
