
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

  text <- glue::trim(text)

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

glue_collapse <- function(x, sep = "", last = "") {
  if (length(x) == 0) {
    character()
  } else if (any(is.na(x))) {
    NA_character_
  } else if (nzchar(last) && length(x) > 1) {
    res <- glue_collapse(x[seq(1, length(x) - 1)], sep = sep)
    glue_collapse(paste0(res, last, x[length(x)]))
  } else {
    paste0(x, collapse = sep)
  }
}
