
#' @importFrom crayon combine_styles underline bold italic
#'   green red yellow cyan magenta blue

cli_default_theme <- function() {
  list(
    h1 = list(
      fmt = combine_styles(bold, italic),
      margin = list(top = 1, bottom = 1)),
    h2 = list(
      fmt = bold,
      margin = list(top = 1, bottom = 1)),
    h3 = list(
      fmt = underline,
      margin = list(top = 1, bottom = 0)),

    text = list(),
    verbatim = list(),

    alert_success = list(
      marker = symbol$tick,
      fmt = green
    ),
    alert_danger = list(
      marker = symbol$cross,
      fmt = red
    ),
    alert_warning = list(
      marker = symbol$warning,
      fmt = yellow
    ),
    alert_info = list(
      marker = symbol$info,
      fmt = cyan),

    par = list(bottom = 1),
    itemize = list(left = 2),
    enumerate = list(left = 2),
    describe = list(left = 2),
    item = list(),
    code = list(),

    inline_emph = list(fmt = italic),
    inline_strong = list(fmt = bold),
    inline_code = list(before = "`", after = "`", fmt = magenta),
    inline_pkg = list(fmt = magenta),
    inline_fun = list(fmt = magenta, after = "()"),
    inline_arg = list(fmt = magenta),
    inline_key = list(before = "<", after = ">", fmt = magenta),
    inline_file = list(fmt = magenta),
    inline_email = list(fmt = magenta),
    inline_url = list(before = "<", after = ">", fmt = blue),
    inline_var = list(fmt = magenta),
    inline_envvar = list(fmt = magenta)
  )
}
