
#' @importFrom assertthat assert_that on_failure<-

is_string <- function(x) {
  is.character(x) && length(x) == 1 && !is.na(x)
}

on_failure(is_string) <- function(call, env) {
  paste0(deparse(call$x), " is not a string (length 1 character)")
}

is_border_style <- function(x) {
  is_string(x) && x %in% rownames(box_styles())
}

on_failure(is_border_style) <- function(call, env) {
  paste0(deparse(call$x), " is not a border style (see ",
         sQuote("border_styles"), ")")
}

is_padding_or_margin <- function(x) {
  is.numeric(x) && length(x) %in% c(1, 4) && all(!is.na(x)) &&
    all(as.integer(x) == x)
}

on_failure(is_padding_or_margin) <- function(call, env) {
  paste0(deparse(call$x), " must be an integer of length one or four")
}

is_col <- function(x) {
  is.null(x) || is_string(x) || is.function(x)
}

on_failure(is_col) <- function(call, env) {
  paste0(deparse(call$x), " must be a color name, or an `ansi_style`")
}

is_count <- function(x) {
  is.numeric(x) && length(x) == 1 && !is.na(x) && as.integer(x) == x &&
    x >= 0
}

on_failure(is_count) <- function(call, env) {
  paste0(deparse(call$x),
         " must be a count (length 1 non-negative integer)")
}

is_tree_style <- function(x) {
  is.list(x) &&
    length(x) == 4 &&
    !is.null(names(x)) &&
    all(sort(names(x)) == sort(c("h", "v", "l", "j"))) &&
    all(sapply(x, is_string))
}
