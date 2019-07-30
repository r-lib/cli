
add_child <- function(x, tag, ...) {
  push(x, list(tag = tag, ...))
}

#' @importFrom glue glue

clii__container_start <- function(self, private, tag, class = NULL,
                                  id = NULL) {

  id <- id %||% new_uuid()
  if (!length(class)) class <- ""
  class <- setdiff(unique(strsplit(class, " ", fixed = TRUE)[[1]]), "")

  private$doc <- add_child(private$doc, tag, id = id, class = class)

  ## Go over all themes, and collect the selectors that match the
  ## current element
  new_sels <- list()
  for (theme in private$themes) {
    for (i in seq_len(nrow(theme))) {
      if (match_selector(theme$parsed[[i]], private$doc)) {
        new_sels <- modifyList(new_sels, theme$style[[i]])
      }
    }
  }
  new_style <- merge_embedded_styles(last(private$styles) %||% list(), new_sels)
  private$styles <- push(private$styles, new_style, name = id)

  ## Top margin, if any
  private$vspace(new_style$`margin-top` %||% 0)

  invisible(id)
}

#' @importFrom utils head
#' @importFrom stats na.omit

clii__container_end <- function(self, private, id) {
  ## Do not remove the <body>
  if (last(private$doc)$tag == "body") return(invisible(self))

  ## Defaults to last container
  if (is.null(id) || is.na(id)) {
    id <- last(private$doc)$id
  }

  ## Do we have 'id' at all?
  wh <- which(vlapply(private$doc, function(x) identical(x$id, id)))[1]
  if (is.na(wh)) return(invisible(self))

  ## Remove the whole subtree of 'cnt', pointer is on its parent
  private$doc <- head(private$doc, wh - 1L)

  ## Bottom margin
  del_from <- match(id, names(private$styles))
  bottom <- max(viapply(
    private$styles[del_from:length(private$styles)],
    function(x) as.integer(x$`margin-bottom` %||% 0L)
  ))
  private$vspace(bottom)

  ## Remove styles as well
  private$styles <- head(private$styles, del_from - 1L)

  invisible(self)
}

## div --------------------------------------------------------------

clii_div <- function(self, private, id, class, theme) {
  theme_id <- self$add_theme(theme)
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

  ## check the last active list container
  last <- length(private$doc)
  while (! private$doc[[last]]$tag %in% c("ul", "ol", "dl", "body")) {
    last <- last - 1L
  }

  ## if not the last container, close the ones below it
  if (private$doc[[last]]$tag != "body" &&
      last != length(private$doc)) {
    self$end(private$doc[[last + 1L]]$id)
  }

  ## if none, then create an ul container
  if (private$doc[[last]]$tag == "body") {
    cnt_id <- self$ul()
    type <- "ul"
  } else {
    cnt_id <- private$doc[[last]]$id
    type <- private$doc[[last]]$tag
  }

  if (length(items) > 0) {
    for (i in seq_along(items)) {
      id <- clii__container_start(self, private, "it", id = id, class = class)
      private$item_text(type, names(items)[i], cnt_id, items[[i]])
      if (i < length(items)) self$end(id)
    }
  } else {
    private$delayed_item <- list(type = type, cnt_id = cnt_id)
    id <- clii__container_start(self, private, "it", id = id, class = class)
  }

  invisible(id)
}

clii__item_text <- function(self, private, type, name, cnt_id, ..., .list) {

  style <- private$get_current_style()
  head <- if (type == "ul") {
    paste0(style$`list-style-type` %||% "*", " ")
  } else if (type == "ol") {
    res <- paste0(private$styles[[cnt_id]]$start %||% 1L, ". ")
    private$styles[[cnt_id]]$start <-
      (private$styles[[cnt_id]]$start %||% 1L) + 1L
    res
  } else if (type == "dl") {
    paste0(name, ": ")
  }
  private$xtext(.list = c(list(head), list(...), .list), indent = -2)
}

## Code -------------------------------------------------------------

clii_code <- function(self, private, lines, id, class) {
  stop("Code is not implemented yet")
}

## Close container(s) -----------------------------------------------

clii_end <- function(self, private, id) {
  clii__container_end(self, private, id)
}
