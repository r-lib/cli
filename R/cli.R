
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
      cli_par(selg, private),

    ## Text, wrapper
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
      cli_h1(self, private, text),
    h3 = function(text)
      cli_h1(self, private, text),

    ## Block quote
    quote = function(text)
      cli_quote(self, private, text),

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
      cli_alert(self, private, "success", text),
    alert_danger = function(text)
      cli_alert(self, private, "danger", text),
    alert_warning = function(text)
      cli_alert(self, private, "warning", text),
    alert_info = function(text)
      cli_alert(self, private, "info", text),

    ## Progress bars
    progress_bar = function(...)
      cli_progress_bar(self, private, ...)
  ),

  private = list(
    stream = NULL,
    theme = NULL,
    state = list()
  )
)

cli_init <- function(self, private, stream, theme) {
  private$stream <- stream
  private$theme <- theme
  invisible(self)
}
