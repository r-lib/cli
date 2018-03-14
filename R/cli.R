
#' @export
cli <- NULL

#' Create a command line interface
#'
#' @format
#' `cli_class` is an R6 class that represents a command line interface
#' (CLI). It has methods that represent high-level, logical CLI building
#' blocks. The main advantage of this, is that the actual formatting of
#' the output is decoupled from the structure of the output, and it is
#' defined elsewhere, in themes (see [cli-themes]).
#'
#' @description
#' `cli` is a `cli_class` object that is created automatically when the
#' package is loaded. You can use it to create a consistent command line
#' interface.
#'
#' @section Usage:
#' ```
#' cli <- cli_class$new(stream = "", theme = getOption("cli.theme"))
#'
#' cli$text(..., .envir = parent.frame())
#' cli$verbatim(..., .envir = parent.frame())
#'
#' cli$h1(text, id = NULL, class = NULL, .envir = parent.frame())
#' cli$h2(text, id = NULL, class = NULL, .envir = parent.frame())
#' cli$h3(text, id = NULL, class = NULL, .envir = parent.frame())
#'
#' cli$div(id = NULL, class = NULL, theme = NULL, .auto_close = TRUE,
#'         .envir = parent.frame())
#' cli$par(id = NULL, class = NULL, .auto_close = TRUE,
#'         .envir = parent.frame())
#' cli$end(id = NULL)
#'
#' cli$ul(items = NULL, id = NULL, class = NULL, .auto_close = TRUE,
#'        .envir = parent.frame())
#' cli$ol(items = NULL, id = NULL, class = NULL, .auto_close = TRUE,
#'        .envir = parent.frame())
#' cli$dl(items = NULL, id = NULL, class = NULL, .auto_close = TRUE,
#'        .envir = parent.frame())
#' cli$it(items = NULL, id = NULL, class = NULL, .auto_close = TRUE,
#'        .envir = parent.frame())
#'
#' cli$alert(text, id = NULL, class = NULL, wrap = FALSE,
#'        .envir = parent.frame())
#' cli$alert_success(text, id = NULL, class = NULL, wrap = FALSE,
#'        .envir = parent.frame())
#' cli$alert_danger(text, id = NULL, class = NULL, wrap = FALSE,
#'        .envir = parent.frame())
#' cli$alert_warning(text, id = NULL, class = NULL, wrap = FALSE,
#'        .envir = parent.frame())
#' cli$alert_info(text, id = NULL, class = NULL, wrap = FALSE,
#'        .envir = parent.frame())
#'
#' cli$progress_bar(...)
#'
#' cli$list_themes()
#' cli$add_theme(theme, .auto_remove = TRUE, .envir = parent.frame())
#' cli$remove_theme(id)
#' ```
#'
#' @section Arguments:
#' * `stream`: The connection to print the output to. The default is `""`,
#'   which means the standard output of the R process, unless it is
#'   redirected by [base::sink()].
#' * `theme`: A named list representing a theme. See more in at
#'   [cli-themes].
#' * `...`: For `$text()` and `$verbatim()` it is concatenated to a
#'   single piece of text.
#'
#'   For `$progress_bar()` the arguments are forwarded to create a
#'   [progress::progress_bar] object. See Section 'Progress Bars' for
#'   details.
#' * `.envir`: The environment in which [glue::glue()] substitutions are
#'   performed. For containers this is also the environment that will auto
#'   close the container if `.auto_close` is `TRUE`.
#' * `text`: Text to output.
#' * `id`: Id of the container or element. This id can be referenced in
#'   theme selectors, and also in `$end()` methods.
#'
#'   For `$end()` it is the id of the container to close. If omitted, the
#'   last open container is used.
#' * `class`: Class of the element. This can be used in theme selectors.
#' * `wrap`: Whether to wrap the text of the alert, if longer than the
#'    screen width.
#' * `.auto_close`: Whether to automatically close a container, when the
#'   caller function exits (the `.envir` environment is removed from the
#'   stack).
#' * `.auto_remove`: Whether to automatically remove the theme when the
#'   called function exits (the `.envir` environment is removed from the
#'   stack).
#' * `items`: Character vector, each element will be a list item.
#'
#' @section Details:
#'
#' `$new()` creates a new command line interface.
#'
#' `$text()` outputs text, that is automatically wrapped to the screen
#'  width.
#'
#' `$verbatim()` outputs text, as is, without wrapping it.
#'
#' `$h1()`, `$h2()` and `$h3()` create headers.
#'
#' `$div()` creates a container, with an additional theme, possibly.
#' It returns the id of the container.
#'
#' `$par()` creates a paragraph, which is a generic container.
#' It returns the id of the container.
#'
#' `$end()` closes a container, either the one with specified id, or
#' the last active one, if no id is specified.
#'
#' `$ul()` creates an un-ordered list. A list is a container, and `$ul()`
#' returns the id of the container. You can use the `$it()` method to
#' create the items of the list.
#'
#' `$ol()` creates an ordered list. A list is a container and `$ul()`
#' returns the id of the container. You can use the `$it()` method to
#' create the items of the list.
#'
#' `$dl()` creates an description list. A list is a container and `$ul()`
#' returns the id of the container. You can use the `$it()` method to
#' create the items of the list.
#'
#' `$it()` creates a list item. If there is no active list container when
#' `$it()` is called, it creates an un-ordered list (i.e. `$ul()`).
#' `$it()` creates a container for the item itself, so `$text()`, etc.
#' following an `$it()` will add more text to the last item.
#'
#' `$alert()` creates a generic alert. This can be themed with an extra
#' class. There are four predefined alert styles, which also have shortcut
#' methods: `$alert_success()`, `$alert_danger()`, `$alert_warning()` and
#' `$alert_info()`.
#'
#' `$progress_bar` creates a progressbar using [progress::progress_bar].
#' See more in the 'Progress Bars' Section.
#'
#' `$list_themes()` returns all active themes, in a list. The names of the
#' list elements are the theme ids. See more at [cli-themes].
#'
#' `$add_theme()` adds a new theme. It returns the id of the new theme.
#' See more at [cli-themes].
#'
#' `$remove_theme()` removes the theme with the specified id. See more at
#' [cli-themes].
#'
#' @section Progress Bars:
#' `cli_class` integrates with progress bars from the progress package.
#' Create you progress bar with the `cli_class$progress_bar()` method,
#' and then you can use all the other `cli_class` methods to create output.
#' The progress bar will be automatically kept at the last line of your
#' output.
#'
#' @name cli_class
#' @aliases cli
#' @importFrom R6 R6Class
#' @export

