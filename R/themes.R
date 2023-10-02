
theme_create <- function(theme) {
  mtheme <- theme
  mtheme[] <- lapply(mtheme, create_formatter)
  selectors <- names(theme)
  res <- data.frame(
    stringsAsFactors = FALSE,
    selector = as.character(selectors),
    parsed = I(lapply(selectors, parse_selector) %||% list()),
    style = I(mtheme %||% list()),
    cnt = rep(NA_character_, length(selectors))
  )

  rownames(res) <- NULL
  res
}

create_formatter <- function(style, bg = TRUE, fmt = TRUE, width = NULL) {
  force(width)
  is_bold <- identical(style[["font-weight"]], "bold")
  is_italic <- identical(style[["font-style"]], "italic")
  is_underline <- identical(style[["text-decoration"]], "underline")
  is_color <- "color" %in% names(style)
  is_bg_color <- bg && "background-color" %in% names(style)

  if (!is_bold && !is_italic && !is_underline && !is_color
      && !is_bg_color) return(style)

  if (is_color && is.null(style[["color"]])) {
    style[["color"]] <- "none"
  }
  if (is_bg_color && is.null(style[["background-color"]])) {
    style[["background-color"]] <- "none"
  }

  formatter <- c(
    if (is_bold) list(style_bold),
    if (is_italic) list(style_italic),
    if (is_underline) list(style_underline),
    if (is_color) make_ansi_style(style[["color"]]),
    if (is_bg_color) make_ansi_style(style[["background-color"]], bg = TRUE)
  )

  new_formatter <- do.call(combine_ansi_styles, formatter)

  if (!fmt || is.null(style[["fmt"]])) {
    style[["fmt"]] <- new_formatter
  } else {
    orig_formatter <- style[["fmt"]]
    if (length(formals(orig_formatter)) == 1) {
      style[["fmt"]] <- function(x) orig_formatter(new_formatter(x))
    } else {
      style[["fmt"]] <- function(x) orig_formatter(new_formatter(x), style, width)
    }
  }

  style
}

merge_embedded_styles <- function(old, new) {
  # before and after is not inherited, fmt is not inherited, either
  # side margins are additive, class mappings are merged
  # rest is updated, counter is reset, prefix and postfix are merged
  old$before <- old$after <- old$fmt <- NULL
  old$transform <- NULL

  # these will be applied on the container, so we don't need them inside
  old$color <- old$`background-color` <- NULL

  top <- new$`margin-top` %||% 0L
  bottom <- new$`margin-bottom` %||% 0L
  left <- (old$`margin-left` %||% 0L) + (new$`margin-left` %||% 0L)
  right <- (old$`margin-right` %||% 0L) + (new$`margin-right` %||% 0L)

  prefix <- paste0(old$prefix, new$prefix)
  postfix <- paste0(new$postfix, old$postfix)

  map <- utils::modifyList(old$`class-map` %||% list(), new$`class-map` %||% list())

  start <- new$start %||% 1L

  mrg <- utils::modifyList(old, new)
  mrg[c("margin-top", "margin-bottom", "margin-left", "margin-right",
        "start", "class-map", "prefix", "postfix")] <-
    list(top, bottom, left, right, start, map, prefix, postfix)

  ## Formatter needs to be re-generated
  create_formatter(mrg)
}

#' Parse a CSS3-like selector
#'
#' This is the rather small subset of CSS3 that is supported:
#'
#' Selectors:
#'
#' * Type selectors, e.g. `input` selects all `<input>` elements.
#' * Class selectors, e.g. `.index` selects any element that has a class
#'   of "index".
#' * ID selector. `#toc` will match the element that has the ID `"toc"`.
#'
#' Combinators:
#'
#' * Descendant combinator, i.e. the space, that combinator selects nodes
#'   that are descendants of the first element. E.g. `div span` will match
#'   all `<span>` elements that are inside a `<div>` element.
#'
#' @param x CSS3-like selector string.
#'
#' @keywords internal

parse_selector <- function(x) {
  lapply(strsplit(x, " ", fixed = TRUE)[[1]], parse_selector_node)
}

parse_selector_node <- function(x) {

  parse_ids <- function(y) {
    r <- strsplit(y, "#", fixed = TRUE)[[1]]
    if (length(r) > 1) r[-1] <- paste0("#", r[-1])
    r
  }

  parts <- strsplit(x, ".", fixed = TRUE)[[1]]
  if (length(parts) > 1) parts[-1] <- paste0(".", parts[-1])
  parts <- unlist(lapply(parts, parse_ids))
  parts <- parts[parts != ""]

  m_cls <- grepl("^\\.", parts)
  m_ids <- grepl("^#", parts)

  list(tag = as.character(unique(parts[!m_cls & !m_ids])),
       class = str_tail(unique(parts[m_cls])),
       id = str_tail(unique(parts[m_ids])))
}

#' Match a selector node to a container
#'
#' @param node Selector node, as parsed by `parse_selector_node()`.
#' @param cnt Container node, has elements `tag`, `id`, `class`.
#'
#' The selector node matches the container, if all these hold:
#'
#' * The id of the selector is missing or unique.
#' * The tag of the selector is missing or unique.
#' * The id of the container is missing or unique.
#' * The tag of the container is unique.
#' * If the selector specifies an id, it matches the id of the container.
#' * If the selector specifies a tag, it matches the tag of the container.
#' * If the selector specifies class names, the container has all these
#'   classes.
#'
#' @keywords internal

match_selector_node <- function(node, cnt) {
  if (length(node$id) > 1 || length(cnt$id) > 1) return(FALSE)
  if (length(node$tag) > 1 || length(cnt$tag) > 1) return(FALSE)
  all(node$id %in% cnt$id) &&
    all(node$tag %in% cnt$tag) &&
    all(node$class %in% cnt$class)
}

#' Match a selector to a container stack
#'
#' @param sels A list of selector nodes.
#' @param cnts A list of container nodes.
#'
#' The last selector in the list must match the last container, so we
#' do the matching from the back. This is because we use this function
#' to calculate the style of newly encountered containers.
#'
#' @keywords internal

match_selector <- function(sels, cnts) {
  sptr <- length(sels)
  cptr <- length(cnts)

  # Last selector must match the last container
  if (sptr == 0 || sptr > cptr) return(FALSE)
  match <- match_selector_node(sels[[sptr]], cnts[[cptr]])
  if (!match) return (FALSE)

  # Plus the rest should match somehow
  sptr <- sptr - 1L
  cptr <- cptr - 1L
  while (sptr != 0L && sptr <= cptr) {
    match <- match_selector_node(sels[[sptr]], cnts[[cptr]])
    if (match) {
      sptr <- sptr - 1L
      cptr <- cptr - 1L
    } else {
      cptr <- cptr - 1L
    }
  }

  sptr == 0
}
