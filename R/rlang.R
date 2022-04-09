
#' Signal an error, warning or message with a cli formatted
#' message
#'
#' These functions let you create error, warning or diagnostic
#' messages with cli formatting, including inline styling,
#' pluralization and glue substitutions.
#'
#' @details
#'
#' ```{asciicast cli-abort}
#' n <- "boo"
#' cli_abort(c(
#'         "{.var n} must be a numeric vector",
#'   "x" = "You've supplied a {.cls {class(n)}} vector."
#' ))
#' ```
#'
#' ```{asciicast cli-abort-2}
#' len <- 26
#' idx <- 100
#' cli_abort(c(
#'         "Must index an existing element:",
#'   "i" = "There {?is/are} {len} element{?s}.",
#'   "x" = "You've tried to subset element {idx}."
#' ))
#' ```
#'
#' @param message It is formatted via a call to [cli_bullets()].
#' @param ... Passed to [rlang::abort()], [rlang::warn()] or
#'   [rlang::inform()].
#' @param .envir Environment to evaluate the glue expressions in.
#' @inheritParams rlang::abort
#'
#' @export

cli_abort <- function(message,
                      ...,
                      .envir = parent.frame(),
                      call = .envir) {
  message[] <- vcapply(message, format_inline, .envir = .envir)
  rlang::abort(
    message,
    ...,
    call = call,
    use_cli_format = TRUE
  )
}

#' @rdname cli_abort
#' @export

cli_warn <- function(message, ..., .envir = parent.frame()) {
  message[] <- vcapply(message, format_inline, .envir = .envir)
  escaped_message <- cli_escape(message)
  rlang::warn(
    format_warning(escaped_message, .envir = .envir),
    cli_bullets = message,
    ...
  )
}

#' @rdname cli_abort
#' @export

cli_inform <- function(message, ..., .envir = parent.frame()) {
  message[] <- vcapply(message, format_inline, .envir = .envir)
  escaped_message <- cli_escape(message)
  rlang::inform(
    format_message(message, .envir = .envir),
    cli_bullets = message,
    ...
  )
}
