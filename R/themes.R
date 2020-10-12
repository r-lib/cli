
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
#' @param dark Whether to use a dark theme. The `cli_theme_dark` option
#'   can be used to request a dark theme explicitly. If this is not set,
#'   or set to `"auto"`, then cli tries to detect a dark theme, this
#'   works in recent RStudio versions and in iTerm on macOS.
#' @export

builtin_theme <- function(dark = getOption("cli_theme_dark", "auto")) {

  dark <- detect_dark_theme(dark)

  list(
    body = list(
      "class-map" = list(
        fs_path = "file"
      )
    ),

    h1 = list(
      "font-weight" = "bold",
      "margin-top" = 1,
      "margin-bottom" = 0,
      fmt = function(x) cli::rule(x, line_col = "cyan")),
    h2 = list(
      "font-weight" = "bold",
      "margin-top" = 1,
      "margin-bottom" = 1,
      fmt = function(x) paste0(symbol$line, symbol$line, " ", x, " ",
                               symbol$line, symbol$line)),
    h3 = list(
      "margin-top" = 1,
      fmt = function(x) paste0(symbol$line, symbol$line, " ", x, " ")),

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

    par = list("margin-top" = 0, "margin-bottom" = 1),
    li = list("padding-left" = 2),
    ul = list("list-style-type" = symbol$bullet, "padding-left" = 0),
    "ul ul" = list("list-style-type" = symbol$circle, "padding-left" = 2),
    "ul ul ul" = list("list-style-type" = symbol$line),

    "ul ul" = list("padding-left" = 2),
    "ul dl" = list("padding-left" = 2),
    "ol ol" = list("padding-left" = 2),
    "ol ul" = list("padding-left" = 2),
    "ol dl" = list("padding-left" = 2),
    "dl ol" = list("padding-left" = 2),
    "dl ul" = list("padding-left" = 2),
    "dl dl" = list("padding-left" = 2),

    blockquote = list("padding-left" = 4L, "padding-right" = 10L,
                      "font-style" = "italic", "margin-top" = 1L,
                      "margin-bottom" = 1L, before = symbol$dquote_left,
                      after = symbol$dquote_right),
    "blockquote cite" = list(before = paste0(symbol$em_dash, " "),
                             "font-style" = "italic", "font-weight" = "bold"),

    .code = list(fmt = format_code(dark)),
    .code.R = list(fmt = format_r_code(dark)),

    span.emph = list("font-style" = "italic"),
    span.strong = list("font-weight" = "bold"),
    span.code = theme_code_tick(dark),

    span.pkg = list(color = "blue"),
    span.fn = theme_function(dark),
    span.fun = theme_function(dark),
    span.arg = theme_code_tick(dark),
    span.kbd = list(before = "[", after = "]", color = "blue"),
    span.key = list(before = "[", after = "]", color = "blue"),
    span.file = list(color = "blue"),
    span.path = list(color = "blue"),
    span.email = list(color = "blue"),
    span.url = list(before = "<", after = ">", color = "blue",
                    "font-style" = "italic"),
    span.var = theme_code_tick(dark),
    span.envvar = theme_code_tick(dark),
    span.val = list(
      transform = function(x, ...) cli_format(x, ...),
      color = "blue"
    ),
    span.field = list(color = "green")
  )
}

detect_dark_theme <- function(dark) {
  tryCatch({
    if (dark == "auto") {
      dark <- if (Sys.getenv("RSTUDIO", "0") == "1") {
        rstudioapi::getThemeInfo()$dark
      } else if (is_iterm()) {
        is_iterm_dark()
      } else {
        FALSE
      }
    }
  }, error = function(e) FALSE)

  isTRUE(dark)
}

theme_code <- function(dark) {
  if (dark) {
    list("background-color" = "#232323", color = "#d0d0d0")
  } else{
    list("background-color" = "#e8e8e8", color = "#202020")
  }
}

theme_code_tick <- function(dark) {
  modifyList(theme_code(dark), list(before = "`", after = "`"))
}

theme_function <- function(dark) {
  modifyList(theme_code(dark), list(before = "`", after = "()`"))
}

format_r_code <- function(dark) {
  function(x) {
    x <- crayon::strip_style(x)
    lines <- unlist(strsplit(x, "\n", fixed = TRUE))
    tryCatch(prettycode::highlight(lines), error = function(x) lines)
  }
}

format_code <- function(dark) {
  function(x) {
    unlist(strsplit(x, "\n", fixed = TRUE))
  }
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
  # side margins are additive, class mappings are merged
  # rest is updated, counter is reset
  old$before <- old$after <- NULL

  top <- new$`margin-top` %||% 0L
  bottom <- new$`margin-bottom` %||% 0L
  left <- (old$`margin-left` %||% 0L) + (new$`margin-left` %||% 0L)
  right <- (old$`margin-right` %||% 0L) + (new$`margin-right` %||% 0L)

  map <- modifyList(old$`class-map` %||% list(), new$`class-map` %||% list())

  start <- new$start %||% 1L

  mrg <- modifyList(old, new)
  mrg[c("margin-top", "margin-bottom", "margin-left", "margin-right",
        "start", "class-map")] <- list(top, bottom, left, right, start, map)

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
#'
#' @keywords internal

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
