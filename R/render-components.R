render <- function(cpt, width = console_width(), theme = NULL) {
  mapped <- inherits(cpt, "cli_component_tree")
  themed <- mapped && isTRUE(cpt$themed)
  styled <- themed && isTRUE(cpt$styled)

  if (!mapped) {
    cpt <- map_component_tree(cpt)
  }
  if (!themed) {
    theme <- theme %||% c(
      if (Sys.getenv("CLI_NO_BUILTIN_THEME", "") != "true") builtin_theme(),
      theme,
      getOption("cli.user.theme")
    )
    cpt <- theme_component_tree(cpt, theme = theme)
  } else if (!is.null(theme)) {
    warning("`cpt` is already themed, `theme` argument is ignored")
  }
  if (!styled) {
    cpt <- style_component_tree(cpt)
  }

  render_styled(cpt, width = width)
}

render_styled <- function(cpt, width = console_width()) {
  switch(cpt[["tag"]],
    "text" = render_inline_text(cpt),
    "span" = render_inline_span(cpt),
    "h1" = ,
    "h2 " = ,
    "h3" = ,
    "div" = render_div(cpt, width = width),
    "ul" = render_ul(cpt, width = width),
    "li" = render_li(cpt, width = width),
    stop("Unknown component type: ", cpt[["tag"]])
  )
}

preview <- function(cpt, width = console_width(), theme = NULL) {
  switch(cpt[["tag"]],
    "text" = preview_text(cpt, width = width, theme = theme),
    "span" = preview_span(cpt, width = width, theme = theme),
    preview_generic(cpt, width = width, theme = theme)
  )
}

preview_generic <- function(cpt, width = console_width(), theme = NULL) {
  lines <- render(cpt, width = width, theme = theme)
  structure(
    list(lines = lines),
    class = "cli_preview"
  )
}

preview_text <- function(cpt, width = console_width(), theme = NULL) {
  text <- render_inline_text(cpt)
  # TODO: theme
  structure(
    list(lines = ansi_strwrap(text, width = width)),
    class = "cli_preview"
  )
}

preview_span <- function(cpt, width = console_width(), theme = NULL) {
  text <- render_inline_span(cpt)
  # TODO: theme
  structure(
    list(lines = ansi_strwrap(text, width = width)),
    class = "cli_preview"
  )
}

#' @export

format.cli_preview <- function(x, ...) {
  x[["lines"]]
}

#' @export

print.cli_preview <- function(x, ...) {
  writeLines(format(x, ...))
  invisible(x)
}
