
#' Simulate (a subset of) a VT-5xx ANSI terminal
#'
#' This is utility function that calculates the state of a VT-5xx screen
#' after a certain set of output.
#'
#' Currently it supports:
#'
#' - configurable terminal width and height
#' - ASCII printable characters.
#' - `\n`, `\r`.
#' - ANSI SGR colors, 8 color mode, 256 color mode and true color mode.
#' - Other ANSI SGR features: bold, italic, underline, strikethrough,
#'   blink, inverse.
#'
#' It does _not_ currently supports other features, mode notably:
#'
#' - Other ANSI control sequences and features. Other control sequences
#'   are silently ignored.
#' - Wide Unicode characters. Their width is not taken into account
#'   correctly.
#' - Unicode graphemes.
#'
#' @param output Character vector or raw vector. Character vectors are
#' collapsed (without a separater), and converted to a raw vector using
#' [base::charToRaw()].
#' @param width Terminal width.
#' @param height Terminal height.
#'
#' @note
#' This function is experimental, and the virtual temrinal API will
#' likely change in future versions of cli.
#'
#' @export

vt_simulate <- function(output, width = 80L, height = 25L) {
  if (is.character(output)) {
    output <- charToRaw(paste(output, collapse = ""))
  }

  screen <- .Call(
    clic_vt_simulate,
    output,
    as.integer(width),
    as.integer(height)
  )

  for (i in seq_along(screen)) {
    screen[[i]][[1]] <- intToUtf8(screen[[i]][[1]])
  }

  screen
}
