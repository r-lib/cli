
#' cli progress bars
#'
#' @description
#' This is the reference manual of the three functions that create,
#' update and terminate progress bars. For a tutorial see the
#' [cli progress bars](https://cli.r-lib.org/articles/pluralization.html).
#'
#' `cli_progress_bar()` creates a progress bar.
#'
#' @param name This is typically used as a label, and should be short,
#'   at most 20 characters.
#' @param status Initial status of the progress bar. If not empty, then
#'   it is typically shown after the label.
#' @param type Type of the progress bar. It is used to select a default
#'   display if `format` is not specified. Currently supported types:
#'   * `iterator`: e.g. a for loop or a mapping function,
#'   * `tasks`: a (typically small) number of tasks,
#'   * `download`: download of one file,
#'   * `custom`: custom type, `format` must not be `NULL` for this type.
#' @param total Total number of progress units, or `NA` if it is unknown.
#'   `cli_progress_update()` can update the total number of units. This is
#'   handy if you don't know the size of a download at the beginning, and
#'   also in some other casees. If `format` (plus `format_done` and
#'   `format_done`) will be updated if you change `total` from `NA` to a
#'   number, if you specify `NULL` for `format`. I.e. default format strings
#'   will be updated, custom ones won't be.
#' @param format Format string. It has to be specified for custom progress
#'   bars, otherwise it is optional, and a default display is selected
#'   based on the progress bat type and whether the number of total units
#'   is known. Format strings may contain glue substitution, the support
#'   pluralization and cli styling.
#' @param format_done Format string for successful termination. By default
#'   the same as `format`.
#' @param format_failed Format string for unsuccessful termination. By
#'   default the same as `format`.
#' @param clear Whether to remove the progress bar from the screen after
#'   it has temrinated.
#' @param current Whether to use this progress bar as the current progress
#'   bar of the calling function. See more at 'The current progress bar'
#'   below.
#' @param auto_terminate Whether to terminate the progress bar if the
#'   number of current units reaches the number of total units.
#' @param extra Extra data to add to the progress bar. This can be
#'   used in custom format strings for example. It should be a named list.
#'   `cli_progress_update()` can update the extra data.
#' @param .auto_close Whether to terminate the progress bar when the
#'   calling function (or the one with execution environment in `.envir`
#'   exits. (Auto termination does not work for progress bars created
#'   from the global environment, e.g. from a script.)
#' @param .envir The environment to use for auto-termination and for glue
#'   substitution. It is also used to find and set the current progress bar.
#'
#' @return `cli_progress_bar()` returns the id of the new progress bar.
#' The id is a string constant.
#'
#' ## The current progress bar
#'
#' If `current = TRUE` (the default), then the new progress bar will be
#' the _current_ progress bar of the calling frame. The previous current
#' progress bar of the same frame, if there is any, is terminated.
#'
#' @seealso [cli_progress_message()] and [cli_progress_step()] for simpler
#'   progress messages.
#' @aliases __cli_update_due cli_tick_reset ccli_tick_reset ticking
#' @export
#' @examplesIf cli:::should_run_progress_examples()
#' clean <- function() {
#'   cli_progress_bar("Cleaning data", total = 100)
#'   for (i in 1:100) {
#'     Sys.sleep(5/100)
#'     cli_progress_update()
#'   }
#' }
#' clean()

