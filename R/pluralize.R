
make_quantity <- function(object) {
  val <- if (is.numeric(object)) {
    stopifnot(length(object) == 1)
    as.integer(object)
  } else {
    length(object)
  }
}

#' @rdname pluralize
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

#' @rdname pluralize
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

parse_plural <- function(code, values) {
  # If we have the quantity already, then process it now.
  # Otherwise we put in a marker for it, and request post-processing.
  if (!is.na(values$qty)) {
    process_plural(values$qty, code)
  } else {
    values$postprocess <- TRUE
    id <- random_id()
    values$pmarkers[[id]] <- code
    id
  }
}

process_plural <- function(qty, code) {
  parts <- strsplit(str_tail(code), "/", fixed = TRUE)[[1]]
  if (length(parts) == 1) {
    if (qty != 1) parts[1] else ""
  } else if (length(parts == 2)) {
    if (qty == 1) parts[1] else parts[2]
  } else if (length(parts == 3)) {
    if (qty == 0) {
      parts[1]
    } else if (qty == 1) {
      parts[2]
    } else {
      parts[3]
    }
  } else {
    stop("Invalid pluralization directive: `", code, "`")
  }
}

post_process_plurals <- function(str, values) {
  if (!values$postprocess) return(str)
  if (values$num_subst == 0) {
    stop("Cannot pluralize without a quantity")
  }
  if (values$num_subst != 1) {
    stop("Multiple quantities for pluralization")
  }

  for (i in seq_along(values$pmarkers)) {
    mark <- values$pmarkers[i]
    str <- sub(names(mark), process_plural(values$qty, mark[[1]]), str)
  }

  str
}
