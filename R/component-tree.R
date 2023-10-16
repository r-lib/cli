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
