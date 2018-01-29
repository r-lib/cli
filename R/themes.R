
cli_default_theme <- function() {
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

    ".alert-success" = list(
      before = paste0(symbol$tick, " "),
      color = "green"
    ),
    ".alert-danger" = list(
      before = paste0(symbol$cross, " "),
      color = "red"
    ),
    ".alert-warning" = list(
      before = paste0(symbol$warning, " "),
      color = "yellow"
    ),
    ".alert-info" = list(
      before = paste0(symbol$info, " "),
      color = "cyan"),

    par = list("margin-bottom" = 1),
    ul = list("list-style-type" = symbol$bullet),
    "ul ul" = list("list-style-type" = symbol$circle),
    "ul ul ul" = list("list-style-type" = symbol$line),
    ol = list(),
    dl = list(),
    it = list("margin-left" = 2),
    .code = list(),

    emph = list("font-style" = "italic"),
    strong = list("font-weight" = "bold"),
    code = list(before = "`", after = "`", color = "magenta"),

    .pkg = list(color = "magenta"),
    .fun = list(color = "magenta", after = "()"),
    .arg = list(color = "magenta"),
    .key = list(before = "<", after = ">", color = "magenta"),
    .file = list(color = "magenta"),
    .path = list(color = "magenta"),
    .email = list(color = "magenta"),
    .url = list(before = "<", after = ">", color = "blue"),
    .var = list(color = "magenta"),
    .envvar = list(color = "magenta")
  )
}

#' @importFrom selectr css_to_xpath

theme_create <- function(theme) {
  names(theme) <- css_to_xpath(names(theme))
  theme[] <- lapply(theme, create_formatter)
  theme
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

#' @importFrom xml2 xml_path xml_find_all

cli__match_theme <- function(self, private, element_path) {
  el <- xml_find_first(private$state$doc, element_path)
  paths <- lapply(
    names(private$theme),
    function(xp) {
      vcapply(xml_find_all(private$state$doc, xp), xml_path)
    }
  )
  which(vlapply(paths, `%in%`, x = xml_path(el)))
}

#' @importFrom utils modifyList

merge_styles <- function(old, new) {
  ## margins are additive, rest is updated, counter is reset
  top <- (old$`margin-top` %||% 0L) + (new$`margin-top` %||% 0L)
  bottom <- (old$`margin-bottom` %||% 0L) + (new$`margin-bottom` %||% 0L)
  left <- (old$`margin-left` %||% 0L) + (new$`margin-left` %||% 0L)
  right <- (old$`margin-right` %||% 0L) + (new$`margin-right` %||% 0L)
  start <- new$start %||% 1L

  mrg <- modifyList(old, new)
  mrg[c("margin-top", "margin-bottom", "margin-left", "margin-right",
        "start")] <- list(top, bottom, left, right, start)
  mrg
}