cli_progress_bar <- function(name = NULL,
                             status = NULL,
                             type = c("iterator", "tasks", "download",
                                      "custom"),
                             total = NA,
                             format = NULL,
                             format_done = NULL,
                             format_failed = NULL,
                             clear = getOption("cli.progress_clear", TRUE),
                             current = TRUE,
                             auto_terminate = type != "download",
                             extra = NULL,
                             .auto_close = TRUE,
                             .envir = parent.frame()) {

  start <- .Call(clic_get_time)
  id <- new_uuid()
  envkey <- format(.envir)
  type <- match.arg(type)
  if (type == "custom" && is.null(format)) {
    stop("Need to specify format if `type == \"custom\"")
  }

  ## If changes, synchronize with C API in progress.c
  bar <- new.env(parent = emptyenv())
  bar$id <- id
  bar$name <- name
  bar$status <- status
  bar$type <- match.arg(type)
  bar$total <- total
  bar$show_after <- start + getOption("cli.progress_show_after", 2)
  bar$format0 <- bar$format <- format
  bar$format_done0 <- bar$format_done <- format_done %||% format
  bar$format_failed0 <- bar$format_failed <- format_failed %||% format
  bar$clear <- clear
  bar$auto_terminate <- auto_terminate
  bar$envkey <- if (current) envkey else NULL
  bar$current <- 0L
  bar$start <- start
  bar$tick <- 0L
  bar$extra <- extra
  clienv$progress[[id]] <- bar
  if (current) {
    if (!is.null(clienv$progress_ids[[envkey]])) {
      cli_progress_done(clienv$progress_ids[[envkey]], .envir = .envir, result = "done")
    }
    clienv$progress_ids[[envkey]] <- id
  }

  if (.auto_close && envkey != clienv$globalenv) {
    defer(cli_progress_done(id = id, .envir = .envir), envir = .envir)
  }

  opt <- options(cli__pb = bar)
  on.exit(options(opt), add = TRUE)

  bar$handlers <- cli_progress_select_handlers(bar, .envir)
  for (h in bar$handlers) {
    if ("create" %in% names(h)) h$create(bar, .envir = .envir)
  }

  invisible(id)
}

#' @description
#' `cli_progress_update()` updates the state of a progress bar, and
#' potentially the display as well.
#'
#' @details
#' `cli_progress_update()` updates the state of the progress bar and
#' potentially outputs the new progress bar to the display as well.
#'
#' @param inc Increment in progress units. This is ignored if `set` is
#'   not `NULL`.
#' @param set Set the current number of progress units to this value.
#'   Ignored if `NULL`.
#' @param status New status string of the progress bar, if not `NULL`.
#' @param id Progress bar to update or terminate. If `NULL`, then the
#'   current progress bar of the calling function (or `.envir` if
#'   specified) is updated or terminated.
#' @param force Whether to force a display update, even if no update is
#'   due.
#'
#' @return `cli_progress_update()` returns the id of the progress bar,
#' invisibly.
#'
#' @name cli_progress_bar
#' @export

cli_progress_update <- function(inc = NULL, set = NULL, total = NULL,
                                status = NULL, extra = NULL,
                                id = NULL, force = FALSE,
                                .envir = parent.frame()) {

  id <- id %||% clienv$progress_ids[[format(.envir)]]
  if (is.null(id)) {
    envkey <- format(.envir)
    stop("Cannot find current progress bar for `", envkey, "`")
  }
  pb <- clienv$progress[[id]]
  if (is.null(pb)) stop("Cannot find progress bar `", id, "`")

  if (!is.null(status)) pb$status <- status

  if (!is.null(extra)) pb$extra <- utils::modifyList(pb$extra, extra)

  if (!is.null(set)) {
    pb$current <- set
  } else {
    inc <- inc %||% 1L
    pb$current <- pb$current + inc
  }

  if (!is.null(total)) {
    if (is.na(pb$total) != is.na(total) ||
        (!is.na(total) && pb$total != total)) {
      pb$total <- total
      if (!is.null(pb$format) && is.null(pb$format0)) {
        pb$format <- pb__default_format(pb$type, pb$total)
        pb$format_done <- pb$format_done0 %||% pb$format
        pb$format_failed <- pb$format_failed0 %||% pb$format
      }
    }
  }

  if (pb$auto_terminate && !is.na(pb$total) && pb$current == pb$total) {
    cli_progress_done(id, .envir = .envir, result = "done")
    return(invisible(id))
  }

  now <- .Call(clic_get_time)
  upd <- .Call(clic_update_due)
  if (force || (upd && now > pb$show_after)) {
    if (upd) cli_tick_reset()
    pb$tick <- pb$tick + 1L

    if (is.null(pb$format)) {
      pb$format <- pb__default_format(pb$type, pb$total)
      pb$format_done <- pb$format_done0 %||% pb$format
      pb$format_failed <- pb$format_failed0 %||% pb$format
    }

    opt <- options(cli__pb = pb)
    on.exit(options(opt), add = TRUE)

    if (is.null(pb$added)) {
      pb$added <- TRUE
      for (h in pb$handlers) {
        if ("add" %in% names(h)) h$add(pb, .envir = .envir)
      }
    }

    for (h in pb$handlers) {
      if ("set" %in% names(h)) h$set(pb, .envir = .envir)
    }
  }

  # Return TRUE, to allow cli_progress_update() && break in loops
  invisible(id)
}

