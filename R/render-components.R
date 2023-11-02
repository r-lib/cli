#' Preview the rendering of a cli component
#'
#' This function is primarily aimed at developers, to see how cli components are
#' rendered.
#'
#' @param cpt Component to preview. It can also be a mapped, themed or styled
#'   component tree. If it is an inline component, then we put it into a
#'   [cpt_div()] component to render it.
#' @param width Console width, auto-detected by default using [console_width()].
#' @param theme Theme to use. Set it to `list()` for an empty theme. If it is
#'   `NULL`, then it uses the built-in theme (see [builtin_theme()]), the
#'   `cli.theme` option, and the `cli.user_theme` option. The user theme has the
#'   highest priority, then `cli.theme`, then the built-in theme.
#' @return Lines of rendered component, with a `cli_preview` class, that has a
#'   `print()` method.
#'
#' @export

preview <- function(cpt, width = console_width(), theme = NULL) {
  if (!is_cpt_block(cpt)) {
    cpt <- cpt_div(cpt)
  }
  tree <- style_tree(cpt, theme = theme)
  lines <- render_styled(tree, width = width)

  structure(
    lines,
    class = "cli_preview"
  )
}

#' Create a styled component tree from a component or a component tree
#'
#' @param cpt Block component, or (mapped, themed or styled) component tree.
#' @param theme Theme. `NULL` for the current theme, `list()` for no theme.
#' @return Styled component tree.
#'
#' This is a helper function that makes [preview()] work with any block compoennt
#' or component tree.
#'
#' @noRd

style_tree <- function(cpt, theme = NULL) {
  mapped <- inherits(cpt, "cli_component_tree")
  themed <- mapped && isTRUE(cpt$themed)
  styled <- themed && isTRUE(cpt$styled)

  if (!mapped) {
    cpt <- map_component_tree(cpt)
  }
  if (!themed) {
    theme <- theme %||% c(
      if (Sys.getenv("CLI_NO_BUILTIN_THEME", "") != "true") builtin_theme(),
      getOption("cli.theme"),
      getOption("cli.user.theme")
    )
    cpt <- theme_component_tree(cpt, theme = theme)
  } else if (!is.null(theme)) {
    warning("`cpt` is already themed, `theme` argument is ignored")
  }
  if (!styled) {
    cpt <- style_component_tree(cpt)
  }
  cpt
}

#' Render a styled component
#'
#' Inline components are rendered inline, block components as a block.
#'
#' @param cpt Styled component tree.
#' @param width Width for rendering.
#' @return Lines of rendered component.
#'
#' @noRd

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

#' @export

format.cli_preview <- function(x, ...) {
  unclass(x)
}

#' @export

print.cli_preview <- function(x, ...) {
  writeLines(format(x, ...))
  invisible(x)
}
