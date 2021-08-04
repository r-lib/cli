
ansi_builtin_styles <- list(
  reset = list(0, c(0, 22, 23, 24, 27, 28, 29, 39, 49)),
  bold = list(1, 22), # 21 isn't widely supported and 22 does the same thing
  blurred = list(2, 22),
  italic = list(3, 23),
  underline = list(4, 24),
  inverse = list(7, 27),
  hidden = list(8, 28),
  strikethrough = list(9, 29),

  black = list(30, 39),
  red = list(31, 39),
  green = list(32, 39),
  yellow = list(33, 39),
  blue = list(34, 39),
  magenta = list(35, 39),
  cyan = list(36, 39),
  white = list(37, 39),
  silver = list(90, 39),

  br_black = list(90, 39),
  br_red = list(91, 39),
  br_green = list(92, 39),
  br_yellow = list(93, 39),
  br_blue = list(94, 39),
  br_magenta = list(95, 39),
  br_cyan = list(96, 39),
  br_white = list(97, 39),

  bg_black = list(40, 49),
  bg_red = list(41, 49),
  bg_green = list(42, 49),
  bg_yellow = list(43, 49),
  bg_blue = list(44, 49),
  bg_magenta = list(45, 49),
  bg_cyan = list(46, 49),
  bg_white = list(47, 49),

  bg_br_black = list(100, 39),
  bg_br_red = list(101, 39),
  bg_br_green = list(102, 39),
  bg_br_yellow = list(103, 39),
  bg_br_blue = list(104, 39),
  bg_br_magenta = list(105, 39),
  bg_br_cyan = list(106, 39),
  bg_br_white = list(107, 39),

  # similar to reset, but only for a single property
  no_bold          = list(c(0,     23, 24, 27, 28, 29, 39, 49), 22),
  no_blurred       = list(c(0,     23, 24, 27, 28, 29, 39, 49), 22),
  no_italic        = list(c(0, 22,     24, 27, 28, 29, 39, 49), 23),
  no_underline     = list(c(0, 22, 23,     27, 28, 29, 39, 49), 24),
  no_inverse       = list(c(0, 22, 23, 24,     28, 29, 39, 49), 27),
  no_hidden        = list(c(0, 22, 23, 24, 27,     29, 39, 49), 28),
  no_strikethrough = list(c(0, 22, 23, 24, 27, 28,     39, 49), 29),
  none             = list(c(0, 22, 23, 24, 27, 28, 29,     49), 39),
  no_color         = list(c(0, 22, 23, 24, 27, 28, 29,     49), 39),
  bg_none          = list(c(0, 22, 23, 24, 27, 28, 29, 39    ), 49),
  no_bg_color      = list(c(0, 22, 23, 24, 27, 28, 29, 39    ), 49)
)

is_builtin_style <- function(x) {
  is_string(x) && x %in% names(ansi_builtin_styles)
}

ansi_fg_r <- c(
  "black" = "black",
  "red" = "red",
  "green" = "green",
  "yellow" = "yellow",
  "blue" = "blue",
  "magenta" = "magenta",
  "cyan" = "cyan",
  "white" = "white",
  "silver" = "grey"
)

ansi_fg_rgb <- grDevices::col2rgb(ansi_fg_r)

ansi_bg_r <- c(
  "bg_black" = "black",
  "bg_red" = "red",
  "bg_green" = "green",
  "bg_yellow" = "yellow",
  "bg_blue" = "blue",
  "bg_magenta" = "magenta",
  "bg_cyan" = "cyan",
  "bg_white" = "white"
)

ansi_bg_rgb <- grDevices::col2rgb(ansi_bg_r)

ansi_style_str <- function(x) {
  paste0("\u001b[", x, "m", collapse = "")
}

create_ansi_style_tag <- function(name, open, close) {
  structure(
    list(list(open = open, close = close)),
    names = name
  )
}

create_ansi_style_fun <- function(styles) {
  fun <- eval(substitute(function(...) {
    mystyles <- .styles
    txt <- paste0(...)
    if (num_ansi_colors() > 1) {
      for (st in rev(mystyles)) {
        txt <- paste0(
          st$open,
          gsub(st$close, st$open, txt, fixed = TRUE),
          st$close
        )
      }
    }
    class(txt) <- c("ansi_string", "character")
    txt
  }, list(.styles = styles)))

  class(fun) <- "ansi_style"
  attr(fun, "_styles") <- styles
  fun
}

