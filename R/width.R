
#' Determine the width of the console
#'
#' It uses the `RSTUDIO_CONSOLE_WIDTH` environment variable, if set.
#' Otherwise it uses the `width` option. If this is not set either,
#' then 80 is used.
#'
#' @return Integer scalar, the console with, in number of characters.
#' 
#' @export

console_width <- function() {
  width <- Sys.getenv("RSTUDIO_CONSOLE_WIDTH", getOption("width", 80))
  as.integer(width)
}
