
add_child <- function(x, tag, ...) {
  len <- length(x)
  x[[len + 1]] <- list(tag = tag, ...)
  x
}

#' @importFrom glue glue

clii__container_start <- function(self, private, tag, class = NULL,
                                  id = NULL) {
  ## TODO
  invisible(id)
}

#' @importFrom utils head
#' @importFrom stats na.omit

clii__container_end <- function(self, private, id) {
  ## TODO
  invisible(self)
}

## div --------------------------------------------------------------

clii_div <- function(self, private, id, class, theme) {
  # TODO theme_id <- self$add_theme(theme)
  clii__container_start(self, private, "div", class, id)
  id
}

## Paragraph --------------------------------------------------------

clii_par <- function(self, private, id, class) {
  clii__container_start(self, private, "par", class, id)
}

## Lists ------------------------------------------------------------

clii_ul <- function(self, private, items, id, class, .close) {
  id <- clii__container_start(self, private, "ul", id = id, class = class)
  if (length(items)) { self$it(items); if (.close) self$end(id) }
  invisible(id)
}

clii_ol <- function(self, private, items, id, class, .close) {
  id <- clii__container_start(self, private, "ol", id = id, class = class)
  if (length(items)) { self$it(items); if (.close) self$end(id) }
  invisible(id)
}

clii_dl <- function(self, private, items, id, class, .close) {
  id <- clii__container_start(self, private, "dl", id = id, class = class)
  if (length(items)) { self$it(items); if (.close) self$end(id) }
  invisible(id)
}

clii_it <- function(self, private, items, id, class) {
  id <- id %||% new_uuid()
  ## TODO
  invisible(id)
}

## Code -------------------------------------------------------------

clii_code <- function(self, private, lines, id, class) {
  stop("Code is not implemented yet")
}

## Close container(s) -----------------------------------------------

clii_end <- function(self, private, id) {
  clii__container_end(self, private, id)
}
