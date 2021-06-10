
# ------------------------------------------------------------------------

#' cli progress handlers
#'
#' The progress handler(s) to use can be selected with global options.
#'
#' There are three options that specify which handlers will be selected,
#' but most of the time you only need to use one of them. You can set these
#' options to a character vector, the names of the built-in cli handlers you
#' want to use:
#'
#' * If `cli.progress_handlers_only` is set, then these handlers are used,
#'   without considering others and without checking if they are able to
#'   handle a progress bar. This option is mainly intended for testing
#'   purposes.
#' * The handlers named in `cli.progress_handlers` are checked if they are
#'   able to handle the progress bar, and from the ones that are, the first
#'   one is selected. This is usually the option that the end use would want
#'   to set.
#' * The handlers named in `cli.progress_handlers_force` are always appended
#'   to the ones selected via `cli.progress_handlers`. This option is useful
#'   to add an additional handler, e.g. a logger that writes to a file.
#'
#' # The built-in progress handlers
#'
#' ### `cli`
#'
#' Use cli's internal status bar, the last line of the screen, to show the
#' progress bar. This handler is always able to handle all progress bars.
#'
#' ### `logger`
#'
#' Log progress updates to the screeen, with one line for each update, with
#' time stamps. This handler is always able to handle all progress bars.
#'
#' ### `progressr`
#'
#' Use the progressr package to create progress bars. This handler is
#' always able to handle all progress bars. (The progressr package needs
#' to be installed.)
#'
#' ### `rstudio`
#'
#' Use RStudio's job panel to show the progress bars. This handler is
#' available at the RStudio console, in recent versions of RStudio.
#'
#' ### `say`
#'
#' Use the macOS command line `say` command to announce progress events
#' in speech. Set the `cli.progress_say_frequency` option to set the
#' minimum delay between `say` invocations, the default is three seconds.
#' This handler is available on macOS, if the `say` command is on the path.
#'
#' ### `shiny`
#'
#' Use shiny's progress bars. This handler is available if a shiny app is
#' running.
#'
#' @return `cli_progress_builtin_handlers()` returns the names of the
#' currently supported progress handlers.
#'
#' @export

cli_progress_builtin_handlers <- function() {
  names(builtin_handlers)
}

cli_progress_select_handlers <- function(bar, .envir) {
  hnd <- getOption("cli.progress_handlers", c("shiny", "cli"))
  frc <- getOption("cli.progress_handlers_force")
  onl <- getOption("cli.progress_handlers_only")

  if (!is.null(onl)) return(builtin_handlers[onl])

  hnd_imp <- builtin_handlers[hnd]
  hnd_able <- Filter(function(h) is.null(h$able) || h$able(bar, .envir), hnd_imp)
  if (length(hnd_able) > 1) hnd_able <- hnd_able[1]

  c(hnd_able, builtin_handlers[frc])
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
  able = function(bar, .envir) {
    Sys.info()[["sysname"]] == "Darwin" && Sys.which("say") != ""
  },

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
  able = function(bar, .envir) {
    tryCatch(
      .Platform$GUI == "Rstudio" && rstudioapi::isAvailable(),
      error = function(err) FALSE
    )
  },

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
  able = function(bar, .envir) {
    "shiny" %in% loadedNamespaces() && shiny::isRunning()
  },

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
