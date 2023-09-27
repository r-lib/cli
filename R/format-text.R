
format_text_piece_plain <- function(txt, style = NULL) {
  txt <- paste(txt, collapse = "")
  # handles backgrond-color, color, fmt, font-style, font-weight,
  # text-decoration
  formatter <- create_formatter(style)[["fmt"]]
  if (!is.null(formatter)) formatter(txt) else txt
}

format_text_piece_substitution <- function(sub, style = NULL) {

}

format_text_piece_span <- function(span, style = NULL) {

}
