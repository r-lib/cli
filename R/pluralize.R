
make_quantity <- function(object) {
  val <- if (is.numeric(object)) {
    stopifnot(length(object) == 1)
    as.integer(object)
  } else {
    length(object)
  }
}

#' @export

no <- function(expr) {
  stopifnot(is.numeric(expr), length(expr) == 1, !is.na(expr))
  structure(
    expr,
    class = "cli_no"
  )
}

#' @export

as.character.cli_no <- function(x, ...) {
  if (x == 0) "no" else as.character(unclass(x))
}

#' @export

qty <- function(expr) {
  structure(
    make_quantity(expr),
    class = "cli_noprint"
  )
}

#' @export

as.character.cli_noprint <- function(x, ...) {
  ""
}

#' @export

pluralize <- function(..., .envir = parent.frame()) {
  TODO
}
