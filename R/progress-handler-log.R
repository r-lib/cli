
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
