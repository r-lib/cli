## ---- include = FALSE, cache = FALSE--------------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  out.width = "100%",
  cache = TRUE
)
# Turn on ANSI colors
options(
    crayon.enabled = TRUE,
    crayon.colors = 256)
crayon::num_colors(forget = TRUE)
asciicast::init_knitr_engine(
  startup = quote({
    library(cli)
    set.seed(1) }),
  echo = TRUE,
  echo_input = FALSE)

## ---- cache = FALSE-------------------------------------------------------------------------------
library(cli)

## ----engine="asciicast"---------------------------------------------------------------------------
cli_alert_success("Updated database.")

## ----engine="asciicast"---------------------------------------------------------------------------
cli_alert_info("Reopened database.")

## ----engine="asciicast"---------------------------------------------------------------------------
cli_alert_warning("Cannot reach GitHub, using local database cache.")

## ----engine="asciicast"---------------------------------------------------------------------------
cli_alert_danger("Failed to connect to database.")

## ----engine="asciicast"---------------------------------------------------------------------------
cli_alert("A generic alert")

## ----engine="asciicast"---------------------------------------------------------------------------
cli_text(cli:::lorem_ipsum())

## ----engine="asciicast"---------------------------------------------------------------------------
fun <- function() {
  cli_par()
  cli_text("This is some text.")
  cli_text("Some more text.")
  cli_end()
  cli_par()
  cli_text("Already a new paragraph.")
  cli_end()
}
fun()

## ----engine="asciicast"---------------------------------------------------------------------------
cli_h1("Heading 1")

## ----engine="asciicast"---------------------------------------------------------------------------
cli_h2("Heading 2")

## ----engine="asciicast"---------------------------------------------------------------------------
cli_h3("Heading 3")

## ----engine="asciicast"---------------------------------------------------------------------------
size <- 123143123
dt <- 1.3454
cli_alert_info(c(
  "Downloaded {prettyunits::pretty_bytes(size)} in ",
  "{prettyunits::pretty_sec(dt)}"))

## ----engine="asciicast"---------------------------------------------------------------------------
fun <- function() {
  cli_ul()
  cli_li("{.emph Emphasized} text")
  cli_li("{.strong Strong} importance")
  cli_li("A piece of code: {.code sum(a) / length(a)}")
  cli_li("A package name: {.pkg cli}")
  cli_li("A function name: {.fn cli_text}")
  cli_li("A keyboard key: press {.kbd ENTER}")
  cli_li("A file name: {.file /usr/bin/env}")
  cli_li("An email address: {.email bugs.bunny@acme.com}")
  cli_li("A URL: {.url https://acme.com}")
  cli_li("An environment variable: {.envvar R_LIBS}")
}
fun()

## ----engine="asciicast"---------------------------------------------------------------------------
dlurl <- "https://httpbin.org/status/404"
cli_alert_danger("Failed to download {.url {dlurl}}.")

## ----engine="asciicast"---------------------------------------------------------------------------
pkgs <- c("pkg1", "pkg2", "pkg3")
cli_text("Packages: {pkgs}.")

## ----engine="asciicast"---------------------------------------------------------------------------
pkgs <- c("pkg1", "pkg2", "pkg3")
cli_text("Packages: {.pkg {pkgs}}")

## ----engine="asciicast"---------------------------------------------------------------------------
# Make some spaces non-breaking, and mark them with X
txt <- cli:::lorem_ipsum()
mch <- gregexpr(txt, pattern = " ", fixed = TRUE)
nbs <- runif(length(mch[[1]])) < 0.5
regmatches(txt, mch)[[1]] <- ifelse(nbs, "X\u00a0", " ")
cli_text(txt)

## ----engine="asciicast"---------------------------------------------------------------------------
cli_ol(c("item 1", "item 2", "item 3"))

## ----engine="asciicast"---------------------------------------------------------------------------
cli_ul(c("item 1", "item 2", "item 3"))

## ----engine="asciicast"---------------------------------------------------------------------------
cli_dl(c("item 1" = "description 1", "item 2" = "description 2",
         "item 3" = "description 3"))

## ----engine="asciicast"---------------------------------------------------------------------------
cli_ul(c("item 1" = cli:::lorem_paragraph(1, 20),
         "item 2" = cli:::lorem_paragraph(1, 20)))

## ----engine="asciicast"---------------------------------------------------------------------------
fun <- function() {
  lid <- cli_ul()
  cli_li("Item 1")
  cli_li("Item 2")
  cli_li("Item 3")
  cli_end(lid)
}
fun()

## ----engine="asciicast"---------------------------------------------------------------------------
fun <- function() {
  cli_ul()
  cli_li("First item")
  cli_text("This is still the first item")
  cli_li("This is the second item")
}
fun()

