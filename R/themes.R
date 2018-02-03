
#' Themes for command line interfaces (CLIs)
#'
#' A cli theme is a named list. The names of the list elements are
#' CSS selectors that define whith CLI elements each style element applies
#' to. See <https://www.w3schools.com/cssref/css_selectors.asp> for a
#' reference on CSS selectors. We will also show some examples below.
#'
#' Themes can come from three sources:
#' * The builtin theme of the cli package.
#' * The theme from the `cli.theme` option. (At the time when the
#'   `cli_class` object is created.)
#' * Themes added with he `add_theme()` method.
#'
#' @section Examples:
#' Color of headers, that are only active in paragraphs with an
#' 'output' class:
#' ```
#' list(
#'   "par.output h1" = list("background-color" = "red", color = "#e0e0e0"),
#'   "par.output h2" = list("background-color" = "orange", color = "#e0e0e0"),
#'   "par.output h3" = list("background-color" = "blue", color = "#e0e0e0")
#' )
#' ```
#'
#' Create a custom alert type:
#' ```
#' list(
#'   ".alert-start::before" = list(content = symbol$play),
#'   ".alert-stop::before"  = list(content = symbol$stop)
#' )
#' ```
#'
#' @name cli-themes
NULL

cli_list_themes <- function(self, private) {
  private$raw_themes
}

cli_add_theme <- function(self, private, theme) {
  id <- new_uuid()
  private$raw_themes <-
    c(private$raw_themes, structure(list(theme), names = id))
  private$theme <- theme_create(private$raw_themes)
  id
}

cli_remove_theme <- function(self, private, id) {
  if (! id %in% names(private$raw_themes)) return(invisible(FALSE))
  private$raw_themes[[id]] <- NULL
  private$theme <- theme_create(private$raw_themes)
  invisible(TRUE)
}

cli_default_theme <- function() {
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

    ".alert::before" = list(
      content = paste0(symbol$arrow_right, " ")
    ),
    ".alert-success" = list(
      color = "green"
    ),
    ".alert-success::before" = list(
      content = paste0(symbol$tick, " ")
    ),
    ".alert-danger" = list(
      color = "red"
    ),
    ".alert-danger::before" = list(
      content = paste0(symbol$cross, " ")
    ),
    ".alert-warning" = list(
      color = "yellow"
    ),
    ".alert-warning::before" = list(
      content = paste0(symbol$warning, " ")
    ),
    ".alert-info" = list(
      color = "cyan"
    ),
    ".alert-info::before" = list(
      content = paste0(symbol$info, " ")
    ),

    par = list("margin-top" = 1, "margin-bottom" = 1),
    ul = list("list-style-type" = symbol$bullet),
    "ul ul" = list("list-style-type" = symbol$circle),
    "ul ul ul" = list("list-style-type" = symbol$line),
    ol = list(),
    dl = list(),
    it = list("margin-left" = 2),
    .code = list(),

    span.emph = list("font-style" = "italic"),
    span.strong = list("font-weight" = "bold"),
    span.code = list(color = "magenta"),
    "span.code::before" = list(content = "`"),
    "span.code::after" = list(content = "`"),

    span.pkg = list(color = "magenta"),
    span.fun = list(color = "magenta"),
    "span.fun::after" = list(content = "()"),
    span.arg = list(color = "magenta"),
    span.key = list(color = "magenta"),
    "span.key::before" = list(content = "<"),
    "span.key::after" = list(content = ">"),
    span.file = list(color = "magenta"),
    span.path = list(color = "magenta"),
    span.email = list(color = "magenta"),
    span.url = list(color = "blue"),
    "span.url::before" = list(content = "<"),
    "span.url::after" = list(content = ">"),
    span.var = list(color = "magenta"),
    span.envvar = list(color = "magenta")
  )
}

#' @importFrom selectr css_to_xpath

to_xpath <- function(sel) {
  sel2 <- sub(":?:before$", "", sel)
  sel3 <- sub(":?:after$", "", sel2)
  css_to_xpath(sel3)
}

get_selector_mode <- function(sel) {
  ifelse(grepl(":?:before$", sel), "before",
         ifelse(grepl(":?:after$", sel), "after", "main"))
}

theme_create <- function(theme) {
  mtheme <- unlist(theme, recursive = FALSE, use.names = FALSE)
  mtheme[] <- lapply(mtheme, create_formatter)
  selectors <- unlist(lapply(theme, names))
  res <- data.frame(
    stringsAsFactors = FALSE,
    selector = selectors,
    xpath = to_xpath(selectors),
    mode = get_selector_mode(selectors),
    style = I(mtheme)
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

#' @importFrom xml2 xml_path xml_find_all

cli__match_theme <- function(self, private, element_path) {
  el <- xml_find_first(private$state$doc, element_path)
  paths <- lapply(
    private$theme$xpath,
    function(xp) {
      vcapply(xml_find_all(private$state$doc, xp), xml_path)
    }
  )
  which(vlapply(paths, `%in%`, x = xml_path(el)))
}

#' @importFrom utils modifyList

merge_styles <- function(old, new) {
  old[[new$mode]] <- modifyList(as.list(old[[new$mode]]), new$style[[1]])
  old
}

merge_embedded_styles <- function(oldstyle, newstyle) {
  for (wh in c("main", "before", "after")) {
    old <- oldstyle[[wh]]
    new <- newstyle[[wh]]

    ## margins are additive, rest is updated, counter is reset
    top <- (old$`margin-top` %||% 0L) + (new$`margin-top` %||% 0L)
    bottom <- (old$`margin-bottom` %||% 0L) + (new$`margin-bottom` %||% 0L)
    left <- (old$`margin-left` %||% 0L) + (new$`margin-left` %||% 0L)
    right <- (old$`margin-right` %||% 0L) + (new$`margin-right` %||% 0L)
    start <- new$start %||% 1L

    mrg <- modifyList(old, new)
    mrg[c("margin-top", "margin-bottom", "margin-left", "margin-right",
          "start")] <- list(top, bottom, left, right, start)

    oldstyle[[wh]] <- mrg
  }

  oldstyle
}
