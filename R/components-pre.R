#' @export

cpt_pre <- function(
  lines,
  interpolate = FALSE,
  wrap = FALSE,
  .envir = parent.frame(),
  class = NULL,
  style = NULL,
  attr = NULL
) {
  children <- if (interpolate) {
    parse_cli_text(lines, .envir = .envir)
  } else {
    list(paste(lines, collapse = "\n"))
  }
  txt <- new_component("text", children = children)
  new_component(
    "pre",
    children = list(txt),
    class = class,
    style = style,
    attr = attr
  )
}

#' @rdname cpt_pre
#' @export
pre <- cpt_pre

#' @export

# TODO: more languages

cpt_code <- function(
  lines,
  language = "R",
  class = NULL,
  style = NULL,
  attr = NULL
) {
  if (language == "R") {
    lines <- code_highlight(lines)
  }
  cpt_pre(lines, class = class, style = style, attr = attr)
}

#' @rdname cpt_code
#' @export

code <- cpt_code