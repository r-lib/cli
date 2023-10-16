map_component_tree <- function(cpt, parent = list()) {
  stopifnot(inherits(cpt, "cli_component"))
  node <- list()
  node[["component"]] <- cpt
  node[["tag"]] <- cpt[["tag"]]
  node[["id"]] <- cpt[["attr"]][["id"]]
  node[["class"]] <- parse_class_attr(cpt[["attr"]][["class"]])
  node[["path"]] <- c(parent, list(
    tag = node[["tag"]],
    class = node[["class"]],
    id = node[["id"]]
  ))

  if (node[["tag"]] == "text") {
    # TODO: need to handle embedded spans
    node[["children"]] <- cpt[["children"]]
  } else {

    node[["children"]] <- lapply(
      cpt[["children"]],
      map_component_tree,
      parent = node[["path"]]
    )
  }

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

theme_component_tree <- function(x, theme = list()) {
  stopifnot(inherits(x, "cli_component_tree"))
  parsed_sels <- lapply(as.character(names(theme)), parse_selector)
  x[["style"]] <- x[["component"]][["attr"]][["style"]]
  for (i in seq_along(parsed_sels)) {
    if (match_selector(parsed_sels[[i]], x[["path"]])) {
      x[["style"]] <- apply_theme_to_style(theme[[i]], x[["style"]])
    }
  }
  x[["themed"]] <- TRUE

  if (x[["tag"]] == "text") {
    # TODO: handle embedded spans

  } else {
    x[["children"]] <- lapply(
      x[["children"]],
      theme_component_tree,
      theme = theme
    )
  }

  x
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