create_ansi_style <- function(name, open = NULL, close = NULL) {
  open <- open %||% ansi_style_str(ansi_builtin_styles[[name]][[1]])
  close <- close %||% ansi_style_str(ansi_builtin_styles[[name]][[2]])
  style <- create_ansi_style_tag(name, open, close)
  create_ansi_style_fun(style)
}

#' @export

print.ansi_string <- function(x, ...) {
  cat("<ansi_string>\n")
  if (length(x)) {
    cat(format(paste0("[", seq_along(x), "] ", format(x))), sep = "\n")
  }
  invisible(x)
}

#' @export

print.ansi_style <- function(x, ...) {
  cat("<ansi_style>\n")
  cat(x("Example output"))
  cat("\n")
  invisible(x)
}

#' Create a new ANSI style
#'
#' Create a function that can be used to add ANSI styles to text.
#'
#' @param ... The style to create. See details and examples below.
#' @param bg Whether the color applies to the background.
#' @param grey Whether to specifically create a grey color.
#'   This flag is included, because ANSI 256 has a finer color scale
#'   for greys, then the usual 0:5 scale for red, green and blue components.
#'   It is only used for RGB color specifications (either numerically
#'   or via a hexa string), and it is ignored on eigth color ANSI
#'   terminals.
#' @param colors Number of colors, detected automatically
#'   by default.
#' @return A function that can be used to color (style) strings.
#'
#' @details
#' The `...` style argument can be any of the following:
#' * A cli ANSI style function of class `ansi_style`. This is returned
#'   as is, without looking at the other arguments.
#' * An R color name, see [grDevices::colors()].
#' * A 6- or 8-digit hexa color string, e.g. `#ff0000` means
#'   red. Transparency (alpha channel) values are ignored.
#' * A one-column matrix with three rows for the red, green
#'   and blue channels, as returned by [grDevices::col2rgb()].
#'
#' `make_ansi_style()` detects the number of colors to use
#' automatically (this can be overridden using the `colors`
#' argument). If the number of colors is less than 256 (detected or given),
#' then it falls back to the color in the ANSI eight color mode that
#' is closest to the specified (RGB or R) color.
#'
#'
#' @family ANSI styling
#' @export
#' @examples
#' make_ansi_style("orange")
#' make_ansi_style("#123456")
#' make_ansi_style("orange", bg = TRUE)
#'
#' orange <- make_ansi_style("orange")
#' orange("foobar")
#' cat(orange("foobar"))

make_ansi_style <- function(..., bg = FALSE, grey = FALSE,
                            colors = num_ansi_colors()) {

  style <- list(...)[[1]]
  if (inherits(style, "ansi_style")) return(style)
  if (inherits(style, "crayon")) {
    return(create_ansi_style_fun(attr(style, "_styles")))
  }

  if (identical(style, "dim")) style <- "blurred"

  orig_style_name <- style_name <- names(args)[1]

  stopifnot(is.character(style) && length(style) == 1 ||
            is_rgb_matrix(style) && ncol(style) == 1,
            is.logical(bg) && length(bg) == 1,
            is.numeric(colors) && length(colors) == 1)

  ansi_seqs <- if (is_builtin_style(style)) {
    if (bg && substr(style, 1, 3) != "bg_") {
      style <- paste0("bg_", style)
    }
    if (is.null(style_name)) style_name <- style
    ansi_builtin_styles[[style]]

  } else if (is_r_color(style)) {
    if (is.null(style_name)) style_name <- style
    ansi_style_from_r_color(style, bg, colors, grey)

  } else if (is_rgb_matrix(style)) {
    ansi_style_from_rgb(style, bg, colors, grey)

  } else {
    stop("Unknown style specification: ", style)
  }

  create_ansi_style(style_name, ansi_seqs$open, ansi_seqs$close)
}

hash_color_regex <- "^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{8})$"

is_r_color <- function(x) {
  if (!is.character(x) || length(x) != 1 || is.na(x)) {
    FALSE
  } else {
    x %in% grDevices::colors() || grepl(hash_color_regex, x)
  }
}

