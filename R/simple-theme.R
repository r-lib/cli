
#' A simple CLI theme
#'
#' Note that this is in addition to the builtin theme. To use this theme,
#' you can set it as the `cli.theme` option:
#'
#' ```
#' options(cli.theme = cli::simple_theme())
#' ```
#'
#' and then CLI apps started after this will use it as the default theme.
#' You can also use it temporarily, in a div element:
#'
#' ```
#' cli_div(theme = cli::simple_theme())
#' ```
#'
#' @param dark Whether the theme should be optiomized for a dark
#'   background. If `"auto"`, then cli will try to detect this.
#'   Detection usually works in recent RStudio versions, and in iTerm
#'   on macOS, but not on other platforms.
#'
#' @seealso [themes], [builtin_theme()].
#' @export
#' @examples
#' cli_div(theme = cli::simple_theme())
#'
#' cli_h1("Header 1")
#' cli_h2("Header 2")
#' cli_h3("Header 3")
#'
#' cli_alert_danger("Danger alert")
#' cli_alert_warning("Warning alert")
#' cli_alert_info("Info alert")
#' cli_alert_success("Success alert")
#' cli_alert("Alert for starting a process or computation",
#'   class = "alert-start")
#'
#' cli_text("Packages and versions: {pkg cli} {version 1.0.0}.")
#' cli_text("Time intervals: {timestamp 3.4s}")
#'
#' cli_text("{emph Emphasis} and  {strong strong emphasis}")
#'
#' cli_text("This is a piece of code: {code sum(x) / length(x)}")
#' cli_text("Function names: {fun cli::simple_theme} and {arg arguments}.")
#'
#' cli_text("Files: {file /usr/bin/env}")
#' cli_text("URLs: {url https://r-project.org}")
#'
#' cli_h2("Longer code chunk")
#' cli_par(class = "r-code")
#' cli_verbatim(
#'   '# window functions are useful for grouped mutates',
#'   'mtcars %>%',
#'   '  group_by(cyl) %>%',
#'   '  mutate(rank = min_rank(desc(mpg)))')
#' cli_end()
#'
#' cli_h2("Even longer code chunk")
#' cli_par(class = "r-code")
#' cli_verbatim(format(ls))
#' cli_end()
#'
#' cli_end()

simple_theme <- function(dark = "auto") {

  if (dark == "auto") {
    dark <- if (Sys.getenv("RSTUDIO", "0") == "1") {
      tryCatch(
        rstudioapi::getThemeInfo()$dark,
        error = function(x) FALSE)
    } else if (is_iterm()) {
      is_iterm_dark()
    } else {
      FALSE
    }
  }

  list(
    h1 = list(
      "margin-top" = 1,
      "margin-bottom" = 0,
      color = "cyan",
      fmt = function(x) cli::rule(x, line_col = "cyan")),

    h2 = list(
      "margin-top" = 1,
      "margin-bottom" = 0,
      color = "cyan",
      fmt = function(x) paste0(symbol$line, " ", x, " ", symbol$line, symbol$line)),

    h3 = list(
      "margin-top" = 1,
      "margin-bottom" = 0,
      color = "cyan"),

    par = list("margin-top" = 0, "margin-bottom" = 1),

    ".alert-danger" = list(
      "background-color" = "red",
      color = "white"
    ),
    ".alert-danger::before" = list(
      content = paste0(symbol$cross, " ")
    ),
    ".alert-warning" = list(
      color = "orange",
      "font-weight" = "bold"),
    ".alert-warning::before" = list(
      content = paste0("!", " ")
    ),

    ".alert-success::before" = list(
      content = paste0(crayon::green(symbol$tick), " ")
    ),
    ".alert-info::before" = list(
      content = paste0(crayon::cyan(symbol$info), " ")
    ),

    ".alert-start::before" = list(
      content = paste0(symbol$arrow_right, " ")),

    span.pkg = list(
      color = "blue",
      "font-weight" = "bold"),
    span.version = list(color = "blue"),

    .code = simple_theme_code(dark),
    "span.code::before" = list(content = "`"),
    "span.code::after" = list(content = "`"),

    ".r-code" = list(
      fmt = simple_theme_r_code(dark),
      "margin-top" = 1,
      "margin-bottom" = 1),

    span.emph = simple_theme_emph(),
    span.strong = list("font-weight" = "bold", "font-style" = "italic"),

    span.fun = simple_theme_code(dark),
    "span.fun::after" = list(content = "()"),
    span.arg = simple_theme_code(dark),
    span.key = simple_theme_code(dark),
    "span.key::before" = list(content = "<"),
    "span.key::after" = list(content = ">"),
    span.file = simple_theme_file(),
    span.path = simple_theme_file(),
    span.email = simple_theme_url(),
    span.url = simple_theme_url(),
    "span.url::before" = list(content = "<"),
    "span.url::after" = list(content = ">"),
    span.var = simple_theme_code(dark),
    span.envvar = simple_theme_code(dark),

    span.timestamp = list(color = "grey"),
    "span.timestamp::before" = list(
      content = "["),
    "span.timestamp::after" = list(
      content = "]")
  )
}

simple_theme_emph <- function() {
  list("font-style" = "italic")
}

simple_theme_url <- function() {
  list(color = "blue")
}

simple_theme_code <- function(dark) {
  if (dark) {
    list("background-color" = "#232323", color = "#f0f0f0")
  } else{
    list("background-color" = "#f8f8f8", color = "#202020")
  }
}

simple_theme_file <- function() {
  list(color = "blue")
}

simple_theme_r_code <- function(dark) {
  dark <- dark
  style <- if (dark) {
    crayon::combine_styles(
      crayon::make_style("#232323", bg = TRUE),
      crayon::make_style("#f0f0f0")
    )
  } else {
    crayon::combine_styles(
      crayon::make_style("#f8f8f8", bg = TRUE),
      crayon::make_style("#202020")
    )
  }
  function(x) {
    lines <- strsplit(x, "\n", fixed = TRUE)[[1]]
    code <- tryCatch(prettycode::highlight(lines), error = function(x) lines)
    len <- fansi::nchar_ctl(code)
    padded <- paste0(" ", code, strrep(" ", max(len) - len), " ")
    style(padded)
  }
}

is_iterm <- function() {
  isatty(stdout()) && Sys.getenv("TERM_PROGRAM", "") == "iTerm.app"
}

is_iterm_dark <- function() {
  tryCatch(
    error = function(x) FALSE, {
      osa <- '
        tell application "iTerm2"
          tell current session of current window
            get background color
          end tell
        end tell
      '
      out <- system2("osascript", c("-e", shQuote(osa)), stdout = TRUE)
      nums <- scan(text = gsub(",", "", out), quiet = TRUE)
      mean(nums) < 20000
  })
}
