
# -----------------------------------------------------------------------
# Default handler in the cli status bar
# -----------------------------------------------------------------------

#' @export

progress_handler_cli <- function() {

  h <- clienv$progress_handler_cli
  if (!is.null(h)) return(h)

  cenv <- new.env(parent = emptyenv())

  display <- function(id) {
    cenv[[id]][["_sbid"]] <-
      cenv[[id]][["_sbid"]] %||% cli_status("", .auto_close = FALSE)
    cli_status_update(progress_cli_format(cenv[[id]]), id = cenv[[id]][["_sbid"]])
  }

  clienv$progress_handler_cli <- list(

    add_job = function(msg, data) {
      msg$data <- list(
        current = 0L,
        eta = msg$estimate,
        id = msg$id,
        name = msg$name %||% "",
        pid = msg$pid,
        status = msg$status %||% "",
        total = msg$total
      )
      msg$data <- modifyList(msg$data, msg$tokens)
      cenv[[msg$id]] <- msg
      display(msg$id)
    },

    add_job_group = function(msg, data) {
      # TODO: implement groups
    },

    set_job_progress = function(msg, data) {
      if (is.null(cenv[[msg$id]])) return()
      cenv[[msg$id]]$data$current <- msg$progress
      cenv[[msg$id]]$data <- modifyList(cenv[[msg$id]]$data, msg$tokens)
      display(msg$id)
    },

    add_job_progress = function(msg, data) {
      if (is.null(cenv[[msg$id]])) return()
      cenv[[msg$id]]$data$current <- cenv[[msg$id]]$data$current + msg$increment
      cenv[[msg$id]]$data <- modifyList(cenv[[msg$id]]$data, msg$tokens)
      display(msg$id)
    },

    set_job_status = function(msg, data) {
      if (is.null(cenv[[msg$id]])) return()
      cenv[[msg$id]]$data$status <- msg$status
      cenv[[msg$id]]$data <- modifyList(cenv[[msg$id]]$data, msg$tokens)
      display(msg$id)
    },

    set_job_estimate = function(msg, data) {
      if (is.null(cenv[[msg$id]])) return()
      cenv[[msg$id]]$data$eta <- msg$seconds
      cenv[[msg$id]]$data <- modifyList(cenv[[msg$id]]$data, msg$tokens)
      display(msg$id)
    },

    add_job_output = function(msg, data) {
      # TODO: what to do with this?
      display(msg$id)
    },

    complete_job = function(msg, data) {
      # TODO: show success or error?
      display(msg$id)
      if (!is.null(sbid <- cenv[[msg$id]][["_sbid"]])) {
        cli_status_clear(sbid)
      }
      cenv[[msg$id]] <- NULL
    },

    complete_process = function(msg, data) {
      # TODO: show success or error?
      for (i in ls(cenv, all.names = TRUE)) {
        if (identical(cenv[[i]]$pid, msg$pid)) {
          if (!is.null(sbid <- cenv[[i]][["_sbid"]])) {
            cli_status_clear(sbid)
          }
          display(cenv[[i]]$id)
          cenv[[i]] <- NULL
        }
      }
    },

    format = function() "cli progress bar handler"
  )

  clienv$progress_handler_cli
}

progress_cli_format <- function(rec) {
  # TODO: format
  fmt <- rec$format %||% "{name} {current}/{total} | {status}"
  glue::glue(fmt, .envir = rec$data)
}
