
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
    initialize = function(stream = stdout(), theme = cli_default_theme())
      cli_init(self, private, stream, theme),

    ## Themes
    get_theme = function()
      cli_get_theme(self, private),
    set_theme = function(theme)
      cli_set_theme(self, private, theme),

    ## Close container(s)
    end = function(id = NULL)
      cli_end(self, private, id),

    ## Paragraphs
    par = function(.auto_close = TRUE, .envir = parent.frame())
      cli_par(self, private, .auto_close = .auto_close, .envir = .envir),

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
    h1 = function(text, .envir = parent.frame())
      cli_h1(self, private, text, .envir = .envir),
    h2 = function(text, .envir = parent.frame())
      cli_h2(self, private, text, .envir = .envir),
    h3 = function(text, .envir = parent.frame())
      cli_h3(self, private, text, .envir = .envir),

    ## Block quote
    quote = function(quote, citation = NULL)
      cli_quote(self, private, quote, citation),

    ## Lists
    itemize = function(items = NULL, .auto_close = TRUE,
                       .envir = parent.frame())
      cli_itemize(self, private, items, .auto_close = .auto_close,
                  .envir = .envir),
    enumerate = function(items = NULL, .auto_close = TRUE,
                         .envir = parent.frame())
      cli_enumerate(self, private, items, .auto_close = .auto_close,
                    .envir = .envir),
    describe = function(items = NULL, .auto_close = TRUE,
                        .envir = parent.frame())
      cli_describe(self, private, items, .auto_close = .auto_close,
                   .envir = .envir),
    item = function(items, .auto_close = TRUE, .envir = parent.frame())
      cli_item(self, private, items, .auto_close = .auto_close,
               .envir = .envir),

    ## Code
    code = function(lines, .auto_close = TRUE, .envir = parent.frame())
      cli_code(self, private, lines, .auto_close = .auto_close,
               .envir = .envir),

    ## Tables
    table = function(cells)
      cli_table(self, private, cells),

    ## Alerts
    alert_success = function(text, .envir = parent.frame())
      cli_alert(self, private, "alert_success", text, .envir = .envir),
    alert_danger = function(text, .envir = parent.frame())
      cli_alert(self, private, "alert_danger", text, .envir = .envir),
    alert_warning = function(text, .envir = parent.frame())
      cli_alert(self, private, "alert_warning", text, .envir = .envir),
    alert_info = function(text, .envir = parent.frame())
      cli_alert(self, private, "alert_info", text, .envir = .envir),

    ## Progress bars
    progress_bar = function(...)
      cli_progress_bar(self, private, ...)
  ),

  private = list(
    stream = NULL,
    theme = NULL,
    margin = 0,
    state = list("base" = list(
      type = "base",
      style = list(left = 0, right = 0, fmt = identity)
    )),

    xtext = function(..., .envir, indent)
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
      cli__cat_ln(self, private, lines, indent)
  )
)

cli_init <- function(self, private, stream, theme) {
  private$stream <- stream
  private$theme <- theme
  invisible(self)
}

## Themes -----------------------------------------------------------

cli_get_theme <- function(self, private) {
  stop("Themes are not implemented yet")
}

cli_set_theme <- function(self, private, theme) {
  stop("Themes are not implemented yet")
}

## Text -------------------------------------------------------------

#' @importFrom ansistrings ansi_strwrap

cli_text <- function(self, private, ..., .envir) {
  private$xtext(..., .envir = .envir)
}

cli_verbatim <- function(self, private, ..., .envir) {
  text <- private$inline(..., .envir = .envir)
  private$cat_ln(text)
  invisible(self)
}

cli_md_text <- function(self, private, ..., .envir) {
  stop("Markdown text is not implemented yet")
}

## Headers ----------------------------------------------------------

cli_h1 <- function(self, private, text, .envir) {
  cli__header(self, private, "h1", text, .envir)
}

cli_h2 <- function(self, private, text, .envir) {
  cli__header(self, private, "h2", text, .envir)
}

cli_h3 <- function(self, private, text, .envir) {
  cli__header(self, private, "h3", text, .envir)
}

cli__header <- function(self, private, type, text, .envir) {
  text <- private$inline(text, .envir = .envir)
  style <- private$theme[[type]]
  private$cat(strrep("\n", style$margin$top %||% 0))
  if (is.function(style$fmt)) text <- style$fmt(text)
  private$cat_ln(text)
  private$cat(strrep("\n", style$margin$bottom %||% 0))
  invisible(self)
}

## Block quote ------------------------------------------------------

cli_quote <- function(self, private, quote, citation) {
  stop("Quotes are not implemented yet")
}

## Table ------------------------------------------------------------

cli_table <- function(self, private, cells) {
  stop("Tables are not implemented yet")
}

## Alerts -----------------------------------------------------------

cli_alert <- function(self, private, type, text, .envir) {
  text <- private$inline(text, .envir = .envir)
  style <- private$theme[[type]]
  text[1] <- paste0(style$marker, " ", text[1])
  if (is.function(style$fmt)) text <- style$fmt(text)
  private$cat_ln(text)
  invisible(self)
}

## Progress bar -----------------------------------------------------

cli_progress_bar <- function(self, private, ...) {
  stop("Progress bars are not implemented yet")
}