#' @description
#' `cli_progress_done()` terminates a progress bar.
#'
#' @param result String to select successful or unsuccessful termination.
#'   It is only used if the progress bar is not cleared from the screen.
#'   It can be one of `"done"`, `"failed"`, `"clear"`, and `"auto"`.
#'
#' @return `cli_progress_done()` returns `TRUE`, invisibly, always.
#'
#' @name cli_progress_bar
#' @export

cli_progress_done <- function(id = NULL, .envir = parent.frame(),
                              result = "auto") {
  envkey <- format(.envir)
  id <- id %||% clienv$progress_ids[[envkey]]
  if (is.null(id)) return(invisible(TRUE))
  pb <- clienv$progress[[id]]
  if (is.null(pb)) return(invisible(TRUE))

  opt <- options(cli__pb = pb)
  on.exit(options(opt), add = TRUE)

  for (h in pb$handlers) {
    if ("complete" %in% names(h)) {
      h$complete(pb, .envir = .envir, result = result)
    }
  }

  clienv$progress[[id]] <- NULL
  if (!is.null(pb$envkey)) clienv$progress_ids[[pb$envkey]] <- NULL

  invisible(TRUE)
}

#' Add text output to a progress bar
#'
#' The text is calculated via [cli_text()], so all cli features can be
#' used here, including progress variables.
#'
#' The text is passed to the progress handler(s), that may or may not be
#' able to print it.
#'
#' @param text Text to output. It is formatted via [cli_text()].
#' @param id Progress bar id. The default is the current progress bar.
#' @param .envir Environment to use for glue interpolation of `text`.
#' @return `TRUE`, always.
#'
#' @export

cli_progress_output <- function(text, id = NULL, .envir = parent.frame()) {
  envkey <- format(.envir)
  id <- id %||% clienv$progress_ids[[envkey]]
  if (is.null(id)) return(invisible(TRUE))
  pb <- clienv$progress[[id]]
  if (is.null(pb)) return(invisible(TRUE))

  txt <- fmt(cli_text(text, .envir = .envir))
  for (h in pb$handlers) {
    if ("output" %in% names(h)) {
      h$output(pb, .envir = .envir, text = txt)
    }
  }

  invisible(TRUE)
}

# ------------------------------------------------------------------------

#' Simplified cli progress messages
#'
#' @description This is a simplified progress bar, a single (dynamic)
#' message, without progress units.
#'
#' @details `cli_progress_message()` always shows the message, even if no
#' update is due. When the progress message is terminated, it is removed
#' from the screen by default.
#'
#' @param msg Message to show. It may contain glue substitution and cli
#'   styling. It can be updated via [cli_progress_update()], as usual.
#' @param current Passed to [cli_progress_bar()].
#' @param .auto_close Passed to [cli_progress_bar()].
#' @param .envir Passed to [cli_progress_bar()].
#' @param ... Passed to [cli_progress_bar()].
#'
#' @return The id of the new progress bar.
#'
#' @seealso [cli_progress_bar()] for the complete progress bar API.
#'   [cli_progress_step()] for a similar display that is styled by default.
#' @export

cli_progress_message <- function(msg,
                                 current = TRUE,
                                 .auto_close = TRUE,
                                 .envir = parent.frame(),
                                 ...) {

  id <- cli_progress_bar(
    type = "custom",
    format = msg,
    current = current,
    .auto_close = .auto_close,
    .envir = .envir,
    ...
  )

  cli_progress_update(id = id, force = TRUE, .envir = .envir)

  invisible(id)
}