cli_class <- R6Class(
  "cli_class",
  public = list(
    initialize = function(stream = stdout(), theme = getOption("cli.theme"))
      cli_init(self, private, stream, theme),

    ## Themes
    list_themes = function()
      cli_list_themes(self, private),
    add_theme = function(theme, .auto_remove = TRUE, .envir = parent.frame())
      cli_add_theme(self, private, theme, .auto_remove, .envir),
    remove_theme = function(id)
      cli_remove_theme(self, private, id),

    ## Close container(s)
    end = function(id = NULL)
      cli_end(self, private, id),

    ## Generic container
    div = function(id = NULL, class = NULL, theme = NULL,
                   .auto_close = TRUE, .envir = parent.frame())
      cli_div(self, private, id, class, theme, .auto_close, .envir),

    ## Paragraphs
    par = function(id = NULL, class = NULL, .auto_close = TRUE,
                   .envir = parent.frame())
      cli_par(self, private, id, class, .auto_close = .auto_close,
              .envir = .envir),

    ## Text, wrapped
    text = function(..., .envir = parent.frame())
      cli_text(self, private, ..., .envir = .envir),

    ## Text, not wrapped
    verbatim = function(..., .envir = parent.frame())
      cli_verbatim(self, private, ..., .envir = .envir),

    ## Markdow(ish) text, wrapped: emphasis, strong emphasis, links, code
    md_text = function(..., .envir = parent.frame())
      cli_md_text(self, private, ..., .envir = .envir),

    ## Headers
    h1 = function(text, id = NULL, class = NULL, .envir = parent.frame())
      cli_h1(self, private, text, id, class, .envir = .envir),
    h2 = function(text, id = NULL, class = NULL, .envir = parent.frame())
      cli_h2(self, private, text, id, class, .envir = .envir),
    h3 = function(text, id = NULL, class = NULL, .envir = parent.frame())
      cli_h3(self, private, text, id, class, .envir = .envir),

    ## Block quote
    blockquote = function(quote, citation = NULL, id = NULL, class = NULL)
      cli_blockquote(self, private, quote, citation, id, class),

    ## Lists
    ul = function(items = NULL, id = NULL, class = NULL,
                  .auto_close = TRUE, .envir = parent.frame())
      cli_ul(self, private, items, id, class, .auto_close = .auto_close,
             .envir = .envir),
    ol = function(items = NULL, id = NULL, class = NULL,
                  .auto_close = TRUE, .envir = parent.frame())
      cli_ol(self, private, items, id, class, .auto_close = .auto_close,
             .envir = .envir),
    dl = function(items = NULL, id = NULL, class = NULL,
                  .auto_close = TRUE, .envir = parent.frame())
      cli_dl(self, private, items, id, class, .auto_close = .auto_close,
             .envir = .envir),
    it = function(items = NULL, id = NULL, class = NULL,
                  .auto_close = TRUE, .envir = parent.frame())
      cli_it(self, private, items, id, class, .auto_close = .auto_close,
             .envir = .envir),

    ## Code
    code = function(lines, id = NULL, class = NULL,
                    .auto_close = TRUE, .envir = parent.frame())
      cli_code(self, private, lines, class, .auto_close = .auto_close,
               .envir = .envir),

    ## Tables
    table = function(cells, id = NULL, class = NULL)
      cli_table(self, private, cells, class),

    ## Alerts
    alert = function(text, id = NULL, class = NULL, wrap = FALSE,
                     .envir = parent.frame())
      cli_alert(self, private, "alert", text, id, class, wrap,
                .envir = .envir),
    alert_success = function(text, id = NULL, class = NULL, wrap = FALSE,
                             .envir = parent.frame())
      cli_alert(self, private, "alert-success", text, id, class, wrap,
                .envir = .envir),
    alert_danger = function(text, id = NULL, class = NULL, wrap = FALSE,
                            .envir = parent.frame())
      cli_alert(self, private, "alert-danger", text, id, class, wrap,
                .envir = .envir),
    alert_warning = function(text, id = NULL, class = NULL, wrap = FALSE,
                             .envir = parent.frame())
      cli_alert(self, private, "alert-warning", text, id, class, wrap,
                .envir = .envir),
    alert_info = function(text, id = NULL, class = NULL, wrap = FALSE,
                          .envir = parent.frame())
      cli_alert(self, private, "alert-info", text, id, class, wrap,
                .envir = .envir),

    ## Progress bars
    progress_bar = function(...)
      cli_progress_bar(self, private, ...),

    reset = function()
      cli_reset(self, private)
  ),

  private = list(
    stream = NULL,
    raw_themes = NULL,
    theme = NULL,
    margin = 0,
    state = NULL,

    get_matching_styles = function()
      tail(private$state$matching_styles, 1)[[1]],
    get_style = function()
      tail(private$state$styles, 1)[[1]],

    xtext = function(..., .envir, indent = 0)
      cli__xtext(self, private, ..., .envir = .envir, indent = indent),

    vspace = function(n = 1)
      cli__vspace(self, private, n),

    inline = function(..., .envir)
      cli__inline(self, private, ..., .envir = .envir),

    item_text = function(type, name, text, cnt_id, .envir)
      cli__item_text(self, private, type, name, text, cnt_id,
                     .envir = .envir),

    get_width = function()
      cli__get_width(self, private),
    cat = function(lines, sep = "")
      cli__cat(self, private, lines, sep),
    cat_ln = function(lines, indent = 0)
      cli__cat_ln(self, private, lines, indent),

    match_theme = function(element_path)
      cli__match_theme(self, private, element_path),

    progress_bars = list(),
    get_progress_bar = function()
      cli__get_progress_bar(self, private),
    cleanup_progress_bars = function()
      cli__cleanup_progress_bars(self, private)
  )
)

