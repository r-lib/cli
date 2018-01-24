
#' @importFrom R6 R6Class

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

    ## Paragraphs
    par = function()
      cli_par(self, private),

    ## Text, wrapped
    text = function(text)
      cli_text(self, private, text),

    ## Text, not wrapped
    verbatim = function(text)
      cli_verbatim(self, private, text),

    ## Markdow(ish) text, wrapped: emphasis, strong emphasis, links, code
    md_text = function(text)
      cli_md_text(self, private, text),

    ## Headers
    h1 = function(text)
      cli_h1(self, private, text),
    h2 = function(text)
      cli_h2(self, private, text),
    h3 = function(text)
      cli_h3(self, private, text),

    ## Block quote
    quote = function(quote, citation = NULL)
      cli_quote(self, private, quote, citation),

    ## Lists
    itemize = function(items)
      cli_quote(self, private, items),
    enumerate = function(items)
      cli_quote(self, private, items),
    describe = function(items)
      cli_describe(self, private, items),

    ## Code
    code = function(lines)
      cli_code(self, private, lines),

    ## Tables
    table = function(cells)
      cli_table(self, private, cells),

    ## Alerts
    alert_success = function(text)
      cli_alert(self, private, "alert_success", text),
    alert_danger = function(text)
      cli_alert(self, private, "alert_danger", text),
    alert_warning = function(text)
      cli_alert(self, private, "alert_warning", text),
    alert_info = function(text)
      cli_alert(self, private, "alert_info", text),

    ## Progress bars
    progress_bar = function(...)
      cli_progress_bar(self, private, ...)
  ),

  private = list(
    stream = NULL,
    theme = NULL,
    state = list(),

    cat = function(lines, sep = "")
      cli__cat(self, private, lines, sep),
    cat_ln = function(lines)
      cli__cat(self, private, lines, sep = "\n")
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

## Paragraph --------------------------------------------------------

cli_par <- function(self, private) {
  stop("Paragraphs are not implemented yet")
}

## Text -------------------------------------------------------------

cli_text <- function(self, private, text) {
  text <- strwrap(text)
  private$cat_ln(text)
  invisible(self)
}

cli_verbatim <- function(self, private, text) {
  private$cat_ln(text)
  invisible(self)
}

cli_md_text <- function(self, private, text) {
  stop("Markdown text is not implemented yet")
}

## Headers ----------------------------------------------------------

cli_h1 <- function(self, private, text) {
  cli__header(self, private, "h1", text)
}

cli_h2 <- function(self, private, text) {
  cli__header(self, private, "h2", text)
}

cli_h3 <- function(self, private, text) {
  cli__header(self, private, "h3", text)
}

cli__header <- function(self, private, type, text) {
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

## Lists ------------------------------------------------------------

cli_itemize <- function(self, private, items) {
  stop("Lists are not implemented yet")
}

cli_enumerate <- function(self, private, items) {
  stop("Lists are not implemented yet")
}

cli_describe <- function(self, private, items) {
  stop("Lists are not implemented yet")
}

## Code -------------------------------------------------------------

cli_code <- function(self, private, lines) {
  stop("Code is not implemented yet")
}

## Table ------------------------------------------------------------

cli_table <- function(self, private, cells) {
  stop("Tables are not implemented yet")
}

## Alerts -----------------------------------------------------------

cli_alert <- function(self, private, type, text) {
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
