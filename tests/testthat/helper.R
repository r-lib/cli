
rule_class <- function(x) {
  structure(x, class = c("rule", "character"))
}

## Need to recode if fancy boxes are not available

rebox <- function(...) {
  bx <- c(...)

  if (!fancy_boxes()) {
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
  }

  paste(bx, collapse = "\n")
}
