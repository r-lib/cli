

#' Draw a banner-like box in the console
#'
#' @param label Label to show, a character vector. Each element will be
#'   in a new line. You can color it using the `crayon` packag, see
#'   examples below.
#' @param border_style String that specifies the border style.
#'   `list_border_styles` lists all current styles.
#' @param padding Padding within the box. Either an integer vector of
#'   four numbers (bottom, left, top, right), or a single number `x`, which
#'   is interpreted as `c(x, 3*x, x, 3*x)`.
#' @param margin Margin around the box. Either an integer vector of four
#'   numbers (bottom, left, top, right), or a single number `x`, which is
#'   interpreted as `c(x, 3*x, x, 3*x)`.
#' @param float Whether to display the box on the `"left"`, `"center"`, or
#'   the `"right"` of the screen.
#' @param background_col Background color of the inside of the box.
#'   Either a `crayon` style function, or a color name which will be used
#'   in [crayon::make_style()] to create a *background* style
#'   (i.e. `bg = TRUE` is used).
#' @param border_col Color of the border. Either a `crayon` style
#'   function or a color name that is passed to [crayon::make_style()].
#' @param align Alignment of the label within the box: `"left"`,
#'   `"center"`, or `"right"`.
#' @param width Width of the screen, defaults to `getOption("width")`.
#'
#' @section About fonts and terminal settings:
#' The boxes might or might not look great in your terminal, depending
#' on the box style you use and the font the terminal uses. We found that
#' the Menlo font looks nice in most terminals an also in Emacs.
#'
#' RStudio currently has a line height greater than one for console output,
#' which makes the boxes ugly.
#'
#' @export
#' @importFrom crayon col_align
#' @examples
#' ## Simple box
#' boxx("Hello there!")
#'
#' ## All border styles
#' list_border_styles()
#'
#' ## Change border style
#' boxx("Hello there!", border_style = "double")
#'
#' ## Multiple lines
#' boxx(c("Hello", "there!"), padding = 1)
#'
#' ## Padding
#' boxx("Hello there!", padding = 1)
#' boxx("Hello there!", padding = c(1, 5, 1, 5))
#'
#' ## Margin
#' boxx("Hello there!", margin = 1)
#' boxx("Hello there!", margin = c(1, 5, 1, 5))
#' boxx("Hello there!", padding = 1, margin = c(1, 5, 1, 5))
#'
#' ## Floating
#' boxx("Hello there!", padding = 1, float = "center")
#' boxx("Hello there!", padding = 1, float = "right")
#'
#' ## Text color
#' boxx(crayon::cyan("Hello there!"), padding = 1, float = "center")
#'
#' ## Backgorund color
#' boxx("Hello there!", padding = 1, background_col = "brown")
#' boxx("Hello there!", padding = 1, background_col = crayon::bgRed)
#'
#' ## Border color
#' boxx("Hello there!", padding = 1, border_col = "green")
#' boxx("Hello there!", padding = 1, border_col = crayon::red)
#'
#' ## Label alignment
#' boxx(c("Hi", "there", "you!"), padding = 1, align = "left")
#' boxx(c("Hi", "there", "you!"), padding = 1, align = "center")
#' boxx(c("Hi", "there", "you!"), padding = 1, align = "right")
#'
#' ## A very customized box
#' star <- symbol$star
#' label <- c(paste(star, "Hello", star), "  there!")
#' boxx(
#'   crayon::white(label),
#'   border_style="round",
#'   padding = 1,
#'   float = "center",
#'   border_col = "tomato3",
#'   background_col="darkolivegreen"
#' )

boxx <- function(label, border_style = "single", padding = 1, margin = 0,
                 float = c("left", "center", "right"),
                 background_col = NULL, border_col = NULL,
                 align = c("left", "center", "right"),
                 width = getOption("width")) {

  label <- as.character(label)
  widest <- max(col_nchar(label), 0)

  assert_that(is_border_style(border_style))
  assert_that(is_padding_or_margin(padding))
  assert_that(is_padding_or_margin(margin))
  float <- match.arg(float)
  assert_that(is_col(background_col))
  assert_that(is_col(border_col))
  align <- match.arg(align)

  if (length(padding) == 1) {
    padding <- c(padding, padding * 3, padding, padding * 3)
  }
  if (length(margin) == 1) {
    margin <- c(margin, margin * 3, margin, margin * 3)
  }

  label <- col_align(label, align = align, width = widest)
  content_width <- widest + padding[2] + padding[4]

  mar_left <- if (float == "center") {
    make_space((width - content_width) / 2)
  } else if (float == "right") {
    make_space(max(width - content_width - 2, 0))
  } else {
    make_space(margin[2])
  }

  color_border <- function(x) {
    if (is.function(border_col)) {
      border_col(x)
    } else if (is.character(border_col)) {
      crayon::make_style(border_col)(x)
    } else {
      x
    }
  }

  color_content <- function(x) {
    if (is.function(background_col)) {
      background_col(x)
    } else if (is.character(background_col)) {
      crayon::make_style(background_col, bg = TRUE)(x)
    } else {
      x
    }
  }

  label <- c(rep("", padding[3]), label, rep("", padding[1]))

  chars <- box_styles()[border_style, ]

  horizontal <- strrep(chars$horizontal, content_width)
  top <- color_border(paste0(
    strrep("\n", margin[3]),
    mar_left, chars$top_left, horizontal, chars$top_right
  ))
  bottom <- color_border(paste0(
    mar_left, chars$bottom_left, horizontal, chars$bottom_right,
    strrep("\n", margin[1])
  ))
  side <- color_border(chars$vertical)

  pad_left <- make_space(padding[2])
  pad_right <- make_space(content_width - col_nchar(label) - padding[2])
  middle <- paste0(mar_left, side,
                   color_content(paste0(pad_left, label, pad_right)), side)

  box <- paste0(top, "\n", paste0(middle, collapse = "\n"), "\n", bottom)

  class(box) <- unique(c("boxx", class(box), "character"))
  box
}

#' @importFrom methods setOldClass

setOldClass(c("boxx", "character"))

#' @export

print.boxx <- function(x, ..., sep = "\n") {
  cat(x, ..., sep = sep)
  invisible(x)
}
