
#' List the currently active themes
#'
#' If there is no active app, then it calls [start_app()].
#'
#' @return A list of data frames with the active themes.
#' Each data frame row is a style that applies to selected CLI tree nodes.
#' Each data frame has columns:
#' * `selector`: The original CSS-like selector string. See [themes].
#' * `parsed`: The parsed selector, as used by cli for matching to nodes.
#' * `style`: The original style.
#' * `cnt`: The id of the container the style is currently applied to, or
#'   `NA` if the style is not used.
#'
#' @export
#' @seealso themes

cli_list_themes <- function() {
  app <- default_app() %||% start_app()
  app$list_themes()
}

clii_list_themes <- function(app) {
  app$themes
}

clii_add_theme <- function(app, theme) {
  id <- new_uuid()
  app$themes <-
    c(app$themes, structure(list(theme_create(theme)), names = id))
  id
}

clii_remove_theme <- function(app, id) {
  if (! id %in% names(app$themes)) return(invisible(FALSE))
  app$themes[[id]] <- NULL
  invisible(TRUE)
}

#' The built-in CLI theme
#'
#' This theme is always active, and it is at the bottom of the theme
#' stack. See [themes].
#'
#' @seealso [themes], [simple_theme()].
#' @return A named list, a CLI theme.
#'
#' @export

builtin_theme <- function() {
  list(
    body = list(),

    h1 = list(
      "font-weight" = "bold",
      "font-style" = "italic",
      "margin-top" = 1,
      "margin-bottom" = 1),
    h2 = list(
      "font-weight" = "bold",
      "margin-top" = 1,
      "margin-bottom" = 1),
    h3 = list(
      "text-decoration" = "underline",
      "margin-top" = 1),

    ".alert" = list(
      before = paste0(symbol$arrow_right, " ")
    ),
    ".alert-success" = list(
      before = paste0(crayon::green(symbol$tick), " ")
    ),
    ".alert-danger" = list(
      before = paste0(crayon::red(symbol$cross), " ")
    ),
    ".alert-warning" = list(
      before = paste0(crayon::yellow("!"), " ")
    ),
    ".alert-info" = list(
      before = paste0(crayon::cyan(symbol$info), " ")
    ),

    par = list("margin-top" = 1, "margin-bottom" = 1),
    ul = list("list-style-type" = symbol$bullet, "margin-left" = 0),
    "ul ul" = list("list-style-type" = symbol$circle, "margin-left" = 2),
    "ul ul ul" = list("list-style-type" = symbol$line, "margin-left" = 4),
    ol = list(),
    dl = list(),
    .code = list(),

    span.emph = list("font-style" = "italic"),
    span.strong = list("font-weight" = "bold"),
    span.code = list(before = "`", after = "`", color = "magenta"),

    span.pkg = list(color = "magenta"),
    span.fn = list(after = "()", color = "magenta"),
    span.fun = list(after = "()", color = "magenta"),
    span.arg = list(color = "magenta"),
    span.kbd = list(before = "<", after = ">", color = "magenta"),
    span.key = list(before = "<", after = ">", color = "magenta"),
    span.file = list(color = "magenta"),
    span.path = list(color = "magenta"),
    span.email = list(color = "magenta"),
    span.url = list(before = "<", after = ">", color = "blue"),
    span.var = list(color = "magenta"),
    span.envvar = list(color = "magenta")
  )
}

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

#' @importFrom crayon bold italic underline make_style combine_styles

create_formatter <- function(x) {
  is_bold <- identical(x[["font-weight"]], "bold")
  is_italic <- identical(x[["font-style"]], "italic")
  is_underline <- identical(x[["text-decoration"]], "underline")
  is_color <- "color" %in% names(x)
  is_bg_color <- "background-color" %in% names(x)

  if (!is_bold && !is_italic && !is_underline && !is_color
      && !is_bg_color) return(x)

  fmt <- c(
    if (is_bold) list(bold),
    if (is_italic) list(italic),
    if (is_underline) list(underline),
    if (is_color) make_style(x[["color"]]),
    if (is_bg_color) make_style(x[["background-color"]], bg = TRUE)
  )

  new_fmt <- do.call(combine_styles, fmt)

  if (is.null(x[["fmt"]])) {
    x[["fmt"]] <- new_fmt
  } else {
    orig_fmt <- x[["fmt"]]
    x[["fmt"]] <- function(x) orig_fmt(new_fmt(x))
  }

  x
}

#' @importFrom utils modifyList

merge_embedded_styles <- function(old, new) {
  # before and after is not inherited,
  # side margins are additive,
  # rest is updated, counter is reset
  old$before <- old$after <- NULL

  top <- new$`margin-top` %||% 0L
  bottom <- new$`margin-bottom` %||% 0L
  left <- (old$`margin-left` %||% 0L) + (new$`margin-left` %||% 0L)
  right <- (old$`margin-right` %||% 0L) + (new$`margin-right` %||% 0L)

  start <- new$start %||% 1L

  mrg <- modifyList(old, new)
  mrg[c("margin-top", "margin-bottom", "margin-left", "margin-right",
        "start")] <- list(top, bottom, left, right, start)

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
#' * ID selector. `#toc` will match the element that has the ID "toc".
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
#' * If the selector specifies a tag, it matxhes the tag of the container.
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

match_selector <- function(sels, cnts) {
  sptr <- length(sels)
  cptr <- length(cnts)
  while (sptr != 0L && sptr <= cptr) {
    if (match_selector_node(sels[[sptr]], cnts[[cptr]])) {
      sptr <- sptr - 1L
      cptr <- cptr - 1L
    } else {
      cptr <- cptr - 1L
    }
  }

  sptr == 0
}
