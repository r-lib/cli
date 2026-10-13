#' Add a progress bar to a `while` loop
#'
#' @param cond Loop condition. Once this evaluates to `FALSE` the
#'   progress bar will be terminated.
#' @param name Name of the progress bar, a label, passed to
#'   [cli_progress_bar()].
#' @param ... Passed to [cli_progress_bar()].
#' @param .envir Passed to [cli_progress_bar()].
#'
#' @return The value of the `cond` condition.
#' @keywords internal
#' @export

ticking <- function(cond, name = NULL, ..., .envir = parent.frame()) {
  val <- force(cond)

  new <- is.null(clienv$progress_ids[[format(.envir)]])

  if (new && val) {
    cli_progress_bar(name = name, ..., .envir = .envir)
  }

  if (val) {
    cli_progress_update(.envir = .envir)
  } else {
    cli_progress_done(.envir = .envir)
  }

  val
}
