
#' @importFrom withr defer
#' @importFrom xml2 xml_add_child

cli__container_start <- function(self, private, tag, .auto_close, .envir) {
  id <- new_uuid()
  if (.auto_close && !identical(.envir, globalenv())) {
    defer(
      cli__container_end(self, private, id),
      envir = .envir,
      priority = "first"
    )
  }

  private$state$current <- xml_add_child(
    private$state$current, tag, id = id)

  matching_styles <- private$match_theme(
    glue("descendant-or-self::*[@id = '{id}']"))
  new_styles <- private$theme[
    setdiff(matching_styles, private$get_matching_styles())]
  private$state$matching_styles <-
    c(private$state$matching_styles,
      structure(list(matching_styles), names = id))

  new_style <- private$get_style()
  for (st in new_styles) new_style <- merge_styles(new_style, st)
  private$state$styles <-
    c(private$state$styles, structure(list(new_style), names = id))

  invisible(id)
}

#' @importFrom xml2 xml_find_first xml_name xml_remove xml_parent
#'   xml_attr
#' @importFrom utils head

cli__container_end <- function(self, private, id) {
  ## Do not remove the <body>
  if (xml_name(private$state$current) == "body") return(invisible(self))

  ## Defaults to last container
  id <- id %||% xml_attr(private$state$current, "id")

  ## Do we have 'id' at all?
  cnt <- xml_find_first(
    private$state$doc,
    glue("descendant-or-self::*[@id = '{id}']"))
  if (is.na(xml_name(cnt))) return(invisible(self))

  ## Remove the whole subtree of 'cnt', pointer is on its parent
  private$state$current <- xml_parent(cnt)
  xml_remove(cnt)

  ## Remove styles as well
  del_from <- match(id, names(private$state$matching_styles))
  private$state$matching_styles <-
    head(private$state$matching_styles, del_from - 1)
  private$state$styles <-
    head(private$state$styles, del_from - 1)

  invisible(self)
}

## Paragraph --------------------------------------------------------

cli_par <- function(self, private, .auto_close, .envir) {
  cli__container_start(self, private, "par", .auto_close, .envir)
}

## Lists ------------------------------------------------------------

cli_ul <- function(self, private, items, .auto_close, .envir) {
  id <- cli__container_start(self, private, "ul", .auto_close, .envir)
  if (length(items)) self$end(self$it(items))
  invisible(id)
}

cli_ol <- function(self, private, items, .auto_close, .envir) {
  id <- cli__container_start(self, private, "ol", .auto_close, .envir)
  if (length(items)) self$end(self$it(items))
  invisible(id)
}

cli_dl <- function(self, private, items, .auto_close, .envir) {
  id <- cli__container_start(self, private, "dl", .auto_close, .envir)
  if (length(items)) self$end(self$it(items))
  invisible(id)
}

#' @importFrom xml2 xml_parent xml_path xml_attr

cli_it <- function(self, private, items, .auto_close, .envir) {

  ## check the last active list container
  last <- private$state$current
  while (! xml_name(last) %in% c("ul", "ol", "dl", "body")) {
    prev <- last
    last <- xml_parent(last)
  }

  ## if not the last container, close the ones below it
  if (xml_name(last) != "body" &&
      xml_path(last) != xml_path(private$state$current)) {
    self$end(xml_attr(prev, "id"))
  }

  ## if none, then create an ul container
  if (xml_name(last) == "body") {
    cnt_id <- self$ul(.auto_close = .auto_close, .envir = .envir)
    type <- "ul"
  } else {
    cnt_id <- xml_attr(last, "id")
    type <- xml_name(last)
  }

  i <- 1
  repeat {
    id <- cli__container_start(self, private, "it", .auto_close, .envir)
    if (i > length(items)) break
    private$item_text(type, names(items)[i], items[[i]], cnt_id,
                      .envir = .envir)
    self$end(id)
    i <- i + 1
  }

  invisible(id)
}

cli__item_text <- function(self, private, type, name, text, cnt_id,
                           .envir) {

  head <- if (type == "ul") {
    "* "
  } else if (type == "ol") {
    private$state$styles[[cnt_id]]$counter <-
      (private$state$styles[[cnt_id]]$counter %||% 0) + 1L
    paste0(private$state$styles[[cnt_id]]$counter, ". ")
  } else if (type == "dl") {
    paste0(name, ": ")
  }
  text[1] <- paste0(head, text[1])
  private$xtext(text, indent = -2, .envir = .envir)
}

## Code -------------------------------------------------------------

cli_code <- function(self, private, lines, .auto_close, .envir) {
  stop("Code is not implemented yet")
}

## Close container(s) -----------------------------------------------

cli_end <- function(self, private, id) {
  cli__container_end(self, private, id)
}
