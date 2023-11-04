#' Create a generic block component
#'
#' Generic components are useful for styling, and for collecting
#' multiple components into a single entitity.
#'
#' @param ... Subcomponents to add to the new component.
#' @param children A list of subcomponents to add to the new component,
#'   they are added after the ones in `...`.
#' @param attr Attributes.
#' @return A `div` component object.
#'
#' @export

cpt_div <- function(..., children = NULL, attr = NULL) {
  new_component("div", ..., children = children, attr = attr)
}

#' Create a generic inline component
#'
#' Generic components are useful for styling, and for collecting
#' multiple components into a single entitity.
#'
#' @param ... Subcomponents to add to the new component.
#' @param children A list of subcomponents to add to the new component,
#'   they are added after the ones in `...`.
#' @param attr Attributes.
#' @return A `span` component object.
#'
#' @export

cpt_span <- function(..., children = NULL, attr = NULL) {
  new_component("span", ..., children = children, attr = attr)
}

#' Create headers
#'
#' @param text Header text.
#' @param attr Attributes.
#' @param .envir Environment to evaluate interpolated expressions in.
#' @return Header component.
#'
#' @export

cpt_h1 <- function(text, attr = NULL, .envir = parent.frame()) {
  if (is.character(text)) {
    text <- cpt_text(text, .envir = .envir)
  }
  new_component("h1", text, attr = attr)
}

#' @rdname cpt_h1
#' @export

cpt_h2 <- function(text, attr = NULL, .envir = parent.frame()) {
  if (is.character(text)) {
    text <- cpt_text(text, .envir = .envir)
  }
  new_component("h2", text, attr = attr)
}

#' @rdname cpt_h1
#' @export

cpt_h3 <- function(text, attr = NULL, .envir = parent.frame()) {
  if (is.character(text)) {
    text <- cpt_text(text, .envir = .envir)
  }
  new_component("h3", text, attr = attr)
}

#' Unordered list component
#'
#' @export

cpt_ul <- function(items, ..., attr = NULL, .envir = parent.frame()) {
  if (inherits(items, "cli_component_li")) {
    items <- list(items)
  }
  items <- c(items, list(...))
  items <- lapply(items, function(item) {
    if (is.character(item)) {
      cpt_li(cpt_text(item, .envir = parent.frame()))
    } else {
      if (!inherits(item, "cli_component_li")) {
        stop(
          "An `ul` component must only contain `li` components, not ",
          class(item)[1]
        )
      }
      item
    }
  })
  new_component("ul", children = items, attr = attr)
}

#' @export

cpt_ol <- function(items, ..., attr = NULL, .envir = parent.frame()) {
  if (inherits(items, "cli_component_li")) {
    items <- list(items)
  }
  items <- c(items, list(...))
  items <- lapply(items, function(item) {
    if (is.character(item)) {
      cpt_li(cpt_text(item, .envir = parent.frame()))
    } else {
      if (!inherits(item, "cli_component_li")) {
        stop(
          "An `ol` component must only contain `li` components, not ",
          class(item)[1]
        )
      }
      item
    }
  })
  new_component("ol", children = items, attr = attr)
}

#' @export

cpt_li <- function(..., children = NULL, attr = NULL) {
  new_component("li", ..., children = children, attr = attr)
}

# -------------------------------------------------------------------------
# S3 methods
# -------------------------------------------------------------------------

#' @export

format.cli_component <- function(x, ...) {
  id <- x[["attr"]][["id"]] %&&% paste0(" id=\"", x[["attr"]][["id"]], "\"")
  c(paste0("<", x[["tag"]], id, ">"),
    if (length(x[["children"]])) {
      paste0("  ", unlist(lapply(x[["children"]], format)))
    },
    paste0("</", x[["tag"]], ">")
  )
}

#' @export

print.cli_component <- function(x, ...) {
  writeLines(format(x, ...))
  invisible(x)
}

# -------------------------------------------------------------------------
# Internals
# -------------------------------------------------------------------------

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

is_cpt_block <- function(x) {
  ! identical(x[["tag"]], "span") && ! identical(x[["tag"]], "text")
}

is_cpt_inline <- function(x) {
  identical(x[["tag"]], "span") || identical(x[["tag"]], "text")
}
