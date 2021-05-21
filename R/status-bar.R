
#' Update the status bar
#'
#' @description
#' ```{r child = "man/chunks/status-desc.Rmd"}
#' ```
#'
#' `cli_status() creates a status.
#'
#' `cli_status_update()` updates the contents of an existing status.
#'
#' `cli_status_clear()` terminates a status.
#'
#' @details
#' ```{r child = "man/chunks/status.Rmd"}
#' ```
#'
#' ```{r child = "man/chunks/status-diff.Rmd"}
#' ```
#'
#' @param msg The text to show, a character vector. It will be
#'   collapsed into a single string, and the first line is kept and cut to
#'   [console_width()]. The message is often associated with the start of
#'   a calculation. You can use cli [inline markup][inline-markup] in this
#'   message. If the message contains [glue][glue::glue()] interpolation,
#'   then it will be evaluated every time the message is updated.
#'   `cli_status_update()` may update this message.
#' @param msg_done The message to use when the status is terminated, if
#'   the calculation finishes successfully. If `.auto_close` is `TRUE`
#'   and `.auto_result` is `"done"`, then this is printed automatically
#'   when the calling function (or `.envir`) finishes. You can use cli
#'   [inline markup][inline-markup] in this message. If the message contains
#'   [glue][glue::glue()] interpolation, then it be evaluated only when
#'   the status terminates. `cli_status_update()` may update this message.
#' @param msg_failed The message to use when the status terminates, when
#'   the calculation finishes unsuccessfully. If `.auto_close` is `TRUE`
#'   and `.auto_result` is `"failed"`, then this is printed automatically
#'   when the calling function (or `.envir`) finishes. You can use cli
#'   [inline markup][inline-markup] in this message. If the message contains
#'   [glue][glue::glue()] interpolation, then it be evaluated only when
#'   the status terminates. `cli_status_update()` may update this message.
#' @param .keep This argument is now ignored, and only kept for
#'   compatibility. Use the `.auto_result` argument to specify how to
#'   auto-terminate the status. Or use the `result` argument of
#'   `cli_status_clear()` if you clear the status manually.
#' @param .auto_close Whether to terminate the status when the calling
#'   function finishes (or ‘.envir’ is removed from thae stack, if
#'   specified).
#' @param .envir Environment to evaluate the glue expressions in. It is
#'   also used to auto-clear the status if `.auto_close` is `TRUE`.
#' @param .auto_result What to do when auto-terminating the status.
#'   Possible values:
#'   * `clear`: The status is removed from the status bar.
#'   * `done`: The status is removed from the status bar, and the `msg_done`
#'     message is printed.
#'   * `failed`: The status is removed from the status bar, and the
#'     `msg_failed` message is printed.
#'   * `auto`: Automatically choose between `done`, for regular termination,
#'      and `failed`, for R errors and interruptions.
#'   * `autoclear` (default): Automatically choose between `clear`,
#'      for regular termination, and `failed`, for R errors and
#'      interruptions.
#' @return `cli_status` returns the id of the new status, invisibly.
#'
#' @family status bar
#' @export

cli_status <- function(msg, msg_done = paste(msg, "... done"),
                       msg_failed = paste(msg, "... failed"),
                       .keep = FALSE, .auto_close = TRUE,
                       .envir = parent.frame(),
                       .auto_result = c("autoclear", "clear", "done",
                                        "failed", "auto")) {

  auto_result <- match.arg(.auto_result)
  id <- new_uuid()
  status_current_save(.envir, id, msg = msg, msg_done = msg_done,
                      msg_failed = msg_failed, auto_close = .auto_close,
                      auto_result = auto_result)
  cli__message(
    "status",
    list(
      id = id,
      msg = glue_cmd(msg, .envir = .envir)
    ),
    .auto_close = .auto_close,
    .envir = .envir,
    .auto_result = auto_result
  )

  invisible(id)
}

#' @param id Id of the status to update or terminate. If it is `NULL` (the
#'   default), then the current status is manipulated. If
#'   `cli_status_update()` cannot find a status with `id` (or `id` is
#'   `NULL`, and there is no current status), then a warning is issued.
#' @param result The type of termination, may be `"clear"`, `"done"` or
#'   `"failed"`. See more at the `.auto_result` parameter and below.
#' @return `cli_status_clear` returns `NULL`.
#'
#' @rdname cli_status
#' @export

