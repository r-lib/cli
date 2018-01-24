
#' @importFrom crayon combine_styles underline bold italic
#'   green red yellow cyan

cli_default_theme <- function() {
  list(
    h1 = list(
      fmt = combine_styles(bold, italic),
      margin = list(top = 1, bottom = 1)),
    h2 = list(
      fmt = bold,
      margin = list(top = 1, bottom = 1)),
    h3 = list(
      fmt = underline,
      margin = list(top = 1, bottom = 0)),

    text = list(),
    verbatim = list(),

    alert_success = list(
      marker = symbol$tick,
      fmt = green
    ),
    alert_danger = list(
      marker = symbol$cross,
      fmt = red
    ),
    alert_warning = list(
      marker = symbol$warning,
      fmt = yellow
    ),
    alert_info = list(
      marker = symbol$info,
      fmt = cyan)
  )
}
