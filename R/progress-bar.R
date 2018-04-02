
#' @importFrom progress progress_bar

cli_progress_bar <- function(self, private, ...) {
  stream <- stderr()
  if (!nzchar(stream)) stream <- stdout()
  bar <- progress_bar$new(..., stream = stream,
    width = private$get_width())
  private$progress_bars <- c(private$progress_bars, list(bar))
  private$cleanup_progress_bars()
  bar
}

cli__get_progress_bar <- function(self, private) {
  finished <- vlapply(private$progress_bars, function(x) x$finished)
  last <- tail_na(which(!finished))
  if (is.na(last)) NULL else private$progress_bars[[last]]
}

cli__cleanup_progress_bars <- function(self, private) {
  finished <- vlapply(private$progress_bars, function(x) x$finished)
  private$progress_bars <- private$progress_bars[!finished]
}
