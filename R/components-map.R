map_component_tree <- function(cpt, parent = list()) {
  stopifnot(inherits(cpt, "cli_component"))
  node <- new.env(parent = emptyenv())
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
  if (x[["tag"]] == "text") {
    c(if (root) "<cli_component_tree>",
      format(x[["component"]])
    )
  } else {
    id <- x[["id"]] %&&% paste0(" id=\"", x[["id"]], "\"")
    c(if (root) "<cli_component_tree>",
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
