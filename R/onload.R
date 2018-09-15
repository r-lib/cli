
## nocov start

dummy <- function() { }

cli <- NULL

.onLoad <- function(libname, pkgname) {
  pkgenv <- environment(dummy)
  makeActiveBinding(
    "symbol",
    function() if (is_utf8_output()) symbol_utf8 else symbol_win,
    pkgenv
  )
}

## nocov end
