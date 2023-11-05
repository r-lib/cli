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

#' @rdname cpt_div
#' @export
div <- cpt_div

# -------------------------------------------------------------------------

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

#' @rdname cpt_span
#' @export
span <- cpt_span

# -------------------------------------------------------------------------

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
    text <- cpt_txt(text, .envir = .envir)
  }
  new_component("h1", text, attr = attr)
}

#' @rdname cpt_h1
#' @export
h1 <- cpt_h1

#' @rdname cpt_h1
#' @export

cpt_h2 <- function(text, attr = NULL, .envir = parent.frame()) {
  if (is.character(text)) {
    text <- cpt_txt(text, .envir = .envir)
  }
  new_component("h2", text, attr = attr)
}

#' @rdname cpt_h1
#' @export
h2 <- cpt_h2

#' @rdname cpt_h1
#' @export

cpt_h3 <- function(text, attr = NULL, .envir = parent.frame()) {
  if (is.character(text)) {
    text <- cpt_txt(text, .envir = .envir)
  }
  new_component("h3", text, attr = attr)
}

#' @rdname cpt_h1
#' @export
h3 <- cpt_h3

# -------------------------------------------------------------------------

#' Unordered list component
#'
#' It creates a bulleted list by default.
#' This can be customized with the `list-style-type` style.
#'
#' @param items,... List items, a list or a a character vector. Elements
#'   must be strings or [list item components][cpt_li]. Character strings
#'   can have interpreted `{}` literals.
#' @param attr Attributes.
#' @param .envir Environment to evaluate the interpreted `{}` literals in
#'   items in.
#' @return An unordered list component, with class `cli_component_ul`.
#'
#' @export

cpt_ul <- function(items, ..., attr = NULL, .envir = parent.frame()) {
  if (inherits(items, "cli_component_li")) {
    items <- list(items)
  }
  items <- c(items, list(...))
  items <- lapply(items, function(item) {
    if (is.character(item)) {
      cpt_li(cpt_txt(item, .envir = parent.frame()))
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

#' @rdname cpt_ul
#' @export
ul <- cpt_ul

#' Ordered list component
#'
#' List items are numbered using decimals by default.
#' This can be customized with the `list-style-type` style.
#'
#' @param items,... List items, a list or a a character vector. Elements
#'   must be strings or [list item components][cpt_li]. Character strings
#'   can have interpreted `{}` literals.
#' @param attr Attributes.
#' @param .envir Environment to evaluate the interpreted `{}` literals in
#'   items in.
#' @return An unordered list component, with class `cli_component_ul`.
#'
#' @export

cpt_ol <- function(items, ..., attr = NULL, .envir = parent.frame()) {
  if (inherits(items, "cli_component_li")) {
    items <- list(items)
  }
  items <- c(items, list(...))
  items <- lapply(items, function(item) {
    if (is.character(item)) {
      cpt_li(cpt_txt(item, .envir = parent.frame()))
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

#' @rdname cpt_ol
#' @export
ol <- cpt_ol

#' Lite item component
#'
#' Creates a list item component.
#' It can be used in [unordered][cpt_ul] or [ordered][cpt_ol] lists.
#'
#' @param ... Child components.
#' @param children More child components, in a list.
#' @param attr Attributes.
#' @return A list item component, with class `cli_component_li`.
#'
#' @export

cpt_li <- function(..., children = NULL, attr = NULL) {
  new_component("li", ..., children = children, attr = attr)
}

#' @rdname cpt_li
#' @export
li <- cpt_li

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
