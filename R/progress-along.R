
#' Add a progress bar to a mapping function or for loop
#'
#' @description
#' Note that this function is currently experimental!
#'
#' Use `cli_progress_along()` in a mapping function or in a for loop, to add a
#' progress bar. It uses [cli_progress_bar()] internally.
#'
#' @details
#' Usage:
#'
#' ```r
#' lapply(cli_progress_along(X), function(i) ...)
#' ```
#'
#' ```r
#' for (i in cli_progress_along(seq)) {
#'   ...
#' }
#' ```
#'
#' Note that if you use `break` in the `for` loop, you probably want to
#' terminate the progress bar explicitly when breaking out of the loop,
#' or right after the loop:
#'
#' ```r
#' for (i in cli_progress_along(seq)) {
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
#'
#' @export

cli_progress_along <- function(x,
                       name = NULL,
                       total = length(x),
                       ...,
                       .envir = parent.frame()) {

  name; total; .envir; list(...)

  if (getRversion() < "3.5.0") return(seq_along(x))
  id <- cli_progress_bar(name = name, total = total, ..., .envir = .envir)
  sax <- seq_along(x)
  clienv$progress[[id]]$caller <- .envir
  .Call(clic_progress_along, sax, clienv$progress[[id]])
}
