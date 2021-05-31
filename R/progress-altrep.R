
progress_altrep_update <- function(pb, auto_done = TRUE) {
  tryCatch({
    caller <- pb$caller
    pb$tick <- pb$tick + 1L

    if (is.null(pb$format)) {
      pb$format <- pb__default_format(pb$type, pb$total)
    }

    if (auto_done && !is.na(pb$total) && pb$current == pb$total) {
      progress_altrep_done(pb, caller = caller)
      return(NULL)
    }

    opt <- options(cli__pb = pb)
    on.exit(options(opt), add = TRUE)

    if (is.null(pb$statusbar)) {
      pb$statusbar <- cli_status(pb$format, .auto_close = FALSE, .envir = caller)
      if (!identical(caller, .GlobalEnv)) defer(progress_altrep_done(pb), envir = caller)
    } else {
      cli_status_update(id = pb$statusbar, pb$format, .envir = caller)
    }
  }, error = function(err) {
    if (!isTRUE(pb$warned)) {
      warning("cli progress bar update failed", immediate. = TRUE)
    }
    pb$warned <- TRUE
  })

  NULL
}

progress_altrep_done <- function(pb) {
  tryCatch({
    caller <- pb$caller
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
          cli_status_update(pb$statusbar, pb$format, .envir = caller)
          cli_status_clear(pb$statusbar, pb$format, result = "done", .envir = caller)
        }
      }
      pb$statusbar <- NULL
    }

    if (!is.null(pb$id)) clienv$progress[[pb$id]] <- NULL
    if (!is.null(pb$envkey)) clienv$progress[[pb$envkey]] <- NULL

  }, error = function(err) {
    if (!isTRUE(pb$warned)) {
      warning("cli progress bar update failed", immediate. = TRUE)
    }
    pb$warned <- TRUE
  })

  NULL
}
