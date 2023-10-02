render <- function(cpt, width = console_width()) {
  switch(cpt[["tag"]],
    "text" = render_inline_text(cpt),
    "span" = render_inline_span(cpt),
    "h1" = ,
    "h2 " = ,
    "h3" = ,
    "div" = render_div(cpt, width = width),
    stop("Unknown component type: ", cpt[["tag"]])
  )
}

preview <- function(cpt, width = console_width()) {
  switch(cpt[["tag"]],
    "text" = preview_text(cpt, width = width),
    "span" = preview_span(cpt, width = width),
    preview_generic(cpt, width = width)
  )
}

preview_generic <- function(cpt, width = console_width()) {
  lines <- render(cpt, width = width)
  structure(
    list(lines = lines),
    class = "cli_preview"
  )
}

preview_text <- function(cpt, width = console_width()) {
  text <- render_inline_text(cpt)
  structure(
    list(lines = ansi_strwrap(text, width = width)),
    class = "cli_preview"
  )
}

preview_span <- function(cpt, width = console_width()) {
  text <- render_inline_span(cpt)
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
  invisible(x)
}
