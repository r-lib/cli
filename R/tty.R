
is_stdout <- function(stream) {
  identical(stream, stdout()) && sink.number() == 0
}

is_stderr <- function(stream) {
  identical(stream, stderr()) && sink.number("message") == 2
}

is_rstudio <- function() {
  Sys.getenv("RSTUDIO") == 1
}

is_rstudio_stdx <- function(stream) {
  interactive() &&
    is_rstudio() &&
    (is_stdout(stream) || is_stderr(stream))
}

is_rapp <- function() {
  Sys.getenv("R_GUI_APP_VERSION") != ""
}

is_rapp_stdx <- function(stream) {
  interactive() &&
    is_rapp() &&
    (is_stdout(stream) || is_stderr(stream))
}

is_rkward <- function() {
  "rkward" %in% (.packages())
}

is_rkward_stdx <- function(stream) {
  interactive() &&
    is_rkward() &&
    (is_stdout(stream) || is_stderr(stream))
}

#' Detect whether a stream supports `\\r` (Carriage return)
#'
#' In a terminal, `\\r` moves the cursor to the first position of the
#' same line. It is also supported by most R IDEs. `\\r` is typically
#' used to achive a more dynamic, less cluttered user interface, e.g.
#' to create progress bars.
#'
#' If the output is directed to a file, then `\\r` characters are typically
#' unwanted. This function detects if `\\r` can be used for the given
#' stream or not.
#'
#' The detection mechanism is as follows:
#' 1. If the `cli.dynamic` option is set to `TRUE`, `TRUE` is returned.
#' 2. If the `cli.dynamic` option is set to anything else, `FALSE` is
#'    returned.
#' 3. If the `R_CLI_DYNAMIC` environment variable is not empty and set to
#'    the string `"true"`, `"TRUE"` or `"True"`, `TRUE` is returned.
#' 4. If `R_CLI_DYNAMIC` is not empty and set to anything else, `FALSE` is
#'    returned.
#' 5. If the stream is a terminal, then `TRUE` is returned.
#' 6. If the stream is hte standard output or error within RStudio,
#'    the macOS R app, or RKWard IDE, `TRUE` is returned.
#' 7. Otherwise `FALSE` is returned.
#'
#' @param stream The stream to inspect, an R connection object.
#' Note that it defaults to the standard _error_ stream, since
#' informative messages are typically printed there.
#'
#' @export
#' @examples
#' is_dynamic_tty()
#' is_dynamic_tty(stdout())

is_dynamic_tty <- function(stream = stderr()) {
  ## Option?
  if (!is.null(x <- getOption("cli.dynamic"))) {
    return(isTRUE(x))
  }

  ## Env var?
  if (x <- Sys.getenv("R_CLI_DYNAMIC", "") != "") {
    return(isTRUE(as.logical(x)))
  }

  ## Autodetect...
  ## RGui has isatty(stdout()) and isatty(stderr()), so we don't need
  ## to check that explicitly
  isatty(stream) ||
    is_rstudio_stdx(stream) ||
    is_rapp_stdx(stream) ||
    is_rkward_stdx(stream)
}
