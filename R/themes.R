
#' @importFrom crayon combine_styles underline bold italic
#'   green red yellow cyan magenta blue

cli_default_theme <- function() {
  list(
    body = list(),

    h1 = list(
      fmt = combine_styles(bold, italic),
      top = 1,
      bottom = 1),
    h2 = list(
      fmt = bold,
      top = 1,
      bottom = 1),
    h3 = list(
      fmt = underline,
      top = 1,
      bottom = 0),

    ".alert-success" = list(
      marker = symbol$tick,
      fmt = green
    ),
    ".alert-danger" = list(
      marker = symbol$cross,
      fmt = red
    ),
    ".alert-warning" = list(
      marker = symbol$warning,
      fmt = yellow
    ),
    ".alert-info" = list(
      marker = symbol$info,
      fmt = cyan),

    par = list(bottom = 1),
    ul = list(left = 0),
    ol = list(left = 0),
    dl = list(left = 0),
    it = list(left = 2),
    .code = list(),

    emph = list(fmt = italic),
    strong = list(fmt = bold),
    code = list(before = "`", after = "`", fmt = magenta),

    .pkg = list(fmt = magenta),
    .fun = list(fmt = magenta, after = "()"),
    .arg = list(fmt = magenta),
    .key = list(before = "<", after = ">", fmt = magenta),
    .file = list(fmt = magenta),
    .email = list(fmt = magenta),
    .url = list(before = "<", after = ">", fmt = blue),
    .var = list(fmt = magenta),
    .envvar = list(fmt = magenta)
  )
}

#' @importFrom selectr css_to_xpath

theme_create <- function(theme) {
  names(theme) <- css_to_xpath(names(theme))
  theme
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
  top <- (old$top %||% 0L) + (new$top %||% 0L)
  bottom <- (old$bottom %||% 0L) + (new$bottom %||% 0L)
  left <- (old$left %||% 0L) + (new$left %||% 0L)
  right <- (old$right %||% 0L) + (new$right %||% 0L)
  counter <- new$counter %||% 0L

  mrg <- modifyList(old, new)
  mrg[c("top", "bottom", "left", "right", "counter")] <-
    list(top, bottom, left, right, counter)
  mrg
}
