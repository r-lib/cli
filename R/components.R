
new_component <- function(tag, ..., children = NULL, attr = NULL,
                          data = NULL) {
  children <- c(list(...), children)
  stopifnot(all(map_lgl(children, inherits, "cli_component")))
  cpt <- new.env(parent = emptyenv())
  cpt[["tag"]] <- tag
  cpt[["data"]] <- data
  cpt[["children"]] <- children
  cpt[["attr"]] <- attr
  class(cpt) <- c(paste0("cli_component_", tag), "cli_component")
  cpt
}

#' @export

format.cli_component <- function(x, ...) {
  # TODO: syntax highlight with brackets
  if (x[["tag"]] == "text") {
    c("<text>",
      paste0("  ", format_cli_text(x$data$pieces)),
      "</text>"
    )
  } else {
    id <- x[["attr"]][["id"]] %&&% paste0(" id=\"", x[["attr"]][["id"]], "\"")
    c(paste0("<", x[["tag"]], id, ">"),
      paste0("  ", unlist(lapply(x[["children"]], format.cli_component))),
      paste0("</", x[["tag"]], ">")
    )
  }
}

format_cli_text <- function(text) {
  unlist(lapply(text, function(x) {
    if (is.character(x)) {
      paste0("txt: ", substr(x, 1, 20), if (nchar(x) > 20) "...")
    } else if (inherits(x, "cli_sub")) {
      paste0("sub: ", x$code)
    } else if (inherits(x, "cli_component")) {
      class <- x[["attr"]][["class"]]
      class <- class %&&% paste0(" class=\"", class, "\"")
      c(paste0("<", x[["tag"]], class, ">"),
        paste0("  ", unlist(lapply(x[["children"]], format.cli_component))),
        paste0("</", x[["tag"]], ">")
        )
    } else {
      stop("Internal error, invalie text piece found: ", class(text))
    }
  }))
}

#' @export

print.cli_component <- function(x, ...) {
  writeLines(format(x, ...))
}

is_cpt_block <- function(x) {
  !is.null(x[["tag"]]) && x[["tag"]] %in% c("div", "span")
}

is_cpt_inline <- function(x) {
  !is.null(x[["tag"]]) && x[["tag"]] %in% c("span", "text")
}

#' @export

cpt_div <- function(..., children = NULL, attr = NULL) {
  new_component("div", ..., children = children, attr = attr)
}

#' @export

cpt_span <- function(..., children = NULL, attr = NULL) {
  new_component("span", ..., children = children, attr = attr)
}  
