
#' The default command line interface instant
#'
#' TODO
#'
#' @export
cli <- NULL

#' Create a command line interface
#'
#' TODO
#'
#' @importFrom R6 R6Class
#' @export

cli_class <- R6Class(
  "cli_class",
  public = list(
    initialize = function(stream = "", theme = getOption("cli.theme"))
      cli_init(self, private, stream, theme),

    ## Themes
    list_themes = function()
      cli_list_themes(self, private),
    add_theme = function(theme)
      cli_add_theme(self, private, theme),
    remove_theme = function(id)
      cli_remove_theme(self, private, id),

    ## Close container(s)
    end = function(id = NULL)
      cli_end(self, private, id),

    ## Generic container
    div = function(id = NULL, class = NULL, style = NULL,
                   .auto_close = TRUE, .envir = parent.frame())
      cli_div(self, private, id, class, style, .auto_close, .envir),

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
    alert = function(text, id = NULL, class = NULL, .envir = parent.frame())
      cli_alert(self, private, "alert", text, id, class, .envir = .envir),
    alert_success = function(text, id = NULL, class = NULL,
                             .envir = parent.frame())
      cli_alert(self, private, "alert-success", text, id, class,
                .envir = .envir),
    alert_danger = function(text, id = NULL, class = NULL,
                            .envir = parent.frame())
      cli_alert(self, private, "alert-danger", text, id, class,
                .envir = .envir),
    alert_warning = function(text, id = NULL, class = NULL,
                             .envir = parent.frame())
      cli_alert(self, private, "alert-warning", text, id, class,
                .envir = .envir),
    alert_info = function(text, id = NULL, class = NULL,
                          .envir = parent.frame())
      cli_alert(self, private, "alert-info", text, id, class,
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
    default = cli_default_theme(), optional = theme)
  private$theme <- theme_create(private$raw_themes)
  private$state <-
    list(doc = read_html("<html><body id=\"body\"></body></html>"))
  private$state$current <- xml_find_first(private$state$doc, "./body")

  private$state$matching_styles <-
    list(body = private$match_theme("./body"))
  root_styles <- private$theme[ private$state$matching_styles[[1]] ]
  root_style <- list()
  for (st in root_styles) root_style <- merge_styles(root_style, st)
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
  style <- private$get_style()
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
  style <- private$get_style()
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

cli_alert <- function(self, private, type, text, id, class, .envir) {
  cli__container_start(self, private, "div", id = id,
                       class = paste(class, "alert", type),
                       .auto_close = TRUE, .envir = environment())
  text <- private$inline(text, .envir = .envir)
  style <- private$get_style()
  text[1] <- paste0(style$before, text[1], style$after)
  if (is.function(style$fmt)) text <- style$fmt(text)
  private$cat_ln(text)
  invisible(self)
}

## Other ------------------------------------------------------------

cli_reset <- function(self, private) {
  private$margin <- 0
  invisible(self)
}