## ----engine="asciicast"---------------------------------------------------------------------------
fun <- function() {
  cli_ol()
  cli_li("Item 1")
  ulid <- cli_ul()
  cli_li("Subitem 1")
  cli_li("Subitem 2")
  cli_end(ulid)
  cli_li("Item 2")
  cli_end()
}
fun()

## ----engine="asciicast"---------------------------------------------------------------------------
cli_rule(left = "Compiling {.pkg mypackage}")

## ---- R.options = list(asciicast_at = NULL, asciicast_end_wait = 30), engine="asciicast"----------
f <- function() {
  cli_alert_info("About to start downloads.")
  sb <- cli_status("{symbol$arrow_right} Downloading 10 files.")
  for (i in 9:1) {
    Sys.sleep(0.5)
    if (i == 5) cli_alert_success("Already half-way!")
    cli_status_update(id = sb,
      "{symbol$arrow_right} Got {10-i} files, downloading {i}")
  }
  cli_status_clear(id = sb)
  cli_alert_success("Downloads done.")
}
f()

## ----engine="asciicast"---------------------------------------------------------------------------
builtin_theme()$h1

## ----engine="asciicast"---------------------------------------------------------------------------
fun <- function() {
  cli_div(theme = list (.alert = list(color = "red")))
  cli_alert("This will be red")
  cli_end()
  cli_alert("Back to normal color")
}
fun()

## ----engine="asciicast"---------------------------------------------------------------------------
fun <- function() {
  cli_div(theme = list(span.emph = list(color = "orange")))
  cli_text("This is very {.emph important}")
  cli_end()
  cli_text("Back to the {.emph previous theme}")
}
fun()

## ----engine="asciicast"---------------------------------------------------------------------------
tryCatch(cli_h1("Heading"), cli_message = function(x) x)
suppressMessages(cli_text("Not shown"))

## ----engine="asciicast"---------------------------------------------------------------------------
rs <- callr::r_session$new()
rs$run(function() {
  cli::cli_text("This is subprocess {.emph {Sys.getpid()}} from {.pkg callr}")
  Sys.getpid()
})
invisible(rs$close())

## ----engine="asciicast"---------------------------------------------------------------------------
cat(col_red("This ", "is ", "red."), sep = "\n")

## ----engine="asciicast"---------------------------------------------------------------------------
cli_ul(c(
  col_black("black"),
  col_blue("blue"),
  col_cyan("cyan"),
  col_green("green"),
  col_magenta("magenta"),
  col_red("red"),
  col_white("white"),
  col_yellow("yellow"),
  col_grey("grey")
))

## ----engine="asciicast"---------------------------------------------------------------------------
cli_ul(c(
  bg_black("black background"),
  bg_blue("blue background"),
  bg_cyan("cyan background"),
  bg_green("green background"),
  bg_magenta("magenta background"),
  bg_red("red background"),
  bg_white("white background"),
  bg_yellow("yellow background")
))

## ----engine="asciicast"---------------------------------------------------------------------------
cli_ul(c(
  style_dim("dim style"),
  style_blurred("blurred style"),
  style_bold("bold style"),
  style_hidden("hidden style"),
  style_inverse("inverse style"),
  style_italic("italic style"),
  style_reset("reset style"),
  style_strikethrough("strikethrough style"),
  style_underline("underline style")
))

## ----engine="asciicast"---------------------------------------------------------------------------
bg_white(style_bold(col_red("TITLE")))

## ----engine="asciicast"---------------------------------------------------------------------------
col_warn <- combine_ansi_styles(make_ansi_style("pink"), style_bold)
col_warn("This is a warning in pink!")
cat(col_warn("This is a warning in pink!"))

## ----engine="asciicast"---------------------------------------------------------------------------
console_width()

## ----engine="asciicast"---------------------------------------------------------------------------
is_ansi_tty()

## -------------------------------------------------------------------------------------------------
ansi_hide_cursor()
ansi_show_cursor()

## ----engine="asciicast"---------------------------------------------------------------------------
is_dynamic_tty()

## ----engine="asciicast"---------------------------------------------------------------------------
is_utf8_output()

## ----engine="asciicast"---------------------------------------------------------------------------
cli_text("{symbol$tick} no errors  |  {symbol$cross} 2 warnings")

## ----engine="asciicast"---------------------------------------------------------------------------
list_symbols()

## ----engine="asciicast"---------------------------------------------------------------------------
list_spinners()

## ----engine="asciicast"---------------------------------------------------------------------------
get_spinner("dots")

## ---- R.options = list(asciicast_at = NULL), engine="asciicast"-----------------------------------
ansi_with_hidden_cursor(demo_spinners("dots"))

## ---- R.options = list(asciicast_at = NULL), engine="asciicast"-----------------------------------
ansi_with_hidden_cursor(demo_spinners("clock"))

