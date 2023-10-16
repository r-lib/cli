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

inherit_style <- function(x, parent_style) {
  if (inherits(x, "cli_component")) {
    inherit_style_component(x, parent_style)
  } else if (is_text_piece(x)) {
    inherit_style_text_piece(x, parent_style)
  } else {
    stop("Unknown type, cannot inherit style for ", class(x)[1])
  }
}

inherit_style_component <- function(x, parent_style, child_style = NULL) {
  child_style <- child_style %||% x[["attr"]][["style"]]
  new <- merge_styles(parent_style, child_style, x[["tag"]])
  if (inherits(x, "cli_styled_component")) {
    x[["style"]] <- new
    x
  } else {
    new_styled_component(x, new)
  }
}

inherit_style_text_piece <- function(x, parent_style) {
  type <- get_text_piece_type(x)
  if (type == "plain") {
    attr(x, "style") <- merge_styles(parent_style, list(), "text-plain")
  } else if (type == "substitution") {
    x$style <- merge_styles(parent_style, list(), "text-sub")
  }
  x
}

inherited_styles <- function() {
  c("class-map", "collapse", "digits", "line-type",
    "list-style-type", "start", "string-quote",
    "text-exdent", "transform", "vec-last", "vec-sep",
    "vec-sep2", "vec-trunc", "vec-trunc-style")
}

merge_styles <- function(parent, child, tag) {
  parent <- as.list(parent)
  child <- as.list(child)

  # merged
  cm <- utils::modifyList(
    parent$`class-map` %||% list(),
    child$`class-map` %||% list()
  )
  if (length(cm) > 0) child[["class-map"]] <- cm

  # these are inherited
  inh <- setdiff(inherited_styles(), "class-map")
  for (st in inh) {
    child[[st]] <- child[[st]] %||% parent[[st]]
  }

  child
}
