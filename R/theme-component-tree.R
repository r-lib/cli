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
