
progress_c_update <- function(pb) {
  caller <- sys.frame(sys.nframe() - 1L)

  if (is.null(pb$format)) {
    pb$format <- pb__default_format(pb$type, pb$total)
  }

  if (!is.na(pb$total) && pb$current == pb$total) {
    progress_c_done(pb)
    return(NULL)
  }

  opt <- options(cli__pb = pb)
  on.exit(options(opt), add = TRUE)

  if (is.null(pb$statusbar)) {
    pb$statusbar <- cli_status(pb$format, .auto_close = FALSE, .envir = caller)
  } else {
    cli_status_update(id = pb$statusbar, pb$format, .envir = caller)
  }

  NULL
}

progress_c_done <- function(pb) {
  if (!is.null(pb$statusbar)) {
    if (pb$clear) {
      cli_status_clear(pb$statusbar, result = "clear")
    } else {
      cli_status_clear(pb$statusbar, result = "done", msg_done = pb$msg)
    }
  }

  if (!is.null(pb$id)) clienv$progress[[pb$id]] <- NULL
  if (!is.null(pb$envkey)) clienv$progress[[pb$envkey]] <- NULL

  NULL
}
