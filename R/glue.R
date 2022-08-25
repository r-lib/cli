
# Compared to glue::glue(), these are fixed:
# - .sep = ""
# - .trim = TRUE
# - .null = character()
# - .literal = TRUE
# - .comment = ""
#
# we also don't allow passing in data as arguments, and `text` is
# a single argument, no need to `paste()` etc.

glue <- function(text, .envir = parent.frame(),
                 .transformer = identity_transformer,
                 .open = "{", .close = "}", .cli = FALSE) {

  text <- paste0(text, collapse = "")

  if (length(text) < 1) {
    return(text)
  }

  if (is.na(text)) {
    return(text)
  }

  text <- trim(text)

  f <- function(expr) {
    eval_func <- as.character(.transformer(expr, .envir) %||% character())
  }

  res <- .Call(glue_, text, f, .open, .close, .cli)

  res <- drop_null(res)
  if (any(lengths(res) == 0)) {
    return(character(0))
  }

  res[] <- lapply(res, function(x) replace(x, is.na(x), "NA"))

  do.call(paste0, res)
}

identity_transformer <- function (text, envir) {
  eval(parse(text = text, keep.source = FALSE), envir)
}

drop_null <- function(x) {
  x[!vapply(x, is.null, logical(1))]
}

collapse <- function(x, sep = "", last = "", trunc = Inf,
                     ellipsis = symbol$ellipsis,
                     style = c("both-ends", "head")) {

  # does not make sense to show ... instead of an element
  if (trunc == length(x) - 1L) trunc <- trunc + 1L

  style <- match.arg(style)
  switch(
    style,
    "both-ends" = collapse_both_ends(x, sep, last, trunc, ellipsis),
    "head" = collapse_head(x, sep, last, trunc, ellipsis)
  )
}

collapse_head <- function(x, sep = "", last = "", trunc = Inf,
                          ellipsis = symbol$ellipsis) {

  trunc <- max(trunc, 1L)
  x <- as.character(x)
  if (length(x) > trunc) {
      x <- c(x[1:trunc], ellipsis)
      last <- sep
  }
  if (length(x) == 0) {
    ""
  } else if (any(is.na(x))) {
    NA_character_
  } else if (nzchar(last) && length(x) > 1) {
    res <- collapse_head(x[seq(1, length(x) - 1)], sep = sep)
    collapse_head(paste0(res, last, x[length(x)]))
  } else {
    paste0(x, collapse = sep)
  }
}

collapse_both_ends <- function(x, sep = "", last = "", trunc = Inf,
                               ellipsis = symbol$ellipsis) {

  # we always list five or less elements
  trunc <- max(trunc, 5L)
  trunc <- min(trunc, length(x))
  if (length(x) <= 5 || length(x) <= trunc) {
    return(collapse_head(x, sep, last, trunc = trunc, ellipsis))
  }

  # we have at list six elements in the vector
  # 1, 2, 3, ..., 9, and 10
  x <- as.character(c(x[1:(trunc-2)], x[length(x)-1], x[length(x)]))
  paste0(
    c(x[1:(trunc-2)], ellipsis, paste0(x[trunc-1], last, x[trunc])),
    collapse = sep
  )
}

trim <- function (x) {
  has_newline <- function(x) any(grepl("\\n", x))
  if (length(x) == 0 || !has_newline(x)) {
    return(x)
  }
  .Call(trim_, x)
}
