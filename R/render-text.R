render_inline_text <- function(cpt) {
  paste(
    unlist(lapply(cpt$data$pieces, render_inline_text_piece)),
    collapse = ""
  )
}

render_inline_text_piece <- function(x) {
  switch(get_text_piece_type(x),
    "plain" = render_inline_text_piece_plain(x),
    "substitution" = render_inline_text_piece_substitution(x),
    "span" = render_inline_text_piece_span(x)
  )
}

render_inline_text_piece_span <- function(span) {
  render_inline_span(span)
}
