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

## -------------------------------------------------------------------------------------------------
ansi_hide_cursor()
ansi_show_cursor()

