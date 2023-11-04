#' Style a component tree: inherit styles to child nodes
#'
#' Styling a component tree is part of the
#' [rendering process][component-trees].
#'
#' We walk the component tree and inheerit styles from parent nodes to
#' their child nodes, according to the style inhertance rules.
#' This is performed by the [inherit_styles()] helper function, and each
#' style may have its own inheritance rules.
#'
#' Text pieces are special, because they cannot be themed, so they don't
#' have any style *before* this function.
#' But they can have styles *after* this function, if styles are inherited
#' from parant elements.
#'
#' @param node A themed component tree, the outout of
#'   [theme_component_tree()].
#' @return A styled component tree.
#'
#' @family component trees
#' @keywords internal

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
    # `span` elements are also included here!
    node[["style"]] <- inherit_styles(parent_style, node[["prestyle"]], node[["tag"]])
    node[["styled"]] <- TRUE
    node[["children"]] <- lapply(
      node[["children"]],
      style_component_tree_node,
      parent_style = node[["style"]]
    )

  } else {
    # text pieces are a bit special, in that they have a special tag,
    # and plain text pieces have the style information as an attribute
    type <- get_text_piece_type(node)
    if (type == "plain") {
      attr(node, "style") <- inherit_styles(parent_style, list(), "text-plain")
    } else { # substitution
      node[["style"]] <- inherit_styles(parent_style, list(), "text-sub")
    }
  }

  node
}

#' Style inhertance rules
#'
#' All style inheritance rules are implemented here.
#'
#' * All styles in `inherited_styles()` are inherited.
#' * `class-map` is inherited specially, in that the parent's map
#'   is merged with the child's map, with the child's map taking
#'   precedence.
#' * Other styles are not inherited.
#'
#' @param parent Parent styles, a named list.
#' @param child Child styles, a named list.
#' @param tag Tag name of the *child* node, a string.
#' @return Merged styles, a named list.
#'
#' @keywords internal

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
