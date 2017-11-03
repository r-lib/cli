
rule_class <- function(x) {
  structure(x, class = c("rule", "character"))
}

capt <- function(expr) {
  paste(capture.output(print(expr)), collapse = "\n")
}

capt0 <- function(expr) {
  paste(capture.output(expr), collapse = "\n")
}

capt_cat <- function(expr) {
  paste(capture.output(cat(expr)), collapse = "\n")
}

## This function always needs to return the same as the actual correct output
## on the current platform, with the current settings.
## There are four cases:
## 1. Platform is UTF-8 and cli.unicode = TRUE
##    There is nothing we need to do
## 2. Platform is UTF-8 and cli.unicode = FALSE
##    Need to convert to non-unicode alternative characters
## 3. Platform is not UTF-8 and cli.unicode = TRUE
##    Need to use enc2native to convert to platform replacement characters
## 4. Platform is not UTF-8 and cli.unicode = FALSE
##    Need to convert to non-unicode alternative characters

rebox <- function(..., mode = c("box", "tree")) {
  mode <- match.arg(mode)
  bx <- as.character(c(...))
  ## Older versions of testthat do not set the encoding on the
  ## parsed files, so we set it manually here
  Encoding(bx) <- "UTF-8"
  bx <- paste(bx, collapse = "\n")

  utf8 <- l10n_info()$`UTF-8`
  on <- fancy_boxes()

  if (utf8 && on) {
    bx
  } else if (utf8 && !on) {
    fallback(bx, mode)
  } else if (!utf8 && on) {
    enc2native(bx)
  } else {
    fallback(bx, mode)
  }
}

fallback <- function(bx, mode) {

  if (mode == "box") {
    ## single
    bx <- chartr("\u250c\u2510\u2518\u2514\u2502\u2500", "++++|-", bx)

    ## double
    bx <- chartr("\u2554\u2557\u255d\u255a\u2551\u2550", "++++|-", bx)

    ## round
    bx <- chartr("\u256d\u256e\u256f\u2570\u2502\u2500", "++++|-", bx)

    ## single-double
    bx <- chartr("\u2553\u2556\u255c\u2559\u2551\u2500", "++++|-", bx)

    ## double-single
    bx <- chartr("\u2552\u2555\u255b\u2558\u2502\u2550", "++++|-", bx)

    ## Bullets
    bx <- chartr("●", "*", bx)

  } else if (mode == "tree") {
    bx <- chartr("\u2500\u2502\u2514\u251c", "-|\\+", bx)
  }

  bx
}
