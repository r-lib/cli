
rule_class <- function(x) {
  structure(x, class = c("rule", "character"))
}

## Need to recode if fancy boxes are not available

rebox <- function(...) {
  bx <- as.character(c(...))
  Encoding(bx) <- "UTF-8"
  paste(enc2native(bx), collapse = "\n")
}
