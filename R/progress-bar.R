
#' @importFrom progress progress_bar

clii_progress_bar <- function(app, id, ...) {
  stream <- stderr()
  if (!nzchar(stream)) stream <- stdout()
  bar <- progress_bar$new(
    ..., stream = stream,
    width = app$get_width())
  stbar <- list(bar)
  names(stbar) <- id
  app$progress_bars <- c(app$progress_bars, stbar)
  app$cleanup_progress_bars()
  invisible()
}

clii__get_progress_bar <- function(app) {
  finished <- vlapply(app$progress_bars, function(x) x$finished)
  last <- tail_na(which(!finished))
  if (is.na(last)) NULL else app$progress_bars[[last]]
}

clii__cleanup_progress_bars <- function(app) {
  finished <- vlapply(app$progress_bars, function(x) x$finished)
  app$progress_bars <- app$progress_bars[!finished]
}

cli__remote_progress_bar <- function(id) {
  id <- id

  bar <- list(
    tick = function(len = 1, tokens = list())
      cli__message("progress", list(id, "tick", len, tokens)),

    update = function(ratio, tokens = list())
      cli__message("progress", list(id, "update", ratio, tokens)),

    message = function(msg, set_width = TRUE)
      cli__message("progress", list(id, "message", msg, set_width)),

    terminate = function()
      cli__message("progress", list(id, "terminate")),

    finished = FALSE
  )

  class(bar) <- "cli_remote_progress_bar"
  bar
}

clii_progress <- function(app, id, operation, ...) {
  if (!id %in% names(app$progress_bars)) return()
  bar <- app$progress_bars[[id]]
  if (bar$finished) {
    app$progress_bars[[id]] <- NULL
  } else {
    bar[[operation]](...)
  }
  if (bar$finished) app$progress_bars[[id]] <- NULL
}
