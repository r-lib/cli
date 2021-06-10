
progress_altrep_update <- function(pb, auto_done = TRUE) {
  tryCatch({
    cli_tick_reset()
    caller <- pb$caller
    pb$tick <- pb$tick + 1L

    if (is.null(pb$format)) {
      pb$format <- pb__default_format(pb$type, pb$total)
    }

    if (auto_done && !is.na(pb$total) && pb$current == pb$total) {
      progress_altrep_done(pb)
      return(NULL)
    }

    handlers <- cli_progress_select_handlers(pb, caller)
    if (is.null(pb$added)) {
      pb$added <- TRUE
      for (h in handlers) {
        if ("add" %in% names(h)) h$add(pb, .envir = caller)
      }
      if (!identical(caller, .GlobalEnv)) defer(progress_altrep_done(pb), envir = caller)
    } else {
      for (h in handlers) {
        if ("set" %in% names(h)) h$set(pb, .envir = caller)
      }
    }
  }, error = function(err) {
    if (!isTRUE(pb$warned)) {
      warning("cli progress bar update failed: ", conditionMessage(err),
              immediate. = TRUE)
    }
    pb$warned <- TRUE
  })

  NULL
}

progress_altrep_done <- function(pb) {
  tryCatch({
    caller <- pb$caller

    handlers <- cli_progress_select_handlers()
    for (h in handlers) {
      if ("complete" %in% names(h)) {
        h$complete(pb, .envir = caller, result = "done")
      }
    }

    if (!is.null(pb$id)) clienv$progress[[pb$id]] <- NULL
    if (!is.null(pb$envkey)) clienv$progress_ids[[pb$envkey]] <- NULL

  }, error = function(err) {
    if (!isTRUE(pb$warned)) {
      warning("cli progress bar update failed:", conditionMessage(err),
              immediate. = TRUE)
    }
    pb$warned <- TRUE
  })

  NULL
}