cli_status_clear <- function(id = NULL, result = c("clear", "done", "failed"),
                             msg_done = NULL, msg_failed = NULL,
                             .envir = parent.frame()) {

  rec <- status_current_find(
    .envir,
    id = id,
    msg_done = msg_done,
    msg_failed = msg_failed
  )

  # cleaned up already?
  if (is.null(rec)) return(invisible(NULL))

  result <- match.arg(result[1], c("clear", "done", "failed", "auto", "autoclear"))
  if (result %in% c("auto", "autoclear")) {
    r1 <- stats::runif(1)
    result <- if (identical(returnValue(r1), r1)) {
      "failed"
    } else {
      if (result == "auto") "done" else "clear"
    }
  }

  cli__message(
    "status_clear",
    list(
      id = rec$id,
      result = result,
      msg_done = if (result == "done") glue_cmd(rec$msg_done, .envir = .envir),
      msg_failed = if (result == "failed") glue_cmd(rec$msg_failed, .envir = .envir)
    )
  )
  on.exit(status_current_clear(id = id), add = TRUE)

  invisible(NULL)
}

#' @return `cli_status_update()` returns the id of the status.
#'
#' @rdname cli_status
#' @export

cli_status_update <- function(id = NULL, msg = NULL, msg_done = NULL,
                              msg_failed = NULL, .envir = parent.frame()) {
  rec <- status_current_find(
    .envir,
    id = id,
    msg = msg,
    msg_done = msg_done,
    msg_failed = msg_failed
  )

  # Gone?
  if (is.null(rec)) {
    warning("Cannot update cli status, already cleared")
    return(invisible(NULL))
  }

  cli__message(
    "status_update",
    list(
      msg = glue_cmd(rec$msg, .envir = .envir),
      id = rec$id
    )
  )

  invisible(rec$id)
}

#' Indicate the start and termination of some computation in the status bar
#'
#' @description
#' ```{r child = "man/chunks/status-desc.Rmd"}
#' ```
#'
#' You call `cli_process_start()` to start a status.
#'
#' You may call `cli_process_update()` to update a status, if needed.
#'
#' You may call `cli_process_done()` or `cli_process_failed()` to manually
#' terminate a status, if you are not relying on auto-termination (see
#' above).
#'
#' @details
#' ```{r child = "man/chunks/status.Rmd"}
#' ```
#'
#' ```{r child = "man/chunks/status-diff.Rmd"}
#' ```
#'
#' See examples below.
#'
#' @param msg The message to show to indicate the start of the process or
#'   computation. It will be collapsed into a single string, and the first
#'   line is kept and cut to [console_width()]. You can use cli
#'   [inline markup][inline-markup] in this message. If the message
#'   contains [glue][glue::glue()] interpolation, then it will be evaluated
#'   every time the message is updated.
#' @param msg_done The message to use for successful termination.
#'   You can use cli [inline markup][inline-markup] in this message. If the
#'   message contains [glue][glue::glue()] interpolation, then it will be
#'   evaluated before successful termination.
#' @param msg_failed The message to use for unsuccessful termination.
#'   You can use cli [inline markup][inline-markup] in this message. If the
#'   message contains [glue][glue::glue()] interpolation, then it will be
#'   evaluated before unsuccessful termination.
#' @param on_exit Whether this process should fail or terminate
#'   successfully when the calling function (or the environment in `.envir`)
#'   exits. By default cli auto-detects the correct mode of termination.
#' @param msg_class The style class to add to the message. Use an empty
#'   string to suppress styling.
#' @param done_class The style class to add to the successful termination
#'   message. Use an empty string to suppress styling.
#' @param failed_class The style class to add to the unsuccessful
#'   termination message. Use an empty string to suppress styling.
#' @inheritParams cli_status
#' @return `cli_process_start()` and `cli_process_update()` return the
#'   id of the status. `cli_process_done()` and `cli_process_failed()`
#'   return `NULL`.
#'
#' @family status bar
#' @export
#' @examplesIf interactive()
#'
#' ## Success
#' fun <- function() {
#'   cli_process_start("Step one")
#'   Sys.sleep(1)
#'
#'   cli_process_start("Step two")
#'   Sys.sleep(1)
#' }
#' fun()
#'
#' ## Failure
#' fun2 <- function() {
#'   cli_process_start("Step one")
#'   Sys.sleep(1)
#'
#'   cli_process_start("Step two")
#'   Sys.sleep(1)
#'
#'   stop("oops")
#' }
#'
#' fun2()

