
# -----------------------------------------------------------------------
# Client API
# -----------------------------------------------------------------------

#' @export

job_add <- function(name = NULL, id = NULL, status = NA, total = NA,
                    type = c("iterator", "tasks", "download", "custom"),
                    format = NULL, estimate = NULL,
                    auto_estimate = TRUE, group = NULL,
                    .envir = parent.frame()) {

  id <- id %||% new_uuid()
  cli__progress_message(
    "add_job",
    name = name,
    id = id,
    status = status,
    total = total,
    type = match.arg(type),
    format = format,
    estimate = estimate,
    auto_estimate = auto_estimate,
    group = group
  )
  invisible(id)
}

#' @export

job_add_group <- function(name = NULL, id = NULL,
                          type = c("gtasks", "gdownloads", "custom"),
                          format = NULL, status = NULL) {

  id <- id %||% new_uuid()
  cli__progress_message(
    "add_job_group",
    name = name,
    id = id,
    type = match.arg(type),
    format = format,
    status = status
  )
  invisible(id)
}

#' @export

job_set_progress <- function(id, progress) {
  cli__progress_message(
    "set_job_progress",
    id = id,
    progress = progress
  )
  invisible(id)
}

#' @export

job_add_progress <- function(id, increment = 1L) {
  cli__progress_message(
    "add_job_progress",
    id = id,
    increment = increment
  )
  invisible(id)
}

#' @export

job_set_status <- function(id, status) {
  cli__progress_message(
    "set_job_status",
    id = id,
    status = status
  )
  invisible(id)
}

#' @export

job_set_estimate <- function(id, seconds) {
  cli__progress_message(
    "set_job_estimate",
    id = id,
    seconds = seconds
  )
  invisible(id)
}

#' @export

job_add_output <- function(id, output,
                           output_type = c("message", "warning")) {
  cli__progress_message(
    "add_job_output",
    id = id,
    output = output,
    output_type = match.arg(output_type)
  )
  invisible(id)
}

#' @export

job_complete <- function(id, succeeded = TRUE, output = NULL,
                         error = NULL) {
  cli__progress_message(
    "complete_job",
    id = id,
    succeeded = succeeded,
    output = output,
    error = error
  )
  invisible(id)
}

#' @export

job_complete_process <- function(pid, succeeded = FALSE, error = NULL) {
  stop("Processes are not implemented yet")
  cli__progress_message(
    "complete_process",
    pid = pid,
    succeeded = succeeded,
    error = error
  )
  invisible()
}

cli__progress_message <- function(msgtype, ...) {
  cond <- list(...)
  cond$msgtype <- msgtype
  cond$version <- clienv$progress_client_version
  cond$pid <- clienv$pid
  class(cond) <-  c("progress_message", "callr_message", "condition")

  handle_here <- function(msg) {
    handle_progress_message(msg)
  }

  withRestarts({
    signalCondition(cond)
    handle_here(cond)
  }, progress_message_handled = function(...) NULL)

  invisible()
}
