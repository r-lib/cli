
#' @export

cli_progress_bar <- function(name = NULL,
                             status = NULL,
                             type = c("iterator", "tasks", "download",
                                      "custom"),
                             total = NA,
                             format = NULL,
                             estimate = NULL,
                             auto_estimate = TRUE,
                             clear = TRUE,
                             .auto_close = TRUE,
                             .envir = parent.frame()) {

  start <- Sys.time()
  id <- new_uuid()
  envkey <- format(.envir)
  type <- match.arg(type)
  if (type == "custom" && is.null(format)) {
    stop("Need to specify format if `type == \"custom\"")
  }

  clienv$progress[[id]] <- list(
    name = name,
    status = status,
    type = match.arg(type),
    total = total,
    format = format,
    estimate = estimate,
    auto_estimate= auto_estimate,
    clear = clear,
    envkey = envkey,
    current = 0L,
    start = start
  )

  clienv$progress[[envkey]] <- id

  if (.auto_close && envkey != clienv$globalenv) {
    defer(cli_progress_done(id = id, .envir = .envir), envir = .envir)
  }

  invisible(id)
}

#' @export

cli_progress_update <- function(add = NULL, set = NULL, id = NULL,
                                .envir = parent.frame()) {
  id <- id %||% clienv$progress[[format(.envir)]]
  if (is.null(id)) stop("Cannot find last progress bar")
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

  if (should_tick) {
    if (is.null(pb$format)) {
      pb$format <- pb__default_format(pb$type, pb$total)
    }

    opt <- options(cli__pb = pb)
    on.exit(options(opt), add = TRUE)

    if (is.null(pb$status)) {
      pb$status <- cli_status(pb$format, .auto_close = FALSE, .envir = .envir)
    } else {
      cli_status_update(id = pb$status, pb$format, .envir = .envir)
    }
    pb <- getOption("cli__pb")
  }

  clienv$progress[[id]] <- pb

  invisible(id)
}

#' @export

cli_progress_done <- function(id = NULL, .envir = parent.frame()) {
  id <- id %||% clienv$progress[[format(.envir)]]
  if (is.null(id)) return()
  pb <- clienv$progress[[id]]
  if (is.null(pb)) return()

  if (!is.null(pb$status)) {
    if (pb$clear) {
      cli_status_clear(pb$status, result = "clear")
    } else {
      cli_status_clear(pb$status, result = "done", msg_done = pb$msg)
    }
  }

  envkey <- format(.envir)
  clienv$progress[[id]] <- NULL
  clienv$progress[[envkey]] <- NULL

  invisible(id)
}

# ------------------------------------------------------------------------

pb__default_format <- function(type, total) {
  if (type == "iterator") {
    if (!is.na(total)) {
      paste0(
        "{cli::pb_name}| {cli::pb_bar} {cli::pb_percent} | {cli::pb_status}",
        "ETA: {cli::pb_eta}"
      )
    } else {
      paste0(
        "[{cli::pb_spin}] {cli::pb_elapsed} {cli::pb_name}{cli::pb_status}",
        "| {cli::pb_current} done ({cli::pb_rate})"
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
        "[{cli::pb_spin}] {cli::pb_elapsed} {cli::pb_name}{cli::pb_status}",
        "| {cli::pb_current} done ({cli::pb_rate})"
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
        "[{cli::pb_spin}] {cli::pb_elapsed} {cli::pb_name}{cli::pb_status}",
        "| {cli::pb_current_bytes} ({cli::pb_rate})"
      )
    }
  }
}
