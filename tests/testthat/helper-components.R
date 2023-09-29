
styled_text <- function(text, style = NULL) {
  structure(text, style = style)
}

styled_sub <- function(value, code = "x", style = NULL) {
  structure(
    list(value = value, code = code, style = style),
    class = "cli_sub"
  )
}
