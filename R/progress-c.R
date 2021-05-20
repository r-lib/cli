
progress_c_update <- function(pb, auto_done = TRUE) {
  caller <- sys.frame(sys.nframe() - 1L)

  if (is.null(pb$format)) {
    pb$format <- pb__default_format(pb$type, pb$total)
  }

  if (auto_done && !is.na(pb$total) && pb$current == pb$total) {
    progress_c_done(pb)
    return(NULL)
  }

  opt <- options(cli__pb = pb)
  on.exit(options(opt), add = TRUE)

  if (is.null(pb$statusbar)) {
    pb$statusbar <- cli_status(pb$format, .auto_close = FALSE, .envir = caller)
    defer(progress_c_done(pb), envir = caller)
  } else {
    cli_status_update(id = pb$statusbar, pb$format, .envir = caller)
  }

  NULL
}

progress_c_done <- function(pb) {
  caller <- sys.frame(sys.nframe() - 1L)
  if (!is.null(pb$statusbar)) {
    if (pb$clear) {
      cli_status_clear(pb$statusbar, result = "clear")
    } else {
      r1 <- stats::runif(1)
      failed <- identical(returnValue(r1), r1)
      if (failed) {
        cli_status_clear(pb$statusbar, result = "clear")
      } else {
        if (!is.na(pb$total)) pb$current <- pb$total
        opt <- options(cli__pb = pb)
        on.exit(options(opt), add = TRUE)
        cli_status_update(pb$statusbar, pb$format, .envir = caller$caller)
        cli_status_clear(pb$statusbar, pb$format, result = "done", .envir = caller$caller)
      }
    }
    pb$statusbar <- NULL
  }

  if (!is.null(pb$id)) clienv$progress[[pb$id]] <- NULL
  if (!is.null(pb$envkey)) clienv$progress[[pb$envkey]] <- NULL

  NULL
}
