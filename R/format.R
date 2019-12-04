
#' Format a value for printing
#'
#' This function can be used directly, or via the `{.val ...}` inline
#' style. `{.val {expr}}` calls `cli_format()` automatically on the value
#' of `expr`, before styling and collapsing it.
#'
#' It is possible to define new S3 methods for `cli_format` and then
#' these will be used automatically for `{.cal ...}` expressions.
#'
#' @param x The object to format.
#' @param style List of formatting options, see the individual methods
#'   for the style options they support.
#' @param ... Additional arguments for methods.
#'
#' @export
#' @examples
#' things <- c(rep("this", 3), "that")
#' cli_format(things)
#' cli_text("{.val {things}}")
#'
#' nums <- 1:5 / 7
#' cli_format(nums, style = list(digits = 2))
#' cli_text("{.val {nums}}")
#' divid <- cli_div(theme = list(.val = list(digits = 3)))
#' cli_text("{.val {nums}}")
#' cli_end(divid)

cli_format <- function(x, style = list(), ...)
  UseMethod("cli_format")

#' @rdname cli_format
#' @export

cli_format.default <- function(x, style = list(), ...) {
  x
}

#' * Styles for character vectors:
#'   - `string_quote` is the quoting character for [encodeString()].
#'
#' @rdname cli_format
#' @export

cli_format.character <- function(x, style = list(), ...) {
  quote <- style$string_quote %||% "'"
  encodeString(x, quote = quote)
}

#' * Styles for numeric vectors:
#'   - `digits` is the number of digits to print after the decimal point.
#'
#' @rdname cli_format
#' @export

cli_format.numeric <- function(x, style = list(), ...) {
  digits <- style$digits
  if (!is.null(digits)) x <- round(x, digits)
  x
}
