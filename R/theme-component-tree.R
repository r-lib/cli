#' Theme a component tree
#'
#' Theming a component tree is part of the
#' [rendering process][component-trees].
#'
#' For each node in the tree, we find the matching selectors in the theme,
#' and add the styles of the matching selectors to the node.
#' The style of the node (that was specified when the corrsponding
#' component was created) takes precedence over the theme, see
#' [apply_theme_to_style()].
#'
#' @param node A (mapped) component tree, the output of
#'   [map_component_tree()].
#' @param theme Theme to apply to the tree. Note that this internal
#'   function does **not** use the `cli.theme` or `cli.user_theme`
#'   options of the built-in theme. It only uses the `theme` argument.
#' @return A themed component tree.
#'
#' @family component trees
#' @keywords internal

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

#' Apply a theme to a component style
#'
#' This is a helper function of [theme_component_tree()], to merge
#' component styles and a theme.
#'
#' The component style takes precedence over the theme, except
#' for the `class-map` style, which is merged elementwise, again, with
#' the component style having a higher precedence.
#'
#' @param cpt_styles Component styles, a named list.
#' @param thm_styles Theme styles, a named list.
#'
#' @keywords internal

apply_theme_to_style <- function(cpt_styles, thm_styles) {
  cpt_styles <- as.list(cpt_styles)
  thm_styles <- as.list(thm_styles)

  cm <- utils::modifyList(
    thm_styles$`class-map` %||% list(),
    cpt_styles$`class-map` %||% list()
  )

  merged <- utils::modifyList(thm_styles, cpt_styles)
  if (length(cm)) merged[["class-map"]] <- cm
  merged
}
