
#' Signal an error, warning or message with a cli formatted
#' message
#'
#' These functions let you create error, warning or diagnostic
#' messages with cli formatting, including inline styling,
#' pluralization andglue substitutions.
#'
#' @param message It is formatted via a call to [cli_bullets()].
#' @param ... Passed to [rlang::abort()], [rlang::warn()] or
#'   [rlang::inform()].
#' @param .envir Environment to evaluate the glue expressions in.
#'
#' @export
#' @examples
#' \dontrun{
#' n <- "boo"
#' cli_abort(c(
#'         "{.var n} must be a numeric vector",
#'   "x" = "You've supplied a {.cls {class(n)}} vector."
#' ))
#'
#' len <- 26
#' idx <- 100
#' cli_abort(c(
#'         "Must index an existing element:",
#'   "i" = "There {?is/are} {len} element{?s}.",
#'   "x" = "You've tried to subset element {idx}."
#' ))
#' }

cli_abort <- function(message, ..., .envir = parent.frame()) {
  rlang::abort(format_error(message, .envir = .envir), ...)
}

#' @rdname cli_abort
#' @export

cli_warn <- function(message, ..., .envir = parent.frame()) {
  rlang::warn(format_warning(message, .envir = .envir), ...)
}

#' @rdname cli_abort
#' @export

cli_inform <- function(message, ..., .envir = parent.frame()) {
  cli_status("", "", "")
  rlang::inform(format_message(message, .envir = .envir), ...)
}
