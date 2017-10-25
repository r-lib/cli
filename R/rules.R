
#' @importFrom crayon col_substring

make_line <- function(x, char = symbol$line) {

  ## Easiest to handle this specially
  if (x <= 0) return("")

  cw <- col_nchar(char, "width")

  ## We handle the simple case differently, to make it faster
  if (cw == 1) {
    paste(rep(char, x), collapse = "")

  } else {
    col_substring(
      paste(rep(char, ceiling(x / cw)), collapse = ""),
      1, x
    )
  }
}

#' Make a rule with one or two text labels
#'
#' The rule can include either a centered text label, or labels on the
#' left and right side.
#'
#' To color the labels, use the functions from the `crayon` package
#' directly, see examples below. To color the line, either use the
#' `crayon` colors directly, or the `line_col` option.
#'
#' @param left Label to show on the left. It interferes with the `center`
#'   label, only at most one of them can be present.
#' @param center Label to show at the center. It interferes  with the
#'   `left` and `right` labels.
#' @param right Label to show on the right. It interferes with the `center`
#'   label, only at most one of them can be present.
#' @param line The character or string that is used to draw the line.
#'   It can also `1` or `2`, to request a single line (Unicode, if
#'   available), or a double line. Some strings are interpreted specially,
#'   see *Line styles* below.
#' @param line_col Either a color name (used in [crayon::make_style()]),
#'   or a style function from `crayon`, to color the line.
#' @param width Width of the rule. Defaults to the `width` option, see
#'   [base::options()].
#' @return Character scalar, the rule.
#'
#' @section Line styles:
#' Some strings for the `line` argument are interpreted specially:
#' * `"single"`: (same as `1`), a single line,
#' * `"double"`: (same as `2`), a double line,
#' * `"bar1"`, `"bar2"`, `"bar3"`, etc., `"bar8"` uses varying height bars.
#'
#' @export
#' @importFrom crayon col_substr
#' @examples
#'
#' ## Simple rule
#' rule()
#'
#' ## Double rule
#' rule(line = 2)
#'
#' ## Bars
#' rule(line = "bar2")
#' rule(line = "bar5")
#'
#' ## Left label
#' rule(left = "Results")
#'
#' ## Centered label
#' rule(center = " * RESULTS * ")
#'
#' ## Colored labels
#' rule(center = crayon::red(" * RESULTS * "))
#'
#' ## Colored line
#' rule(center = crayon::red(" * RESULTS * "), line_col = "red")
#'
#' ## Custom line
#' rule(center = "TITLE", line = "~")
#'
#' ## More custom line
#' rule(center = "TITLE", line = crayon::blue("~-"))
#'
#' ## Even more custom line
#' rule(center = crayon::bgRed(" ", symbol$star, "TITLE",
#'   symbol$star, " "),
#'   line = "\u2582",
#'   line_col = "orange")

rule <- function(left = "", center = "", right = "", line = 1,
                 line_col = NULL, width = console_width()) {

  assert_that(
    is_string(left),
    is_string(center),
    is_string(right),
    is_string(line) || line == 1 || line == 2,
    is_col(line_col),
    is_count(width)
  )

  options <- as.list(environment())
  options$line <- apply_style(get_line_char(options$line), line_col)

  res <- if (nchar(center)) {
    if (nchar(left) || nchar(right)) {
      stop(sQuote("center"), " cannot be specified with ", sQuote("left"),
           " or ", sQuote("right"))
    }
    rule_center(options)

  } else if (nchar(left) && nchar(right)) {
    rule_left_right(options)

  } else if (nchar(left)) {
    rule_left(options)

  } else if (nchar(right)) {
    rule_right(options)

  } else {
    rule_line(options)
  }

  res <- col_substr(res, 1, width)

  class(res) <- unique(c("rule", class(res), "character"))
  res
}

get_line_char <- function(line) {
  if (identical(line, 1) || identical(line, 1L)) {
    symbol$line

  } else if (identical(line, 2) || identical(line, 2L)) {
    symbol$double_line

  } else if (length(line) == 1 && line %in% paste0("bar", 1:8)) {
    bars <- structure(
      paste0("lower_block_", 1:8),
      names = paste0("bar", 1:8)
    )
    symbol[[ bars[[line]] ]]

  } else {
    paste(as.character(line), collapse = "")
  }
}

rule_line <- function(o) {
  make_line(o$width, o$line)
}

#' @importFrom crayon col_nchar

rule_center <- function(o) {

  o$center <- col_substring(o$center, 1, o$width - 4)
  o$center <- paste0(" ", o$center, " ")
  ncc <- col_nchar(o$center, "width")

  ndashes <- o$width - ncc

  paste0(
    make_line(ceiling(ndashes / 2), o$line),
    o$center,
    make_line(floor(ndashes / 2), o$line)
  )
}

rule_left <- function(o) {
  ncl <- col_nchar(o$left, "width")

  paste0(
    make_line(2, get_line_char(o$line)),
    " ", o$left, " ",
    make_line(o$width - ncl - 4, o$line)
  )
}

rule_right <- function(o) {
  ncr <- col_nchar(o$right, "width")

  paste0(
    make_line(o$width - ncr - 4, o$line),
    " ", o$right, " ",
    make_line(2, o$line)
  )
}

rule_left_right <- function(o) {

  ncl <- col_nchar(o$left, "width")
  ncr <- col_nchar(o$right,  "width")

  ## -- (ncl) -- (ncr) --
  if (ncl + ncr + 10 > o$width) return(rule_left(o))

  paste0(
    make_line(2, o$line),
    " ", o$left, " ",
    make_line(o$width - ncl - ncr - 8, o$line),
    " ", o$right, " ",
    make_line(2, o$line)
  )
}

#' @importFrom methods setOldClass

setOldClass(c("rule", "character"))

#' @export

print.rule <- function(x, ..., sep = "\n") {
  cat(x, ..., sep = sep)
  invisible(x)
}
