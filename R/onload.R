
## nocov start

dummy <- function() { }

cli <- NULL

clienv <- new.env()
clienv$pid <- Sys.getpid()

.onLoad <- function(libname, pkgname) {

  lazyrmd$onload_hook(
    local = "if-newer",
    ci = function() has_asciicast_support(),
    cran = FALSE
  )

  pkgenv <- environment(dummy)
  makeActiveBinding(
    "symbol",
    function() {
      ## If `cli.unicode` is set we use that
      opt <- getOption("cli.unicode",  NULL)
      if (!is.null(opt)) {
        if (isTRUE(opt)) return(symbol_utf8) else return(symbol_ascii)
      }

      ## Otherwise we try to auto-detect
      if (is_utf8_output()) {
        symbol_utf8
      } else if (is_latex_output()) {
        symbol_ascii
      } else if (is_windows()) {
        symbol_win
      } else {
        symbol_ascii
      }
    },
    pkgenv
  )

  if (is.null(getOption("callr.condition_handler_cli_message"))) {
    options(callr.condition_handler_cli_message = cli__default_handler)
  }
}

## nocov end
