
#' @useDynLib cli, .registration=TRUE
NULL

## nocov start

dummy <- function() { }

clienv <- new.env(parent = emptyenv())
clienv$pid <- Sys.getpid()
clienv$status <- list()

.onLoad <- function(libname, pkgname) {

  .Call(clic_start_thread, should_tick)

  ccli_tick_reset <<- clic_tick_reset

  pkgenv <- environment(dummy)
  makeActiveBinding(
    "symbol",
    function() {
      ## If `cli.unicode` is set we use that
      opt <- getOption("cli.unicode",  NULL)
      if (!is.null(opt)) {
        if (isTRUE(opt)) {
          if (rstudio$is_rstudio()) {
            return(symbol_rstudio)
          } else {
            return(symbol_utf8)
          }
        } else {
          return(symbol_ascii)
        }
      }

      ## Otherwise we try to auto-detect
      rst <- rstudio$detect()$type
      rok <- c("rstudio_console", "rstudio_console_starting")
      if (is_utf8_output() && rstudio$is_rstudio()) {
        symbol_rstudio
      } else if (is_utf8_output()) {
        symbol_utf8
      } else if (is_latex_output()) {
        symbol_ascii
      } else if (is_windows() && .Platform$GUI == "Rgui") {
        symbol_win
      } else if (is_windows() && rst %in% rok) {
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

.onUnload <- function(libpath) {
  .Call(clic_unload)
}

## nocov end
