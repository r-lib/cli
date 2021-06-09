
# ------------------------------------------------------------------------

#' @export

cli_progress_builtin_handlers <- function() {
  names(builtin_handlers)
}

cli_progress_select_handlers <- function() {
  opt <- getOption("cli.progress_handlers")
  if (is.null(opt)) {
    list(builtin_handler_cli)
  } else if (is.character(opt)) {
    builtin_handlers[opt]
  } else {
    stop("`cli.progress_handlers` option must be a character vector")
  }
}

# ------------------------------------------------------------------------

builtin_handler_cli <- list(
  add = function(bar, .envir) {
    opt <- options(cli__pb = bar)
    on.exit(options(opt), add = TRUE)
    bar$cli_statusbar <- cli_status(
      bar$format,
      msg_done = bar$format_done %||% bar$format,
      msg_failed = bar$format_failed %||% bar$format,
      .auto_close = FALSE,
      .envir = .envir,
    )
  },

  set = function(bar, .envir) {
    opt <- options(cli__pb = bar)
    on.exit(options(opt), add = TRUE)
    cli_status_update(id = bar$cli_statusbar, bar$format, .envir = .envir)
  },

  complete = function(bar, .envir, result) {
    opt <- options(cli__pb = bar)
    on.exit(options(opt), add = TRUE)
    if (isTRUE(bar$added)) {
      if (bar$clear) {
        cli_status_clear(bar$cli_statusbar, result = "clear", .envir = .envir)
      } else {
        opt <- options(cli__pb = bar)
        on.exit(options(opt), add = TRUE)
        cli_status_clear(
          bar$cli_statusbar,
          result = result,
          msg_done = bar$format_done,
          msg_failed = bar$format_failed,
          .envir = .envir
        )
      }
    }
    bar$cli_statusbar <- TRUE
  }
)

# ------------------------------------------------------------------------

builtin_handler_progressr <- list(
  add = function(bar, .envir) {
    steps <- if (is.na(bar$total)) 0 else bar$total
    bar$progressr_last <- 0L
    bar$progressr_progressor <- progressr::progressor(
      steps,
      auto_finish = FALSE,
      on_exit = TRUE,
      envir = .envir,
      label = bar$name %||% NA_character_
    )
  },

  set = function(bar, .envir) {
    amount <- bar$current - bar$progressr_last
    bar$last <- bar$current
    if (!is.null(bar$progressr_progressor) && amount > 0) {
      bar$progressr_progressor(amount = amount)
    }
  },

  complete = function(bar, .envir, result) {
    amount <- bar$current - bar$progressr_last
    bar$last <- bar$current
    if (!is.null(bar$progressr_progressor) && amount > 0) {
      bar$progressr_progressor(amount = amount, type = "finish")
    }
  }
)

# ------------------------------------------------------------------------

logger_out <- function(bar, event) {
  cat(sep = "", format_iso_8601(Sys.time()), " ", bar$id, " ",
      bar$current, "/", bar$total, " ", event, "\n")
}

builtin_handler_logger <- list(
  create = function(bar, .envir) {
    logger_out(bar, "created")
  },

  add = function(bar, .envir) {
    logger_out(bar, "added")
  },

  set = function(bar, .envir) {
    logger_out(bar, "updated")
  },

  complete = function(bar, .envir, result) {
    logger_out(bar, "terminated")
  }
)

# ------------------------------------------------------------------------

say_out <- function(text) {
  processx::process$new("say", text)
}

say_update <- function(bar) {
  now <- .Call(clic_get_time)
  freq <- getOption("cli.progress_say_frequency", 3.0)
  if (is.null(bar$say_last) || now - bar$say_last > freq) {
    txt <- if (is.na(bar$total)) bar$current else cli__pb_percent(bar)
    bar$say_proc <- say_out(txt)
    bar$say_last <- now
  }
}

builtin_handler_say <- list(
  add = function(bar, .envir) {
    ## Nothing to do here
  },

  set = function(bar, .envir) {
    say_update(bar)
  },

  complete = function(bar, .envir, result) {
    if (!is.null(bar$say_proc)) {
      bar$say_proc$kill()
      say_out("done")
    }
  }
)

# ------------------------------------------------------------------------

builtin_handler_rstudio <- list(
  add = function(bar, .envir) {
    total <- if (is.na(bar$total)) 0L else as.integer(bar$total)
    bar$status <- bar$status %||% ""
    rstudio_id <- rstudioapi::jobAdd(
      name = bar$name %||% "",
      status = bar$status,
      progressUnits = total,
      running = TRUE,
      show = FALSE
    )
    # so the name is not duplicated in the format string as well
    if (is.na(bar$total)) bar$name <- NULL
    bar$rstudio_id <- rstudio_id
    bar$rstudio_status <- bar$status
  },

  set = function(bar, .envir) {
    if (!is.na(bar$total)) {
      rstudioapi::jobSetProgress(bar$rstudio_id, bar$current)
      if (bar$rstudio_status != bar$status) {
        rstudioapi::jobSetStatus(bar$rstudio_id, bar$status)
        bar$rstudio_status <- bar$status
      }
    } else {
      opt <- options(cli__pb = bar)
      on.exit(options(opt), add = TRUE)
      status <- fmt(
        cli_text(bar$format),
        collapse = TRUE,
        strip_newline = TRUE
      )
      rstudioapi::jobSetStatus(bar$rstudio_id, status)
    }
  },

  complete = function(bar, .envir, results) {
    if (!is.null(bar$rstudio_id)) {
      rstudioapi::jobRemove(bar$rstudio_id)
    }
  }
)

# ------------------------------------------------------------------------

builtin_handler_shiny <- list(
  add = function(bar, .envir) {
    bar$shiny_progress <- shiny::Progress$new(
      shiny::getDefaultReactiveDomain(),
      min = 0,
      max = bar$total
    )
    bar$shiny_progress$set(message = bar$name %||% "", detail = bar$status %||% "")
  },

  set = function(bar, .envir) {
    bar$shiny_progress$set(value = bar$current)
  },

  complete = function(bar, .envir, results) {
    if (!is.null(bar$shiny_progress)) bar$shiny_progress$close()
    bar$shiny_progress <- NULL
  }
)

# ------------------------------------------------------------------------

builtin_handlers <- list(
  cli = builtin_handler_cli,
  logger = builtin_handler_logger,
  progressr = builtin_handler_progressr,
  rstudio = builtin_handler_rstudio,
  say = builtin_handler_say,
  shiny = builtin_handler_shiny
)
