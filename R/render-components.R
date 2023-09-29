
render <- function(cpt, style = NULL, width = console_width()) {
  switch(
    cpt[["tag"]],
    "div" = render_div(cpt, style = style, width = width),
    "text" = render_inline_text(cpt, style = style),
    "span" = render_inline_span(cpt, style = style),
    stop("Unknown component type: ", cpt[["tag"]])
  )
}

render_div <- function(cpt, style = NULL, width = console_width) {
  style <- utils::modifyList(as.list(cpt$attr$style), as.list(style))
  margin_top <- style[["margin-top"]] %||% 0L
  margin_bottom <- style[["margin-bottom"]] %||% 0L
  margin_left <- style[["margin-left"]] %||% 0L
  margin_right <- style[["margin-right"]] %||% 0L

  # TODO: padding, others?

  child_width <- width - margin_left - margin_right
  if (child_width <= 0) child_width <- 1L

  lines <- character()
  inline <- list()

  output_inline <- function() {
    if (length(inline) > 0) {
      text <- paste(inline, collapse = "")
      wtext <- ansi_strwrap(text, width = child_width)
      lines <<- c(lines, paste0(strrep("\u00a0", margin_left), wtext))
      inline <<- list()
    }
  }

  for (child in cpt$children) {
    if (is_cpt_block(child)) {
      output_inline()
      div_lines <- render(child, width = child_width)
      lines <- c(lines, paste0(strrep("\u00a0", margin_left), div_lines))
    } else {
      inline <-inline[[length(inline) + 1L]] <- render(child)
    }
  }
  output_inline()

  # TODO: collapse margins
  c(rep("", margin_top), lines, rep("", margin_bottom))
}

render_inline_span <- function(cpt, style = NULL) {
  style <- utils::modifyList(as.list(cpt$attr$style), as.list(style))
  val <- paste(unlist(lapply(cpt$children, render)), collapse = "")

  # before, after
  before <- call_if_fun(style$before)
  after <- call_if_fun(style$after)
  val <- paste0(before, val, after)

  # prefix, postfix
  prefix <- call_if_fun(style$prefix)
  postfix <- call_if_fun(style$postfix)
  val <- paste0(prefix, val, postfix)

  # padding
  padding_left <- style[["padding-left"]] %||% 0L
  padding_right <- style[["padding-right"]] %||% 0L
  if (padding_left > 0) val <- paste0(strrep("\u00a0", padding_left), val)
  if (padding_right > 0) val <- paste0(val, strrep("\u00a0", padding_right))

  # handles backgrond-color, color, fmt, font-style, font-weight,
  # text-decoration
  formatter <- create_formatter(style)[["fmt"]]
  if (!is.null(formatter)) val <- formatter(val)

  # margins, TODO: these should be collapsing, possibly with a custom ANSi seq
  margin_left <- style[["margin-left"]] %||% 0L
  margin_right <- style[["margin-right"]] %||% 0L
  if (margin_left > 0) val <- paste0(strrep("\u00a0", margin_left), val)
  if (margin_right > 0) val <- paste0(val, strrep("\u00a0", margin_right))

  ansi_string(val)
}

preview <- function(cpt, style = NULL, width = console_width()) {
  switch(
    cpt[["tag"]],
    "text" = preview_text(cpt, style = style, width = width),
    "span" = preview_span(cpt, style = style, width = width),
    preview_generic(cpt, style = style, width = width)
  )
}

preview_generic <- function(cpt, style = NULL, width = console_width()) {
  lines <- render(cpt, style = style, width = width)
  structure(
    list(lines = lines),
    class = "cli_preview"
  )
}

preview_text <- function(cpt, style = NULL, width = console_width()) {
  text <- render_inline_text(cpt, style = style)
  structure(
    list(lines = ansi_strwrap(text, width = width)),
    class = "cli_preview"
  )
}

preview_span <- function(cpt, style = NULL, width = console_width()) {
  text <- render_inline_span(cpt, style = style)
  structure(
    list(lines = ansi_strwrap(text, width = width)),
    class = "cli_preview"
  )
}

#' @export

format.cli_preview <- function(x, ...) {
  x$lines
}

#' @export

print.cli_preview <- function(x, ...) {
  writeLines(format(x, ...))
}
