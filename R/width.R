
#' Determine the width of the console
#'
#' It uses the `cli.width` option, if set. Otherwise it uses
#' the `width` option, if set. Otherwise it return 80.
#'
#' @return Integer scalar, the console with, in number of characters.
#'
#' @export

console_width <- function() {
  width <- getOption(
    "cli.width",
    getOption("width", 80)
  )
  as.integer(width)
}