#' @importFrom xml2 read_html xml_find_first

cli_init <- function(self, private, stream, theme) {
  private$stream <- stream
  private$raw_themes <- list(
    default = cli_builtin_theme(), optional = theme)
  private$theme <- theme_create(private$raw_themes)
  private$state <-
    list(doc = read_html("<html><body id=\"body\"></body></html>"))
  private$state$current <- xml_find_first(private$state$doc, "./body")

  private$state$matching_styles <-
    list(body = private$match_theme("./body"))
  root_styles <- private$theme[private$state$matching_styles[[1]], ]
  root_style <- list(main = list(), before = list(), after = list())
  for (i in seq_len(nrow(root_styles))) {
    root_style <- merge_styles(root_style, root_styles[i,])
  }
  private$state$styles <- list(body = root_style)

  private$state$xstyles <- character()

  invisible(self)
}

## Text -------------------------------------------------------------

#' @importFrom ansistrings ansi_strwrap

cli_text <- function(self, private, ..., .envir) {
  private$xtext(..., .envir = .envir)
}

cli_verbatim <- function(self, private, ..., .envir) {
  style <- private$get_style()$main
  text <- private$inline(..., .envir = .envir)
  if (!is.null(style$fmt)) text <- style$fmt(text)
  private$cat_ln(text)
  invisible(self)
}

