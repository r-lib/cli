
rule_class <- function(x) {
  structure(x, class = c("rule", "ansi_string", "character"))
}

capture_messages <- function(expr) {
  msgs <- character()
  i <- 0
  suppressMessages(withCallingHandlers(
    expr,
    message = function(e) msgs[[i <<- i + 1]] <<- conditionMessage(e)))
  paste0(msgs, collapse = "")
}

capt <- function(expr, print_it = TRUE) {
  pr <- if (print_it) print else identity
  paste(capture.output(pr(expr)), collapse = "\n")
}

capt00 <- function(expr) {
  capt(expr, print_it = FALSE)
}

capt0 <- function(expr, strip_style = FALSE) {
  out <- capture_messages(expr)    
  if  (strip_style) crayon::strip_style(out) else out
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
  on <- is_utf8_output()

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
    bx <- chartr(
      c("\u250c", "\u2510", "\u2518", "\u2514", "\u2502", "\u2500"),
      c("+", "+", "+", "+", "|", "-"), bx)

    ## double
    bx <- chartr(
      c("\u2554", "\u2557", "\u255d", "\u255a", "\u2551", "\u2550"),
      c("+", "+", "+", "+", "|", "-"), bx)

    ## round
    bx <- chartr(
      c("\u256d", "\u256e", "\u256f", "\u2570", "\u2502", "\u2500"),
      c("+", "+", "+", "+", "|", "-"), bx)

    ## single-double
    bx <- chartr(
      c("\u2553", "\u2556", "\u255c", "\u2559", "\u2551", "\u2500"),
      c("+", "+", "+", "+", "|", "-"), bx)

    ## double-single
    bx <- chartr(
      c("\u2552", "\u2555", "\u255b", "\u2558", "\u2502", "\u2550"),
      c("+", "+", "+", "+", "|", "-"), bx)

    ## Bullets
    bx <- chartr("\u25CF", "*", bx)

  } else if (mode == "tree") {
    bx <- chartr(
      c("\u2500", "\u2502", "\u2514", "\u251c"),
      c("-", "|", "\\", "+"), bx)
  }

  bx
}

chartr <- function(old, new, x) {
  assertthat::assert_that(
    is.character(old),
    is.character(new),
    is.character(x),
    length(old) == length(new)
  )
  for (i in seq_along(old)) {
    x <- gsub(old[i], new[i], x, fixed = TRUE)
  }
  x
}
