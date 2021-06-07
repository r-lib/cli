
#' Add a progress bar to a mapping function or for loop
#'
#' Use `tick_along()` in a mapping function or in a for loop, to add a
#' progress bar. It uses [cli_progress_bar()] internally.
#'
#' Usage:
#'
#' ```r
#' lapply(tick_along(X), function(i) ...)
#' ```
#'
#' ```r
#' for (i in tick_along(seq)) {
#'   ...
#' }
#' ```
#'
#' Note that if you use `break` in the `for` loop, you probably want to
#' terminate the progress bar explicitly when breaking out of the loop,
#' or right after the loop:
#'
#' ```r
#' for (i in tick_along(seq)) {
#'   ...
#'   if (cond) cli_progress_done() && break
#'   ...
#' }
#' ```
#'
#' @param x Sequence to add the progress bar to.
#' @param name Name of the progtess bar, a label, passed to
#'   [cli_progress_bar()].
#' @param total Passed to [cli_progress_bar()].
#' @param ... Passed to [cli_progress_bar()].
#' @param .envir Passed to [cli_progress_bar()].
#'
#' @return An index vector from 1 to `length(x)` that triggers progress
#' updates as you iterate over it.
#'
#' @seealso [cli_progress_bar()] and the traditional progress bar API.
#' [ticking()] to add a progress bar to a `while` loop.
#'
#' @export

tick_along <- function(x,
                       name = NULL,
                       total = length(x),
                       ...,
                       .envir = parent.frame()) {

  name; total; .envir; list(...)

  if (getRversion() < "3.5.0") return(seq_along(x))
  id <- cli_progress_bar(name = name, total = total, ..., .envir = .envir)
  sax <- seq_along(x)
  clienv$progress[[id]]$caller <- .envir
  ta <- structure(
    .Call(clic_tick_along, sax, clienv$progress[[id]]),
    class = "cli_tick_along",
    length = length(sax)
  )
  ta
}

#' @export

format.cli_tick_along <- function(x, ...) {
  paste0("<cli tick_along() of length ", attr(x, "length"), ">")
}

#' @export

print.cli_tick_along <- function(x, ...) {
  cat(format(x, ...), sep = "\n")
}

#' @export

as.list.cli_tick_along <- function(x, ...) {
  x
}
