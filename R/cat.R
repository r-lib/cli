#' `cat()` helpers
#'
#' These helpers provide useful wrappers around [cat()]: most importantly
#' they all set `sep = ""`, and `cat_line()` automatically adds a newline.
#'
#' @export
#' @param ... For `cat_line()` and `cat_bullet()`, passed on to [cat()] and
#'   pasted together. For `cat_rule()` and `cat_boxx()` passed on to
#'   [rule()] and [boxx()] respectively.
#' @param x An object to print.
#' @param file Output destination. Defaults to standard output.
#' @example
#' cat_line("This is ", "a ", "line of text.")
#' cat_rule()
cat_line <- function(..., file = stdout()) {
  cat(..., "\n", sep = "", file = file)
}

# TODO(hadley): use bullet symbol when clisymbols integrated
#' @export
#' @rdname cat_line
cat_bullet <- function(..., file = stdout()) {
  cat_line("* ", ..., file = file)
}


#' @export
#' @rdname cat_line
cat_boxx <- function(..., file = stdout()) {
  cat_line(boxx(...), file = file)
}

#' @export
#' @rdname cat_line
cat_rule <- function(..., file = stdout()) {
  cat_line(rule(...), file = file)
}

#' @export
#' @rdname cat_line
cat_print <- function(x, file = stdout()) {
  if (!identical(file, "")) {
    sink(file)
    on.exit(sink(NULL))
  }

  print(x)
}
