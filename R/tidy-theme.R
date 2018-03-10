
#' The default CLI theme
#'
#' Note that this is in addition to the builtin theme.
#'
#' @export

default_theme <- function() {
  list(
    ".alert-start" = list(
      before = paste0(symbol$arrow_right, " ")),
    span.version = list(color = "magenta"),
    span.timestamp = list(color = "cyan")
  )
}
