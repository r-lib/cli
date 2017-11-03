
`%||%` <- function(l, r) if (is.null(l)) r else l

make_space <- function(len) {
  strrep(" ", len)
}

strrep <- function(x, ...) {
  res <- base::strrep(x, ...)
  Encoding(res) <- Encoding(x)
  res
}

is_utf8_output <- function() {
  opt <- getOption("cli.unicode", NULL)
  if (! is.null(opt)) {
    isTRUE(opt)
  } else {
    l10n_info()$`UTF-8` && !is_latex_output()
  }
}

is_latex_output <- function() {
  if (!("knitr" %in% loadedNamespaces())) return(FALSE)
  get("is_latex_output", asNamespace("knitr"))()
}

apply_style <- function(text, style, bg = FALSE) {
  if (identical(text, ""))
    return(text)

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

vcapply <- function(X, FUN, ..., USE.NAMES = TRUE) {
  vapply(X, FUN, FUN.VALUE = character(1), ..., USE.NAMES = USE.NAMES)
}

viapply <- function(X, FUN, ..., USE.NAMES = TRUE) {
  vapply(X, FUN, FUN.VALUE = integer(1), ..., USE.NAMES = USE.NAMES)
}

ruler <- function(width = console_width()) {
  x <- seq_len(width)
  y <- rep("-", length(x))

  y[x %% 5 == 0] <- "+"
  y[x %% 10 == 0] <- crayon::bold(as.character((x[x %% 10 == 0] %/% 10) %% 10))

  cat(y, "\n", sep = "")
  cat(x %% 10, "\n", sep = "")
}

rpad <- function(x, width = NULL) {
  if (!length(x)) return(x)
  w <- nchar(x, type = "width")
  if (is.null(width)) width <- max(w)
  paste0(x, strrep(" ", pmax(width - w, 0)))
}

lpad <- function(x, width = NULL) {
  if (!length(x)) return(x)
  w <- nchar(x, type = "width")
  if (is.null(width)) width <- max(w)
  paste0(strrep(" ", pmax(width - w, 0)), x)
}
