
`%||%` <- function(l, r) if (is.null(l)) r else l

make_space <- function(len) {
  strrep(" ", len)
}

strrep <- function(x, ...) {
  res <- base::strrep(x, ...)
  Encoding(res) <- Encoding(x)
  res
}

fancy_boxes <- function() {
  getOption("cli.unicode") %||% l10n_info()$`UTF-8`
}

vcapply <- function(X, FUN, ..., USE.NAMES = TRUE) {
  vapply(X, FUN, FUN.VALUE = character(1), ..., USE.NAMES = USE.NAMES)
}


apply_style <- function(text, style, bg = FALSE) {
  if (is.function(style)) {
    style(text)
  } else if (is.character(style)) {
    crayon::make_style(style, bg = bg)(text)
  } else if (is.null(style)) {
    text
  } else {
    stop("Not a colour name or crayon style", call. = FALSE)
  }
}