cli_process_start <- function(msg, msg_done = msg, msg_failed = msg,
                              on_exit = c("auto", "autoclear", "failed", "done"),
                              msg_class = "alert-info",
                              done_class = "alert-success",
                              failed_class = "alert-danger",
                              .auto_close = TRUE, .envir = parent.frame()) {

  # Force the defaults, because we might modify msg
  msg_done
  msg_failed

  if (length(msg_class) > 0 && msg_class != "") {
    msg <- paste0("{.", msg_class, " ", msg, "}")
  }
  if (length(done_class) > 0 && done_class != "") {
    msg_done <- paste0("{.", done_class, " ", msg_done, "}")
  }
  if (length(failed_class) > 0 && failed_class != "") {
    msg_failed <- paste0("{.", failed_class, " ", msg_failed, "}")
  }

  cli_status(msg, msg_done, msg_failed, .auto_close = .auto_close,
             .envir = .envir, .auto_result = match.arg(on_exit))
}

#' @param id Id of the status to update or terminate. If it is `NULL` (the
#'   default), then the current status is manipulated. If
#'   `cli_process_update()` cannot find a status with `id` (or `id` is
#'   `NULL`, and there is no current status), then a warning is issued.
#'
#' @rdname cli_process_start
#' @export

cli_process_update <- function(id = NULL, .envir = parent.frame()) {
  cli_status_update(
    id = id,
    .envir = .envir
  )
}

#' @param id Id of the status to clear. If `id` is not the id
#'   of the current status (because it was overwritten by another
#'   status ), then the status bar is not cleared. If `NULL`
#'   (the default) then the status bar is always cleared.
#'
#' @rdname cli_process_start
#' @export

cli_process_done <- function(id = NULL, msg_done = NULL,
                             .envir = parent.frame(),
                             done_class = "alert-success") {

  if (!is.null(msg_done) && length(done_class) > 0 && done_class != "") {
    msg_done <- paste0("{.", done_class, " ", msg_done, "}")
  }
  cli_status_clear(id, result = "done", msg_done = msg_done, .envir = .envir)
}

#' @rdname cli_process_start
#' @export

cli_process_failed <- function(id = NULL, msg = NULL, msg_failed = NULL,
                               .envir = parent.frame(),
                               failed_class = "alert-danger") {
  if (!is.null(msg_failed) && length(failed_class) > 0 &&
      failed_class != "") {
    msg_failed <- paste0("{.", failed_class, " ", msg_failed, "}")
  }
  cli_status_clear(
    id,
    result = "failed",
    msg_failed = msg_failed,
    .envir = .envir
  )
}

# -----------------------------------------------------------------------
# client side tools
# -----------------------------------------------------------------------

status_current_save <- function(.envir, id, msg, msg_done, msg_failed,
                                auto_close, auto_result) {
  key <- format(.envir)
  old <- clienv$status[[key]]
  if (!is.null(old) && old$id != id && old$auto_close) {
    # no error, so status is "done"
    if (old$auto_result == "auto") old$auto_result <- "done"
    if (old$auto_result == "autoclear") old$auto_result <- "clear"
    cli_status_clear(id = old$id, result = old$auto_result, .envir = .envir)
  }
  clienv$status[[id]] <- clienv$status[[key]] <- list(
    id = id,
    key = key,
    msg = msg,
    msg_done = msg_done,
    msg_failed = msg_failed,
    auto_close = auto_close,
    auto_result = auto_result
  )
  invisible()
}

status_current_find <- function(.envir, id = NULL, msg = NULL,
                                msg_done = NULL, msg_failed = NULL) {
  key <- id %||% format(.envir)
  value <- clienv$status[[key]]
  if (!is.null(value) && !is.null(msg)) {
    clienv$status[[key]]$msg <- msg
  }
  if (!is.null(value) && !is.null(msg_done)) {
    clienv$status[[key]]$msg_done <- msg_done
  }
  if (!is.null(value) && !is.null(msg_failed)) {
    clienv$status[[key]]$msg_failed <- msg_failed
  }
  clienv$status[[key]]
}