# ------------------------------------------------------------------------

#' Simplified cli progress messages, with styling
#'
#' @description This is a simplified progress bar, a single (dynamic)
#' message, without progress units.
#'
#' @details `cli_progress_step()` always shows the progress message,
#' even if no update is due.
#'
#' @param msg Message to show. It may contain glue substitution and cli
#'   styling. It can be updated via [cli_progress_update()], as usual.
#'   It is style as a cli info alert (see [cli_alert_info()]).
#' @param msg_done Message to show on successful termination. By default
#'   this it is the same as `msg` and it is styled as a cli success alert
#'   (see [cli_alert_success()]).
#' @param msg_failed Message to show on unsuccessful termination. By
#'   default it is the same as `msg` and it is styled as a cli danger alert
#'   (see [cli_alert_danger()]).
#' @param current Passed to [cli_progress_bar()].
#' @param .auto_close Passed to [cli_progress_bar()].
#' @param .envir Passed to [cli_progress_bar()].
#' @param ... Passed to [cli_progress_bar()].
#'
#' @export

cli_progress_step <- function(msg,
                              msg_done = msg,
                              msg_failed = msg,
                              current = TRUE,
                              .auto_close = TRUE,
                              .envir = parent.frame(),
                              ...) {
  id <- cli_progress_bar(
    type = "custom",
    format = paste0("{.alert-info ", msg, "}"),
    format_done = paste0("{.alert-success ", msg_done, "}"),
    format_failed = paste0("{.alert-danger ", msg_failed, "}"),
    clear = FALSE,
    current = current,
    .auto_close = .auto_close,
    .envir = .envir,
    ...
  )

  cli_progress_update(id = id, force = TRUE, .envir = .envir)

  invisible(id)
}

# ------------------------------------------------------------------------

pb__default_format <- function(type, total) {
  if (type == "iterator") {
    if (!is.na(total)) {
      opt <- getOption("cli.progress_format_iterator")
      if (!is.null(opt)) return(opt)
      paste0(
        "{cli::pb_name}{cli::pb_bar} {cli::pb_percent} | {cli::pb_status}",
        "ETA: {cli::pb_eta}"
      )
    } else {
      opt <- getOption("cli.progress_format_iterator_nototal") %||%
        getOption("cli.progress_format_iterator")
      if (!is.null(opt)) return(opt)
      paste0(
        "{cli::pb_spin} {cli::pb_name}{cli::pb_status}",
        "{cli::pb_current} done ({cli::pb_rate}) | {cli::pb_elapsed}"
      )
    }

  } else if (type == "tasks") {
    if (!is.na(total)) {
      opt <- getOption("cli.progress_format_tasks")
      if (!is.null(opt)) return(opt)
      paste0(
        "{cli::pb_spin} {cli::pb_current}/{cli::pb_total} ",
        "ETA: {cli::pb_eta} | {cli::pb_name}{cli::pb_status}"
      )
    } else {
      opt <- getOption("cli.progress_format_tasks_nototal") %||%
        getOption("cli.progress_format_tasks")
      if (!is.null(opt)) return(opt)
      paste0(
        "{cli::pb_spin} {cli::pb_name}{cli::pb_status}",
        "{cli::pb_current} done ({cli::pb_rate}) | {cli::pb_elapsed}"
      )
    }

  } else if (type == "download") {
    if (!is.na(total)) {
      opt <- getOption("cli.progress_format_download")
      if (!is.null(opt)) return(opt)
      paste0(
        "{cli::pb_name}{cli::pb_status}{cli::pb_bar}| ",
        "{cli::pb_current_bytes}/{cli::pb_total_bytes} {cli::pb_eta_str}"
      )
    } else {
      opt <- getOption("cli.progress_format_download_nototal") %||%
        getOption("cli.progress_format_download")
      if (!is.null(opt)) return(opt)
      paste0(
        "{cli::pb_name}{cli::pb_status}{cli::pb_spin} ",
        "{cli::pb_current_bytes} ({cli::pb_rate_bytes}) | {cli::pb_elapsed}"
      )
    }
  }
}
