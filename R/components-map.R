map_component_tree <- function(cpt, parent = list()) {
  if (!inherits(cpt, "cli_component")) {
    # non-component text piece
    if (is_text_piece(cpt)) return(cpt)
    stop("`cpt` must be a `cli_component` in `map_component_tree()`")
  }

  node <- list()
  node[["component"]] <- cpt
  node[["tag"]] <- cpt[["tag"]]
  node[["id"]] <- cpt[["attr"]][["id"]]
  node[["class"]] <- parse_class_attr(cpt[["attr"]][["class"]])
  node[["path"]] <- c(parent, list(list(
    tag = node[["tag"]],
    class = node[["class"]],
    id = node[["id"]]
  )))

  node[["children"]] <- lapply(
    cpt[["children"]],
    map_component_tree,
    parent = node[["path"]]
  )

  class(node) <- "cli_component_tree"
  node
}

parse_class_attr <- function(x) {
  if (is.null(x)) {
    character()
  } else {
    strsplit(x, "\\s+")[[1]]
  }
}

#' @export

format.cli_component_tree <- function(x, ...) {
  format_cli_component_tree(x, root = TRUE, ...)
}

format_cli_component_tree <- function(x, root = FALSE, ...) {
  themed <- if (isTRUE(x[["themed"]])) " (themed)" else ""
  if (x[["tag"]] == "text") {
    c(if (root) paste0("<cli_component_tree>", themed),
      format(x[["component"]])
    )
  } else {
    id <- x[["id"]] %&&% paste0(" id=\"", x[["id"]], "\"")
    c(if (root) paste0("<cli_component_tree>", themed),
      c(paste0("<", x[["tag"]], id, ">"),
        paste0("  ", unlist(lapply(x[["children"]], format_cli_component_tree))),
        paste0("</", x[["tag"]], ">")
       )
    )
  }
}

#' @export

print.cli_component_tree <- function(x, ...) {
  writeLines(format(x, ...))
  invisible(x)
}

theme_component_tree <- function(node, theme = list()) {
  if (!inherits(node, "cli_component_tree")) {
    # non-component text piece
    if (is_text_piece(node)) return(node)
    stop("`node` must be a `cli_component_tree` in `theme_component_tree()`")
  }
  parsed_sels <- lapply(as.character(names(theme)), parse_selector)
  node[["prestyle"]] <- node[["component"]][["attr"]][["style"]]
  for (i in seq_along(parsed_sels)) {
    if (match_selector(parsed_sels[[i]], node[["path"]])) {
      node[["prestyle"]] <- apply_theme_to_style(node[["prestyle"]], theme[[i]])
    }
  }
  node[["themed"]] <- TRUE


  node[["children"]] <- lapply(
    node[["children"]],
    theme_component_tree,
    theme = theme
  )

  node
}

apply_theme_to_style <- function(style, theme) {
  style <- as.list(style)
  theme <- as.list(theme)

  cm <- utils::modifyList(
    theme$`class-map` %||% list(),
    style$`class-map` %||% list()
  )

  merged <- modifyList(theme, style)
  if (length(cm)) merged[["class-map"]] <- cm
  merged
}

style_component_tree <- function(node) {
  style_component_tree_node(node, parent_style = list())
}

style_component_tree_node <- function(node, parent_style) {
  is_cpt <- inherits(node, "cli_component_tree")
  is_tp <- is_text_piece(node)

  if (!is_cpt && !is_tp) {
    stop("`node` must be a `cli_component_tree` in `style_component_tree()`")
  }
  if (is_cpt && !isTRUE(node[["themed"]])) {
    stop("`node` is not themed yet, call `theme_component_tree()` first")
  }

  if (ic_cpt) {
    node[["style"]] <- inherit_styles(parent_style, node[["prestyle"]], node[["tag"]])
    node[["styled"]] <- TRUE
    node[["children"]] <- lapply(
      node[["children"]],
      style_component_tree_node,
      parent_style = node[["style"]]
    )

  } else {
    type <- text_piece_type(node)
    if (type == "plain") {
      attr(node, "style") <- inherit_styles(parent_style, list(), "text-plain")
    } else { # substitution
      node[["style"]] <- inherit_styles(parent_style, list(), "text-sub")
    }
  }

  node
}

inherit_styles <- function(parent, child, tag) {
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

inherited_styles <- function() {
  c("class-map", "collapse", "digits", "line-type",
    "list-style-type", "start", "string-quote",
    "text-exdent", "transform", "vec-last", "vec-sep",
    "vec-sep2", "vec-trunc", "vec-trunc-style")
}
