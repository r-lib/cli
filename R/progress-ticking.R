
#' @export

ticking <- function(cond, ..., .envir = parent.frame()) {
  val <- force(cond)

  new <- is.null(clienv$progress[[format(.envir)]])

  if (new && val) cli_progress_bar(..., .envir = .envir)

  if (val) {
    cli_progress_update(.envir = .envir)
  } else {
    cli_progress_done(.envir = .envir)
  }

  val
}
