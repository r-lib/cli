

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
