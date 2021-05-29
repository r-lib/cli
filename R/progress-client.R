
#' @export

cli_progress_bar <- function(name = NULL,
                             status = NULL,
                             type = c("iterator", "tasks", "download",
                                      "custom"),
                             total = NA,
                             show_after = 2,
                             format = NULL,
                             format_done = NULL,
                             format_failed = NULL,
                             estimate = NULL,
                             auto_estimate = TRUE,
                             clear = TRUE,
                             current = TRUE,
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
  bar$show_after <- start + show_after
  bar$format <- format
  bar$format_done <- format_done
  bar$format_failed <- format_failed
  bar$estimate <- estimate
  bar$auto_estimate <- auto_estimate
  bar$clear <- clear
  bar$envkey <- if (current) envkey else NULL
  bar$current <- 0L
  bar$start <- start
  bar$tick <- 0L
  clienv$progress[[id]] <- bar
  if (current) {
    if (!is.null(clienv$progress[[envkey]])) {
      cli_progress_done(clienv$progress[[envkey]], .envir = .envir)
    }
    clienv$progress[[envkey]] <- id
  }

  if (.auto_close && envkey != clienv$globalenv) {
    defer(cli_progress_done(id = id, .envir = .envir), envir = .envir)
  }

  invisible(id)
}

#' @export

cli_progress_update <- function(add = NULL, set = NULL, id = NULL,
                                force = FALSE, .envir = parent.frame()) {
  id <- id %||% clienv$progress[[format(.envir)]]
  if (is.null(id)) {
    envkey <- format(.envir)
    stop("Cannot find current progress bar for `", envkey, "`")
  }
  pb <- clienv$progress[[id]]
  if (is.null(pb)) stop("Cannot find progress bar `", id, "`")

  if (!is.null(set)) {
    pb$current <- set
  } else {
    pb$current <- pb$current + (add %||% 1L)
  }

  if (!is.na(pb$total) && pb$current == pb$total) {
    cli_progress_done(id, .envir = .envir)
    return(invisible(id))
  }

  now <- .Call(clic_get_time)
  if (should_tick || force || now > bar$show_after) {
    pb$tick <- pb$tick + 1L
    if (is.null(pb$format)) {
      pb$format <- pb__default_format(pb$type, pb$total)
    }

    opt <- options(cli__pb = pb)
    on.exit(options(opt), add = TRUE)

    if (is.null(pb$statusbar)) {
      pb$statusbar <- cli_status(
        pb$format,
        msg_done = pb$format_done %||% pb$format,
        msg_failed = pb$format_failed %||% pb$format,
        .auto_close = FALSE,
        .envir = .envir,

      )
    } else {
      cli_status_update(id = pb$statusbar, pb$format, .envir = .envir)
    }
  }

  # Return TRUE, to allow cli_progress_update() && break in loops
  invisible(TRUE)
}

#' @export

cli_progress_done <- function(id = NULL, .envir = parent.frame(),
                              result = "auto") {
  envkey <- format(.envir)
  id <- id %||% clienv$progress[[envkey]]
  if (is.null(id)) return(invisible())
  pb <- clienv$progress[[id]]
  if (is.null(pb)) return(invisible())

  if (!is.null(pb$statusbar)) {
    if (pb$clear) {
      cli_status_clear(pb$statusbar, result = "clear", .envir = .envir)
    } else {
      cli_status_clear(
        pb$statusbar,
        result = result,
        msg_done = pb$format_done,
        msg_failed = pb$format_failed,
        .envir = .envir
      )
    }
  }

  clienv$progress[[id]] <- NULL
  if (!is.null(pb$envkey)) clienv$progress[[pb$envkey]] <- NULL

  invisible(id)
}

#' @export

cli_progress_set_status <- function(msg,
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
      paste0(
        "{cli::pb_name}{cli::pb_bar} {cli::pb_percent} | {cli::pb_status}",
        "ETA: {cli::pb_eta}"
      )
    } else {
      paste0(
        "[{cli::pb_spin}] {cli::pb_name}{cli::pb_status}",
        "{cli::pb_current} done ({cli::pb_rate}) | {cli::pb_elapsed}"
      )
    }

  } else if (type == "tasks") {
    if (!is.na(total)) {
      paste0(
        "[{cli::pb_spin}] {cli::pb_current}/{cli::pb_total} ",
        "ETA: {cli::pb_eta} | {cli::pb_name}{cli::pb_status}"
      )
    } else {
      paste0(
        "[{cli::pb_spin}] {cli::pb_name}{cli::pb_status}",
        "{cli::pb_current} done ({cli::pb_rate}) | {cli::pb_elapsed}"
      )
    }

  } else if (type == "download") {
    if (!is.na(total)) {
      paste0(
        "[{cli::pb_spin}] {cli::pb_name}{cli::pb_status}| ",
        "{cli::pb_current_bytes}/{cli::pb_total_bytes} ETA: {cli::pb_eta}"
      )
    } else {
      paste0(
        "[{cli::pb_spin}] {cli::pb_name}{cli::pb_status}",
        "{cli::pb_current_bytes} ({cli::pb_rate_bytes}) | {cli::pb_elapsed}"
      )
    }
  }
}
