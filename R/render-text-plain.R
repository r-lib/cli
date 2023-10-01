render_inline_text_piece_plain <- function(txt) {
  style <- as.list(attr(txt, "style"))
  txt <- paste(txt, collapse = "")
  # handles backgrond-color, color, fmt, font-style, font-weight,
  # text-decoration
  formatter <- create_formatter(style)[["fmt"]]
  if (!is.null(formatter)) txt <- formatter(txt)

  ansi_string(txt)
}
