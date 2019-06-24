
clii_list_themes <- function(self, private) {
  stop("not implemented")
  private$raw_themes
}

clii_add_theme <- function(self, private, theme) {
  stop("not implemented")
  id <- new_uuid()
  private$raw_themes <-
    c(private$raw_themes, structure(list(theme), names = id))
  private$theme <- theme_create(private$raw_themes)
  id
}

clii_remove_theme <- function(self, private, id) {
  stop("not implemented")
  if (! id %in% names(private$raw_themes)) return(invisible(FALSE))
  private$raw_themes[[id]] <- NULL
  private$theme <- theme_create(private$raw_themes)
  invisible(TRUE)
}

#' The built-in CLI theme
#'
#' This theme is always active, and it is at the bottom of the theme
#' stack. See [themes].
#'
#' @seealso [themes], [simple_theme()].
#' @return A named list, a CLI theme.
#'
#' @export

builtin_theme <- function() {
  list(
    body = list(),

    h1 = list(
      "font-weight" = "bold",
      "font-style" = "italic",
      "margin-top" = 1,
      "margin-bottom" = 1),
    h2 = list(
      "font-weight" = "bold",
      "margin-top" = 1,
      "margin-bottom" = 1),
    h3 = list(
      "text-decoration" = "underline",
      "margin-top" = 1),

    ".alert::before" = list(
      content = paste0(symbol$arrow_right, " ")
    ),
    ".alert-success::before" = list(
      content = paste0(crayon::green(symbol$tick), " ")
    ),
    ".alert-danger::before" = list(
      content = paste0(crayon::red(symbol$cross), " ")
    ),
    ".alert-warning::before" = list(
      content = paste0(crayon::yellow("!"), " ")
    ),
    ".alert-info::before" = list(
      content = paste0(crayon::cyan(symbol$info), " ")
    ),

    par = list("margin-top" = 1, "margin-bottom" = 1),
    ul = list("list-style-type" = symbol$bullet),
    "ul ul" = list("list-style-type" = symbol$circle),
    "ul ul ul" = list("list-style-type" = symbol$line),
    ol = list(),
    dl = list(),
    it = list("margin-left" = 2),
    .code = list(),

    span.emph = list("font-style" = "italic"),
    span.strong = list("font-weight" = "bold"),
    span.code = list(color = "magenta"),
    "span.code::before" = list(content = "`"),
    "span.code::after" = list(content = "`"),

    span.pkg = list(color = "magenta"),
    span.fun = list(color = "magenta"),
    "span.fun::after" = list(content = "()"),
    span.arg = list(color = "magenta"),
    span.key = list(color = "magenta"),
    "span.key::before" = list(content = "<"),
    "span.key::after" = list(content = ">"),
    span.file = list(color = "magenta"),
    span.path = list(color = "magenta"),
    span.email = list(color = "magenta"),
    span.url = list(color = "blue"),
    "span.url::before" = list(content = "<"),
    "span.url::after" = list(content = ">"),
    span.var = list(color = "magenta"),
    span.envvar = list(color = "magenta")
  )
}

#' @importFrom crayon bold italic underline make_style combine_styles

create_formatter <- function(x) {
  is_bold <- identical(x[["font-weight"]], "bold")
  is_italic <- identical(x[["font-style"]], "italic")
  is_underline <- identical(x[["text-decoration"]], "underline")
  is_color <- "color" %in% names(x)
  is_bg_color <- "background-color" %in% names(x)

  if (!is_bold && !is_italic && !is_underline && !is_color
      && !is_bg_color) return(x)

  fmt <- c(
    if (is_bold) list(bold),
    if (is_italic) list(italic),
    if (is_underline) list(underline),
    if (is_color) make_style(x[["color"]]),
    if (is_bg_color) make_style(x[["background-color"]], bg = TRUE)
  )

  new_fmt <- do.call(combine_styles, fmt)

  if (is.null(x[["fmt"]])) {
    x[["fmt"]] <- new_fmt
  } else {
    orig_fmt <- x[["fmt"]]
    x[["fmt"]] <- function(x) orig_fmt(new_fmt(x))
  }

  x
}
