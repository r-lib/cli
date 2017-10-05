
#' Draw a tree
#'
#' Draw a tree using box drawing characters. Unicode characters are
#' used if available. (Set the `boxes.unicode` option if auto-detection
#' fails.)
#'
#' A node might appear multiple times in the tree, or might not appear
#' at all.
#'
#' @param data Data frame that contains the tree structure.
#'   The first column is an id, and the second column is a list column,
#'   that contains the ids of the child nodes. The optional third column
#'   may contain the text to print to annotate the node.
#' @param root The name of the root node.
#' @param style Optional box style list.
#' @param width Maximum width of the output. Defaults to the `width`
#'   option, see [base::options()].
#' @return Character vector, the lines of the tree drawing.
#'
#' @export
#' @examples
#' data <- data.frame(
#'   stringsAsFactors = FALSE,
#'   package = c("processx", "backports", "assertthat", "Matrix",
#'     "magrittr", "rprojroot", "clisymbols", "prettyunits", "withr",
#'     "desc", "igraph", "R6", "crayon", "debugme", "digest", "irlba",
#'     "rcmdcheck", "callr", "pkgconfig", "lattice"),
#'   dependencies = I(list(
#'     c("assertthat", "crayon", "debugme", "R6"), character(0),
#'     character(0), "lattice", character(0), "backports", character(0),
#'     c("magrittr", "assertthat"), character(0),
#'     c("assertthat", "R6", "crayon", "rprojroot"),
#'     c("irlba", "magrittr", "Matrix", "pkgconfig"), character(0),
#'     character(0), "crayon", character(0), "Matrix",
#'     c("callr", "clisymbols", "crayon", "desc", "digest", "prettyunits",
#'       "R6", "rprojroot", "withr"),
#'     c("processx", "R6"), character(0), character(0)
#'   ))
#' )
#' tree(data)
#' tree(data, root = "rcmdcheck")
#'
#' ## Colored nodes
#' data$label <- paste(data$package,
#'   crayon::blurred(paste0("(", c("2.0.0.1", "1.1.1", "0.2.0", "1.2-11",
#'     "1.5", "1.2", "1.2.0", "1.0.2", "2.0.0", "1.1.1.9000", "1.1.2",
#'     "2.2.2", "1.3.4", "1.0.2", "0.6.12", "2.2.1", "1.2.1.9002",
#'     "1.0.0.9000", "2.0.1", "0.20-35"), ")"))
#'   )
#' roots <- ! data$package %in% unlist(data$dependencies)
#' data$label[roots] <- crayon::cyan(crayon::italic(data$label[roots]))
#' tree(data)
#' tree(data, root = "rcmdcheck")

tree <- function(data, root = data[[1]][[1]], style = NULL,
                 width = getOption("width")) {
  stopifnot(ncol(data) >= 2)

  style <- style %||% box_chars()

  labels <- if (ncol(data) >= 3) data[[3]] else data[[1]]
  res <- character()

  pt <- function(root, n = integer(), mx = integer()) {

    num_root <- match(root, data[[1]])

    level <- length(n) - 1
    prefix <- vcapply(seq_along(n), function(i) {
      if (n[i] < mx[i]) {
        if (i == length(n)) {
          paste0(style$j, style$h)
        } else {
          paste0(style$v, " ")
        }
      } else if (n[i] == mx[i] && i == length(n)) {
        paste0(style$l, style$h)
      } else {
        "  "
      }
    })

    res <<- c(res, paste0(paste(prefix, collapse = ""), labels[[num_root]]))

    children <- data[[2]][[num_root]]
    for (d in seq_along(children)) {
      pt(children[[d]], c(n, d), c(mx, length(children)))
    }
  }

  if (nrow(data)) pt(root)

  res <- col_substr(res, 1, width)

  class(res) <- unique(c("tree", class(res), "character"))
  res
}

box_chars <- function() {
  if (fancy_boxes()) {
    list(
      "h" = "\u2500",                   # horizontal
      "v" = "\u2502",                   # vertical
      "l" = "\u2514",                   # leaf
      "j" = "\u251C"                    # junction
    )
  } else {
    list(
      "h" = "-",                        # horizontal
      "v" = "|",                        # vertical
      "l" = "\\",                       # leaf
      "j" = "+"                         # junction
    )
  }
}

#' @importFrom methods setOldClass

setOldClass(c("tree", "character"))

#' @export

print.tree <- function(x, ..., sep = "\n") {
  cat(x, ..., sep = sep)
  invisible(x)
}
