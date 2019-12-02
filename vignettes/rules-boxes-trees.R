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

## ----setup----------------------------------------------------------------------------------------
library(cli)

## ----engine="asciicast"---------------------------------------------------------------------------
rule()

## ----engine="asciicast"---------------------------------------------------------------------------
rule(line = 2)

## ----engine="asciicast"---------------------------------------------------------------------------
rule(line = "bar2")

## ----engine="asciicast"---------------------------------------------------------------------------
rule(line = "bar5")

## ----engine="asciicast"---------------------------------------------------------------------------
rule(center = "TITLE", line = "~")

## ----engine="asciicast"---------------------------------------------------------------------------
rule(left = "Results")

## ----engine="asciicast"---------------------------------------------------------------------------
rule(center = " * RESULTS * ")

## ----engine="asciicast"---------------------------------------------------------------------------
rule(center = col_red(" * RESULTS * "))

## ----engine="asciicast"---------------------------------------------------------------------------
rule(center = " * RESULTS * ", col = "red")

## ----engine="asciicast"---------------------------------------------------------------------------
rule(center = " * RESULTS * ", line_col = "red")

## ----engine="asciicast"---------------------------------------------------------------------------
rule(center = "TITLE", line = "~-", line_col = "blue")

## ----engine="asciicast"---------------------------------------------------------------------------
rule(center = bg_red(" ", symbol$star, "TITLE", symbol$star, " "),
  line = "\u2582", line_col = "orange")

## ----engine="asciicast"---------------------------------------------------------------------------
boxx("Hello there!")

## ----engine="asciicast"---------------------------------------------------------------------------
boxx("Hello there!", border_style = "double")

## ----engine="asciicast"---------------------------------------------------------------------------
boxx(c("Hello", "there!"), padding = 1)

## ----engine="asciicast"---------------------------------------------------------------------------
boxx("Hello there!", padding = 1)

## ----engine="asciicast"---------------------------------------------------------------------------
boxx("Hello there!", padding = c(1, 5, 1, 5))

## ----engine="asciicast"---------------------------------------------------------------------------
boxx("Hello there!", margin = 1)

## ----engine="asciicast"---------------------------------------------------------------------------
boxx("Hello there!", margin = c(1, 5, 1, 5))

## ----engine="asciicast"---------------------------------------------------------------------------
boxx("Hello there!", padding = 1, float = "center")

## ----engine="asciicast"---------------------------------------------------------------------------
boxx("Hello there!", padding = 1, float = "right")

## ----engine="asciicast"---------------------------------------------------------------------------
boxx(col_cyan("Hello there!"), padding = 1, float = "center")

## ----engine="asciicast"---------------------------------------------------------------------------
boxx("Hello there!", padding = 1, background_col = "brown")

## ----engine="asciicast"---------------------------------------------------------------------------
boxx("Hello there!", padding = 1, background_col = bg_red)

## ----engine="asciicast"---------------------------------------------------------------------------
boxx("Hello there!", padding = 1, border_col = "green")

## ----engine="asciicast"---------------------------------------------------------------------------
boxx("Hello there!", padding = 1, border_col = col_red)

## ----engine="asciicast"---------------------------------------------------------------------------
boxx(c("Hi", "there", "you!"), padding = 1, align = "left")

## ----engine="asciicast"---------------------------------------------------------------------------
boxx(c("Hi", "there", "you!"), padding = 1, align = "center")

## ----engine="asciicast"---------------------------------------------------------------------------
boxx(c("Hi", "there", "you!"), padding = 1, align = "right")

## ----engine="asciicast"---------------------------------------------------------------------------
star <- symbol$star
label <- c(paste(star, "Hello", star), "  there!")
boxx(
  col_white(label),
  border_style="round",
  padding = 1,
  float = "center",
  border_col = "tomato3",
  background_col="darkolivegreen"
)

## ----engine="asciicast"---------------------------------------------------------------------------
data <- data.frame(
  stringsAsFactors = FALSE,
  package = c("processx", "backports", "assertthat", "Matrix",
    "magrittr", "rprojroot", "clisymbols", "prettyunits", "withr",
    "desc", "igraph", "R6", "crayon", "debugme", "digest", "irlba",
    "rcmdcheck", "callr", "pkgconfig", "lattice"),
  dependencies = I(list(
    c("assertthat", "crayon", "debugme", "R6"), character(0),
    character(0), "lattice", character(0), "backports", character(0),
    c("magrittr", "assertthat"), character(0),
    c("assertthat", "R6", "crayon", "rprojroot"),
    c("irlba", "magrittr", "Matrix", "pkgconfig"), character(0),
    character(0), "crayon", character(0), "Matrix",
    c("callr", "clisymbols", "crayon", "desc", "digest", "prettyunits",
      "R6", "rprojroot", "withr"),
    c("processx", "R6"), character(0), character(0)
  ))
)
tree(data, root = "rcmdcheck")

## ----engine="asciicast"---------------------------------------------------------------------------
data$label <- paste(data$package,
  col_grey(paste0("(", c("2.0.0.1", "1.1.1", "0.2.0", "1.2-11",
    "1.5", "1.2", "1.2.0", "1.0.2", "2.0.0", "1.1.1.9000", "1.1.2",
    "2.2.2", "1.3.4", "1.0.2", "0.6.12", "2.2.1", "1.2.1.9002",
    "1.0.0.9000", "2.0.1", "0.20-35"), ")"))
  )
roots <- ! data$package %in% unlist(data$dependencies)
data$label[roots] <- col_cyan(style_italic(data$label[roots]))
tree(data, root = "rcmdcheck")

