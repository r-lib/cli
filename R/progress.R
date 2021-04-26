
# -----------------------------------------------------------------------
# Client API
# -----------------------------------------------------------------------

#' @export

job_add <- function(name = NULL, id = NULL, status = NULL, total = 100,
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
                          format = NULL, status = NULL,
                          .envir = parent.frame()) {

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

job_set_progress <- function(progress, id = NULL, .envir = parent.frame()) {
  id <- find_progress_id(id)
  cli__progress_message("set_job_progress",  progress = progress, id = id)
  invisible(id)
}

#' @export

job_add_progress <- function(increment = 1L, id = NULL,
                             .envir = parent.frame()) {
  id <- find_progress_id(id)
  cli__progress_message("add_job_progress", increment = increment, id = id)
  invisible(id)
}

#' @export

job_set_status <- function(status, id = NULL, .envir = parent.frame()) {
  id <- find_progress_id(id)
  cli__progress_message("set_job_status", status = status, id = id)
  invisible(id)
}

#' @export

job_set_estimate <- function(seconds, id = NULL, .envir = parent.frame()) {
  id <- find_progress_id(id)
  cli__progress_message("set_job_estimate", seconds = seconds, id = id)
  invisible(id)
}

#' @export

job_add_output <- function(output, id = NULL,
                           output_type = c("message", "warning"),
                           .envir = parent.frame()) {
  id <- find_progress_id(id)
  cli__progress_message(
    "add_job_output",
    output = output,
    id = id,
    output_type = match.arg(output_type)
  )
  invisible(id)
}

#' @export

job_complete <- function(succeeded = TRUE, output = NULL, error = NULL,
                         id = NULL, .envir = parent.frame()) {
  id <- find_progress_id(id)
  cli__progress_message(
    "complete_job",
    succeeded = succeeded,
    output = output,
    error = error,
    id = id
  )
  invisible(id)
}

#' @export

job_complete_process <- function(pid, succeeded = FALSE, error = NULL,
                                 .envir = parent.frame()) {
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

find_progress_id <- function(id) {
  ## TODO
  id
}

# -----------------------------------------------------------------------
# Server API
# -----------------------------------------------------------------------

check_msg <- function(msg) {
  if (is.null(msg$msgtype)) {
    warning("Invalid progress message, no `msgtype`")
    FALSE
  } else if (is.null(msg$version)) {
    warning("Invalid progress message, no `version`")
    FALSE
  } else if (package_version(clienv$progress_server_version) <
             msg$version) {
    # TODO: silently ignore?
    FALSE
  } else if (!is_string(msg$id)) {
    warning("Invalid progress bar id, must be a string")
    FALSE
  } else {
    TRUE
  }
}

handle_progress_message <- function(msg) {
  if (!check_msg(msg)) return()

  # Run default, unless opted out
  if (!isTRUE(getOption("progress_omit_default_handler"))) {
    run_handler(choose_default_handler(), msg)
  }

  # Run others as well
  hs <- getOption("progress_handlers_override", clienv$progress_handlers)

  # TODO: ignore warnings and errors?
#  tryCatch(
    withCallingHandlers(
      eapply(hs, run_handler, msg),
      warning = function(w) NULL
    )#,
#    error = function(e) NULL
#  )

  invisible()
}

choose_default_handler <- function() {
  # TODO: add others
  progress_handler_cli()
}

run_handler <- function(handler_record, msg) {
  handler <- handler_record$handler
  if (msg$msgtype %in% names(handler)) {
    handler[[msg$msgtype]](msg)
  } else if ("*" %in% names(handler)) {
    handler[["*"]](msg)
  }
}

# -----------------------------------------------------------------------
# Add/remove handlers API
# -----------------------------------------------------------------------

new_handler_record <- function(id, handler, data = NULL, ...) {
  config <- list(id = id, ...)
  list(handler = handler, data = data, config = config)
}

#' @export

progress_handler_add <- function(handler, id = NULL, data = NULL) {
  id <- id %||% generate_id()
  clienv$progress_handlers[[id]] <- new_handler_record(
    id,
    handler,
    data = data
  )
}

#' @export

progress_handler_list <- function() {
  # TODO: pretty print this
  as.list(clienv$progress_handlers)
}

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
    cli_status_update(progress_format(cenv[[id]]), id = cenv[[id]][["_sbid"]])
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

progress_format <- function(rec) {
  # TODO: format
  fmt <- rec$format %||% "{name} {current}/{total} | {status}"
  glue::glue(fmt, .envir = rec$data)
}

# -----------------------------------------------------------------------
# Logging handler
# -----------------------------------------------------------------------

#' @export
#' @importFrom glue glue

progress_handler_log <- function(output = "", prefix = NULL) {

  force(output)
  prefix <- prefix %||% ""
  log <- function(txt) {
    txt <- paste0(prefix, txt)
    cat(glue::glue(txt, .envir = parent.frame()), sep = "\n", file = output)
  }

  list(
    add_job = function(msg, data) {
      log("{msg$id} add_job")
    },

    add_job_group = function(msg, data) {
      log("{msg$id} add_group")
    },

    set_job_progress = function(msg, data) {
      log("{msg$id} set_job_progress {msg$progress}")
    },

    add_job_progress = function(msg, data) {
      log("{msg$id} add_job_progress {msg$increment}")
    },

    set_job_status = function(msg, data) {
      log("{msg$id} set_job_status {msg$status}")
    },

    set_job_estimate = function(msg, data) {
      log("{msg$id} set_job_estimate {msg$seconds}")
    },

    add_job_output = function(msg, data) {
      log("{msg$id} add_job_output {msg$output}")
    },

    complete_job = function(msg, data) {
      log("{msg$id} complete_job success: {msg$succeeded}")
    },

    complete_progress = function(msg, data) {
      log("{msg$id} complete_process {msg$pid}")
    },

    format = function() "log progress bar handler"
  )
}

# -----------------------------------------------------------------------
# Internals
# -----------------------------------------------------------------------
