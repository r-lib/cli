
cliapp <- function(theme = getOption("cli.theme"),
                   user_theme = getOption("cli.user_theme"),
                   output = c("message", "stdout")) {

  app <- new_class(
    "cliapp",

    new = function(theme, user_theme, output)
      clii_init(app, theme, user_theme, output),

    ## Themes
    list_themes = function()
      clii_list_themes(app),
    add_theme = function(theme)
      clii_add_theme(app, theme),
    remove_theme = function(id)
      clii_remove_theme(app, id),

    ## Close container(s)
    end = function(id = NULL)
      clii_end(app, id),

    ## Generic container
    div = function(id = NULL, class = NULL, theme = NULL)
      clii_div(app, id, class, theme),

    ## Paragraphs
    par = function(id = NULL, class = NULL)
      clii_par(app, id, class),

    ## Text, wrapped
    text = function(...)
      clii_text(app, ...),

    ## Text, not wrapped
    verbatim = function(...)
      clii_verbatim(app, ...),

    ## Markdow(ish) text, wrapped: emphasis, strong emphasis, links, code
    md_text = function(...)
      clii_md_text(app, ...),

    ## Headings
    h1 = function(text, id = NULL, class = NULL)
      clii_h1(app, text, id, class),
    h2 = function(text, id = NULL, class = NULL)
      clii_h2(app, text, id, class),
    h3 = function(text, id = NULL, class = NULL)
      clii_h3(app, text, id, class),

    ## Block quote
    blockquote = function(quote, citation = NULL, id, class = NULL)
      clii_blockquote(app, quote, citation, id, class),

    ## Lists
    ul = function(items = NULL, id = NULL, class = NULL, .close = TRUE)
      clii_ul(app, items, id, class, .close),
    ol = function(items = NULL, id = NULL, class = NULL, .close = TRUE)
      clii_ol(app, items, id, class, .close),
    dl = function(items = NULL, id = NULL, class = NULL, .close = TRUE)
      clii_dl(app, items, id, class, .close),
    li = function(items = NULL, id = NULL, class = NULL)
      clii_li(app, items, id, class),

    ## Code
    code = function(lines, id = NULL, class = NULL)
      clii_code(app, lines, class),

    ## Tables
    table = function(cells, id = NULL, class = NULL)
      clii_table(app, cells, class),

    ## Alerts
    alert = function(text, id = NULL, class = NULL, wrap = FALSE)
      clii_alert(app, "alert", text, id, class, wrap),
    alert_success = function(text, id = NULL, class = NULL, wrap = FALSE)
      clii_alert(app, "alert-success", text, id, class, wrap),
    alert_danger = function(text, id = NULL, class = NULL, wrap = FALSE)
      clii_alert(app, "alert-danger", text, id, class, wrap),
    alert_warning = function(text, id = NULL, class = NULL, wrap = FALSE)
      clii_alert(app, "alert-warning", text, id, class, wrap),
    alert_info = function(text, id = NULL, class = NULL, wrap = FALSE)
      clii_alert(app, "alert-info", text, id, class, wrap),

    ## Horizontal rule
    rule = function(left, center, right)
      clii_rule(app, left, center, right),

    ## Status bar
    status = function(id = NULL, ..., .keep = FALSE)
      clii_status(app, id, ..., .keep = .keep),
    status_clear = function(id = NULL)
      clii_status_clear(app, id),
    status_update = function(id = NULL, ...)
      clii_status_update(app, id, ...),

    ## Progress bars
    progress_bar = function(id = NULL, ...)
      clii_progress_bar(app, id, ...),
    progress = function(id = NULL, operation, ...)
      clii_progress(app, id, operation, ...),

    doc = NULL,
    themes = NULL,
    styles = NULL,
    delayed_item = NULL,
    status_bar = list(),

    margin = 0,
    output = NULL,

    get_current_style = function()
      tail(app$styles, 1)[[1]],

    xtext = function(..., .list = NULL, indent = 0)
      clii__xtext(app, ..., .list = .list, indent = indent),

    vspace = function(n = 1)
      clii__vspace(app, n),

    inline = function(..., .list = NULL)
      clii__inline(app, ..., .list = .list),

    item_text = function(type, name, cnt_id, ..., .list = NULL)
      clii__item_text(app, type, name, cnt_id, ..., .list = .list),

    get_width = function()
      clii__get_width(app),
    cat = function(lines)
      clii__cat(app, lines),
    cat_ln = function(lines, indent = 0)
      clii__cat_ln(app, lines, indent),

    progress_bars = list(),
    get_progress_bar = function()
      clii__get_progress_bar(app),
    cleanup_progress_bars = function()
      clii__cleanup_progress_bars(app)
  )

  app$new(theme, user_theme, match.arg(output))

  app
}

clii_init <- function(app, theme, user_theme, output) {
  app$doc <- list()
  app$output <- output
  app$styles <- NULL

  app$add_theme(builtin_theme())
  app$add_theme(theme)
  app$add_theme(user_theme)

  clii__container_start(app, "body", id = "body")

  invisible(app)
}

## Text -------------------------------------------------------------

#' @importFrom fansi strwrap_ctl

clii_text <- function(app, ...) {
  app$xtext(...)
}

clii_verbatim <- function(app, ..., .envir) {
  style <- app$get_current_style()
  text <- paste(unlist(list(...), use.names = FALSE), collapse = "\n")
  if (!is.null(style$fmt)) text <- style$fmt(text)
  app$cat_ln(text)
  invisible(app)
}

clii_md_text <- function(app, ...) {
  stop("Markdown text is not implemented yet")
}

## Headings ----------------------------------------------------------

clii_h1 <- function(app, text, id, class) {
  clii__heading(app, "h1", text, id, class)
}

clii_h2 <- function(app, text, id, class) {
  clii__heading(app, "h2", text, id, class)
}

clii_h3 <- function(app, text, id, class) {
  clii__heading(app, "h3", text, id, class)
}

clii__heading <- function(app, type, text, id, class) {
  id <- new_uuid()
  clii__container_start(app, type, id = id, class = class)
  on.exit(clii__container_end(app, id), add = TRUE)
  text <- app$inline(text)
  style <- app$get_current_style()
  if (is.function(style$fmt)) text <- style$fmt(text)
  app$cat_ln(text)
  invisible(app)
}

## Block quote ------------------------------------------------------

clii_blockquote <- function(app, quote, citation, id, class) {
  stop("Quotes are not implemented yet")
}

## Table ------------------------------------------------------------

clii_table <- function(app, cells, id, class) {
  stop("Tables are not implemented yet")
}

## Rule -------------------------------------------------------------

clii_rule <- function(app, left, center, right) {
  text <- rule(left, center, right)
  app$cat_ln(text)
}

## Alerts -----------------------------------------------------------

clii_alert <- function(app, type, text, id, class, wrap) {
  clii__container_start(app, "div", id = id,
                       class = paste(class, "alert", type))
  on.exit(clii__container_end(app, id), add = TRUE)
  text <- app$inline(text)
  style <- app$get_current_style()
  text[1] <- paste0(style$before, text[1])
  text[length(text)] <- paste0(text[length(text)], style$after)
  if (is.function(style$fmt)) text <- style$fmt(text)
  if (wrap) text <- strwrap_ctl(text, exdent = 2)
  app$cat_ln(text)
}
