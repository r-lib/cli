#' Component trees
#'
#' Component trees are used to calculate the final appearance of a
#' component and its subcomponents.
#'
#' Rendering a component has the following steps:
#'
#' 1. Mapping with [map_component_tree()]. It calculates the paths of the
#'    component and its subcomponents. The paths are needed for theming.
#' 2. Theming with [theme_component_tree()]. Styles from a theme are added
#'    to the nodes of the component tree, according to the theme selectors.
#' 3. Styling with [style_component_tree()]. Styles are inherited
#'    according to the style inheritance rules.
#'
#' @family component trees
#' @keywords internal
#' @name component-trees
#' @aliases component-tree component_tree component_trees
NULL

#' Map a component tree
#'
#' We need to walk the subcomponents of the input component, and during the
#' walk we assign a `path` element to every node of the component tree.
#'
#' @param cpt Component.
#' @param parent Parent components, if any. A list where each element
#'   represents a parent node. Each element is a named list of elements:
#'   - `tag`: componnent tag,
#'   - `id`: component id, from the `id` attribute,
#'   - `class`: compoennt class or classes, from the `class` attribute.
#' @return A mapped component tree, a `cli_component_tree` object.
#'
#' @family component trees
#' @keywords internal

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
  if (length(x) == 0) {
    character()
  } else {
    cl <- strsplit(x, "\\s+")[[1]]
    cl[cl != ""]
  }
}

#' @export

format.cli_component_tree <- function(x, ...) {
  format_cli_component_tree(x, root = TRUE, ...)
}

format_cli_component_tree <- function(x, root = FALSE, ...) {
  note <- if (isTRUE(x[["styled"]])) {
     " (styled)"
  } else if (isTRUE(x[["themed"]])) {
    " (themed)"
  } else {
    ""
  }
  if (x[["tag"]] == "text") {
    c(if (root) paste0("<cli_component_tree>", note),
      format(x[["component"]])
    )
  } else {
    id <- x[["id"]] %&&% paste0(" id=\"", x[["id"]], "\"")
    c(if (root) paste0("<cli_component_tree>", note),
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
