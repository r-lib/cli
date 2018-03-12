
#' The default CLI theme
#'
#' Note that this is in addition to the builtin theme.
#'
#' @export

default_theme <- function() {
  list(
    ".alert-start::before" = list(
      content = paste0(symbol$arrow_right, " ")),
    span.pkg = list(
      color = "blue",
      "font-weight" = "bold"),
    span.version = list(color = "blue"),
    span.timestamp = list(color = "grey"),
    "span.timestamp::before" = list(
      content = "["),
    "span.timestamp::after" = list(
      content = "]")
  )
}
