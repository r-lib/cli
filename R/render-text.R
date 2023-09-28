
render_text <- function(cpt) {
  paste(
    unlist(lapply(cpt$data$pieces, render_text_piece)),
    collapse = ""
  )
}

render_text_piece <- function(x) {
  switch(
    get_text_piece_type(x),
    "plain" = render_text_piece_plain(x),
    "substitution" = render_text_piece_substitution(x),
    "span" = render_text_piece_span(x)
  )
}

render_text_piece_plain <- function(txt, style = NULL) {
  style <- utils::modifyList(as.list(attr(txt, "style")), as.list(style))
  txt <- paste(txt, collapse = "")
  # handles backgrond-color, color, fmt, font-style, font-weight,
  # text-decoration
  formatter <- create_formatter(style)[["fmt"]]
  if (!is.null(formatter)) formatter(txt) else txt
}

render_text_piece_substitution <- function(sub, style = NULL) {
  val <- sub$value
  style <- utils::modifyList(as.list(sub$style), as.list(style))

  transform <- style$transform
  if (is.function(transform)) {
    if (length(formals(transform)) == 1) {
      val <- transform(val)
    } else {
      val <- transform(val, style = style)
    }
  }

  collapse <- style$collapse
  if (is.character(collapse)) {
    val <- paste0(val, collapse = collapse[1])
  }
  if (is.function(collapse)) {
    val <- collapse(val)
  }

  before <- call_if_fun(style$before)
  after <- call_if_fun(style$after)

  val <- paste0(before, val, after)

  prefix <- call_if_fun(style$prefix)
  postfix <- call_if_fun(style$postfix)
  val <- paste0(prefix, val, postfix)

  # passing on style here is not inheritance, we just pass it to a helper
  render_text_piece_plain(
    inline_collapse(val, style = style),
    style = style
  )
}

vec_trunc_default <- 20L

inline_collapse <- function(x, style = list()) {
  sep <- style[["vec-sep"]] %||% style[["vec_sep"]] %||% ", "
  sep2 <- style[["vec-sep2"]] %||% style[["vec_sep2"]] %||% " and "
  last <- style[["vec-last"]] %||% style[["vec_last"]] %||% ", and "

  trunc <- style[["vec-trunc"]] %||% style[["vec_trunc"]] %||% vec_trunc_default
  col_style <- style[["vec-trunc-style"]] %||% "both-ends"

  ansi_collapse(
    x,
    sep = sep,
    sep2 = sep2,
    last = last,
    trunc = trunc,
    style = col_style
  )
}

render_text_piece_span <- function(span, style = NULL) {
  TODO
}
