new_styled_component <- function(cpt, style) {
  xcpt <- new.env(parent = emptyenv())
  xcpt[["tag"]] <- cpt[["tag"]]
  xcpt[["component"]] <- cpt
  xcpt[["style"]] <- style
  class(xcpt) <- "cli_styled_component"
  xcpt
}

as_component <- function(cpt) {
  if (inherits(cpt, "cli_component")) {
    cpt
  } else if (inherits(cpt, "cli_styled_component")) {
    cpt[["component"]]
  } else {
    stop("Cannot convert ", class(cpt)[1], " to cli_component")
  }
}

as_styled_component <- function(cpt) {
  if (inherits(cpt, "cli_styled_component")) {
    cpt
  } else if (inherits(cpt, "cli_component")) {
    new_styled_component(cpt, cpt[["attr"]][["style"]])
  } else {
    stop("Cannot convert ", class(cpt)[1], " to cli_styled_component")
  }
}

get_style <- function(x) {
  x[["style"]] %||% x[["attr"]][["style"]]
}

#' @export

format.cli_styled_component <- function(x, ...) {
  format.cli_component(x, ...)
}

#' @export

print.cli_styled_component <- function(x, ...) {
  writeLines(format(x, ...))
  invisible(x)
}
