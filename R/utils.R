
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
  getOption("boxes.unicode") %||% l10n_info()$`UTF-8`
}

vcapply <- function(X, FUN, ..., USE.NAMES = TRUE) {
  vapply(X, FUN, FUN.VALUE = character(1), ..., USE.NAMES = USE.NAMES)
}