cli_md_text <- function(self, private, ..., .envir) {
  stop("Markdown text is not implemented yet")
}

## Headers ----------------------------------------------------------

cli_h1 <- function(self, private, text, id, class, .envir) {
  cli__header(self, private, "h1", text, id, class, .envir)
}

cli_h2 <- function(self, private, text, id, class, .envir) {
  cli__header(self, private, "h2", text, id, class, .envir)
}

cli_h3 <- function(self, private, text, id, class, .envir) {
  cli__header(self, private, "h3", text, id, class, .envir)
}

cli__header <- function(self, private, type, text, id, class, .envir) {
  cli__container_start(self, private, type, id = id, class = class,
                       .auto_close = TRUE, .envir = environment())
  text <- private$inline(text, .envir = .envir)
  style <- private$get_style()$main
  if (is.function(style$fmt)) text <- style$fmt(text)
  private$cat_ln(text)
  invisible(self)
}

## Block quote ------------------------------------------------------

cli_blockquote <- function(self, private, quote, citation, id, class) {
  stop("Quotes are not implemented yet")
}

## Table ------------------------------------------------------------

cli_table <- function(self, private, cells, id, class) {
  stop("Tables are not implemented yet")
}

## Alerts -----------------------------------------------------------

cli_alert <- function(self, private, type, text, id, class, wrap, .envir) {
  cli__container_start(self, private, "div", id = id,
                       class = paste(class, "alert", type),
                       .auto_close = TRUE, .envir = environment())
  text <- private$inline(text, .envir = .envir)
  style <- private$get_style()
  text[1] <- paste0(style$before$content, text[1])
  text[length(text)] <- paste0(text[length(text)], style$after$content)
  if (is.function(style$main$fmt)) text <- style$main$fmt(text)
  if (wrap) text <- ansi_strwrap(text, exdent = 2)
  private$cat_ln(text)
  invisible(self)
}

## Other ------------------------------------------------------------

cli_reset <- function(self, private) {
  private$margin <- 0
  invisible(self)
}