status_current_clear <- function(id = NULL) {
  old <- clienv$status[[id]]
  clienv$status[[id]] <- NULL

  # If removed by id, check if current, and remove by the other name as well
  if (identical(clienv$status[[old$key]]$id, id)) {
    clienv$status[[old$key]] <- NULL
  }
}

# -----------------------------------------------------------------------
# server side
# -----------------------------------------------------------------------

clii_status <- function(app, id, msg, globalenv) {

  app$status_bar[[id]] <- list(
    content = ""
  )
  if (isTRUE(getOption("cli.hide_cursor", TRUE)) && ! globalenv) {
    ansi_hide_cursor(app$output)
  }
  clii_status_update(app, id, msg)
}

clii_status_clear <- function(app, id, result, msg_done, msg_failed) {
  ## If NA then the most recent one
  if (is.na(id)) id <- names(app$status_bar)[1]

  ## If no active status bar, then ignore
  if (is.na(id)) return(invisible())
  if (! id %in% names(app$status_bar)) return(invisible())

  if (result == "done") {
    msg <- msg_done %||% app$status_bar[[id]]$msg_done
    clii_status_update(app, id, msg)
  } else if (result == "failed") {
    msg <- msg_failed %||% app$status_bar[[id]]$msg_failed
    clii_status_update(app, id, msg)
  }

  if (names(app$status_bar)[1] == id) {
    ## This is the active one
    if (result != "clear") {
      ## Keep? Just emit it
      app$cat("\n")

    } else {
      ## Not keep? Remove it
      clii__clear_status_bar(app)
    }
    if (isTRUE(getOption("cli.hide_cursor", TRUE))) {
      ansi_show_cursor(app$output)
    }

  } else {
    if (result != "clear") {
      ## Keep?
      clii__clear_status_bar(app)
      app$cat(paste0(app$status_bar[[id]]$content, "\n"))
      app$cat(paste0(app$status_bar[[1]]$content, "\r"))

    } else {
      ## Not keep? Nothing to output
    }
  }

  ## Remove
  app$status_bar[[id]] <- NULL

  ## Switch to the previous one
  if (length(app$status_bar)) {
    app$cat(paste0(app$status_bar[[1]]$content, "\r"))
  }
}

clii_status_update <- function(app, id, msg) {
  ## If NA then the most recent one
  if (is.na(id)) id <- names(app$status_bar)[1]

  ## If no active status bar, then ignore
  if (is.na(id)) return(invisible())

  ## Do we have a new message?
  if (is.null(msg)) return(invisible())

  ## Do we need to clear the current content?
  current <- paste0("", app$status_bar[[1]]$content)

  ## Format the line
  content <- ""
  fmsg <- app$inline(msg)
  cfmsg <- ansi_strtrim(fmsg, width = app$get_width())
  content <- strsplit(cfmsg, "\r?\n")[[1]][1]
  if (is.na(content)) content <- ""

  ## Update status bar, put it in front
  app$status_bar[[id]]$content <- content
  app$status_bar <- c(
    app$status_bar[id],
    app$status_bar[setdiff(names(app$status_bar), id)])

  ## New content, if it is an ANSI terminal we'll overwrite and clear
  ## until the end of the line. Otherwise we add some space characters
  ## to the content to make sure we clear up residual content.
  output <- get_real_output(app$output)
  if (is_ansi_tty(output)) {
    app$cat(paste0("\r", content, ANSI_EL, "\r"))
  } else if (is_dynamic_tty(output)) {
    nsp <- max(ansi_nchar(current) - ansi_nchar(content), 0)
    app$cat(paste0("\r", content, strrep(" ", nsp), "\r"))
  } else {
    app$cat(paste0(content, "\n"))
  }

  ## Reset timer
  .Call(clic_tick_reset)

  invisible()
}

clii__clear_status_bar <- function(app) {
  output <- get_real_output(app$output)
  if (is_ansi_tty(output)) {
    app$cat(paste0("\r", ANSI_EL))
  } else if (is_dynamic_tty(output)) {
    text <- app$status_bar[[1]]$content
    len <- ansi_nchar(text, type = "width")
    app$cat(paste0("\r", strrep(" ", len), "\r"))
  }
}
