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

  if (is_cpt) {
    node[["style"]] <- inherit_styles(parent_style, node[["prestyle"]], node[["tag"]])
    node[["styled"]] <- TRUE
    node[["children"]] <- lapply(
      node[["children"]],
      style_component_tree_node,
      parent_style = node[["style"]]
    )

  } else {
    type <- get_text_piece_type(node)
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
