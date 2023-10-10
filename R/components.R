
new_component <- function(tag, ..., children = NULL, attr = NULL) {
  children <- c(list(...), children)
  if (tag == "text") {
    stopifnot(all(map_lgl(children, is_text_piece)))
  } else {
    stopifnot(all(map_lgl(children, inherits, "cli_component")))
  }
  cpt <- new.env(parent = emptyenv())
  cpt[["tag"]] <- tag
  cpt[["children"]] <- children
  cpt[["attr"]] <- attr
  class(cpt) <- c(paste0("cli_component_", tag), "cli_component")
  cpt
}

#' @export

format.cli_component <- function(x, ...) {
  styled <- inherits(x, "cli_styled_component")
  x <- as_component(x)
  id <- x[["attr"]][["id"]] %&&% paste0(" id=\"", x[["attr"]][["id"]], "\"")
  c(paste0("<", x[["tag"]], id, ">", if (styled) " (styled)"),
    paste0("  ", unlist(lapply(x[["children"]], format))),
    paste0("</", x[["tag"]], ">")
  )
}

#' @export

print.cli_component <- function(x, ...) {
  writeLines(format(x, ...))
  invisible(x)
}

is_cpt_block <- function(x) {
  ! identical(x[["tag"]], "span") && ! identical(x[["tag"]], "text")
}

is_cpt_inline <- function(x) {
  identical(x[["tag"]], "span") || identical(x[["tag"]], "text")
}

#' @export

cpt_div <- function(..., children = NULL, attr = NULL) {
  new_component("div", ..., children = children, attr = attr)
}

#' @export

cpt_span <- function(..., children = NULL, attr = NULL) {
  new_component("span", ..., children = children, attr = attr)
}  

#' @export

cpt_h1 <- function(text, attr = NULL, .envir = parent.frame()) {
  if (is.character(text)) {
    text <- cpt_text(text, .envir = .envir)
  }
  new_component("h1", text, attr = attr)
}

#' @export

cpt_h2 <- function(text, attr = NULL, .envir = parent.frame()) {
  if (is.character(text)) {
    text <- cpt_text(text, .envir = .envir)
  }
  new_component("h2", text, attr = attr)
}

#' @export

cpt_h3 <- function(text, attr = NULL, .envir = parent.frame()) {
  if (is.character(text)) {
    text <- cpt_text(text, .envir = .envir)
  }
  new_component("h3", text, attr = attr)
}
