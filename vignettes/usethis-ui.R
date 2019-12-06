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
    library(usethis)
    set.seed(1) }),
  echo = TRUE,
  echo_input = FALSE)

## ----setup----------------------------------------------------------------------------------------
library(cli)
library(usethis)