is_rgb_matrix <- function(x) {
  is.matrix(x) && is.numeric(x) && (nrow(x) == 3 || nrow(x) == 4)
}

ansi_style_from_r_color <- function(color, bg, num_colors, grey) {
  ansi_style_from_rgb(grDevices::col2rgb(color), bg, num_colors, grey)
}

ansi_style_8_from_rgb <- function(rgb, bg) {
  ansi_cols <- if (bg) ansi_bg_rgb else ansi_fg_rgb
  dist <- colSums((ansi_cols - as.vector(rgb)) ^ 2 )
  builtin_name <- names(which.min(dist))[1]
  btn <- ansi_builtin_styles[[builtin_name]]
  list(open = ansi_style_str(btn[[1]]), close = ansi_style_str(btn[[2]]))
}

ansi_style_from_rgb <- function(rgb, bg, num_colors, grey) {
  if (num_colors < 256) { return(ansi_style_8_from_rgb(rgb, bg)) }
  ansi256(rgb, bg, grey)
}

# nocov start
fgcodes <- c(paste0('\x1b[38;5;', 0:255, 'm'), '\x1b[39m')
bgcodes <- c(paste0('\x1b[48;5;', 0:255, 'm'), '\x1b[49m')

rgb_index <- 17:232
gray_index <- 233:256
reset_index <- 257
#nocov end

ansi_scale <- function(x, from = c(0, 255), to = c(0, 5), round = TRUE) {
  y <- (x - from[1]) /
    (from[2] - from[1]) *
    (to[2] - to[1]) +
    to[1]

  if (round) {
    round(y)
  } else {
    y
  }
}

ansi256 <- function(rgb, bg = FALSE, grey = FALSE) {
  codes <- if (bg) bgcodes else fgcodes
  if (grey) {
    ## Gray
    list(
      open = codes[gray_index][ansi_scale(rgb[1], to = c(0, 23)) + 1],
      close = codes[reset_index]
    )

  } else {
    ## Not gray
    list(
      open = codes[ansi256_rgb_index(rgb[1L], rgb[2L], rgb[3L])],
      close = codes[reset_index]
    )
  }
}

## This is based off the algorithm in the ruby "paint" gem, as
## implemented in rainbowrite.
ansi256_rgb_index <- function(red, green, blue) {
  gray_possible <- TRUE
  sep <- 42.5
  while (gray_possible) {
    if (red < sep || green < sep || blue < sep) {
      gray <- red < sep && green < sep && blue < sep
      gray_possible <- FALSE
    }
    sep <- sep + 42.5
  }

  ## NOTE: The +1 here translates from base0 to base1 for the index
  ## that does the same.  Not ideal, but that does get the escape
  ## characters in nicely.
  if (gray) {
    232 + round((red + green + blue) / 33) + 1
  } else {
    16 + sum(floor(6 * c(red, green, blue) / 256) * c(36, 6, 1)) + 1
  }
}

#' Combine two or more ANSI styles
#'
#' Combine two or more styles or style functions into a new style function
#' that can be called on strings to style them.
#'
#' It does not usually make sense to combine two foreground
#' colors (or two background colors), because only the first one
#' applied will be used.
#'
#' It does make sense to combine different kind of styles,
#' e.g. background color, foreground color, bold font.
#'
#' @param ... The styles to combine. For character strings, the
#'   [make_ansi_style()] function is used to create a style first.
#'   They will be applied from right to left.
#' @return The combined style function.
#'
#' @family ANSI styling
#' @export
#' @examples
#' ## Use style names
#' alert <- combine_ansi_styles("bold", "red4")
#' cat(alert("Warning!"), "\n")
#'
#' ## Or style functions
#' alert <- combine_ansi_styles(style_bold, col_red, bg_cyan)
#' cat(alert("Warning!"), "\n")
#'
#' ## Combine a composite style
#' alert <- combine_ansi_styles(
#'   "bold",
#'   combine_ansi_styles("red", bg_cyan))
#' cat(alert("Warning!"), "\n")

combine_ansi_styles <- function(...) {
  styles <- lapply(
    list(...),
    function(x) attr(make_ansi_style(x), "_styles")
  )
  styles <- unlist(styles, recursive = FALSE)
  create_ansi_style_fun(styles)
}
