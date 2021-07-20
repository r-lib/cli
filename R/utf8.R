
#' Whether cli is emitting UTF-8 characters
#'
#' UTF-8 cli characters can be turned on by setting the `cli.unicode`
#' option to `TRUE`. They can be turned off by setting if to `FALSE`.
#' If this option is not set, then [base::l10n_info()] is used to detect
#' UTF-8 support.
#'
#' @return Flag, whether cli uses UTF-8 characters.
#'
#' @export

is_utf8_output <- function() {
  opt <- getOption("cli.unicode", NULL)
  if (! is.null(opt)) {
    isTRUE(opt)
  } else {
    l10n_info()$`UTF-8` && !is_latex_output()
  }
}

#' Count the number of characters in a character vector
#'
#' By default it counts Unicode grapheme clusters, instead of code points.
#'
#' @param x Character vector, it is converted to UTF-8.
#' @param type Whether to count graphemes (characters), code points,
#'   bytes, or calculate the display width of the string.
#' @return Numeric vector, the length of the strings in the character
#'   vector.
#'
#' @export
#' @examples
#' # Grapheme example, emoji with combining characters. This is a single
#' # grapheme, consisting of five Unicode code points:
#' # * `\U0001f477` is the construction worker emoji
#' # * `\U0001f3fb` is emoji modifier that changes the skin color
#' # * `\u200d` is the zero width joiner
#' # * `\u2640` is the female sign
#' # * `\ufe0f` is variation selector 16, requesting an emoji style glyph
#' emo <- "\U0001f477\U0001f3fb\u200d\u2640\ufe0f"
#' cat(emo)
#'
#' utf8_nchar(emo, "chars") # = graphemes
#' utf8_nchar(emo, "bytes")
#' utf8_nchar(emo, "width")
#' utf8_nchar(emo, "codepoints")
#'
#' # For comparision, the output for width depends on the R version used:
#' nchar(emo, "chars")
#' nchar(emo, "bytes")
#' nchar(emo, "width")

utf8_nchar <- function(x, type = c("chars", "bytes", "width", "graphemes",
                                   "codepoints")) {

  type <- match.arg(type)
  if (type == "chars") type <- "graphemes"

  x <- enc2utf8(x)

  if (type == "width") {
    .Call(clic_utf8_display_width, x)

  } else if (type == "graphemes") {
    .Call(clic_utf8_nchar_graphemes, x)

  } else if (type == "codepoints") {
    base::nchar(x, allowNA = FALSE, keepNA = TRUE, type = "chars")

  } else { # bytes
    base::nchar(x, allowNA = FALSE, keepNA = TRUE, type = "bytes")
  }

}
