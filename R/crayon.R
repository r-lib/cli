
cli_data <- new.env(parent = emptyenv())

has_crayon <- function() {
  if (!is.null(x <- cli_data$has_crayon)) return(x)
  cli_data$has_crayon <- has_crayon_update()
  cli_data$has_crayon
}

has_crayon_update <- function() {
  if (!is.na(Sys.getenv("NO_COLOR", NA))) return(FALSE)
  tryCatch(
    package_version(getNamespaceVersion("crayon"))[[1]] >= "1.3.4",
    error = function(e) FALSE)
}

num_colors <- function() {
  if (has_crayon()) crayon::num_colors() else 1L
}

cray_make_style <- function(...) {
  if (has_crayon()) {
    crayon::make_style(...)
  } else {
    function(x) x
  }
}

cray_combine_styles <- function(...) {
  if (has_crayon()) {
    crayon::combine_styles(...)
  } else {
    function(x) x
  }
}

text_align <- function(text, width = getOption("width"),
                       align = c("left", "center", "right"),
                       type = "width") {
  align <- match.arg(align)
  nc <- nchar(text, type = type)

  if (!length(text)) return(text)

  if (align == "left") {
    paste0(text, make_space(width - nc))
  } else if (align == "center") {
    paste0(
      make_space(ceiling((width - nc)/2)),
      text,
      make_space(floor((width - nc)/2)))
  } else {
    paste0(make_space(width - nc), text)
  }
}

col_align <- function(...) {
  if (has_crayon()) crayon::col_align(...) else text_align(...)
}

col_nchar <- function(...) {
  if (has_crayon()) crayon::col_nchar(...) else nchar(...)
}

col_substr <- function(...) {
  if (has_crayon()) crayon::col_substr(...) else substr(...)
}

col_substring <- function(...) {
  if (has_crayon()) crayon::col_substring(...) else substring(...)
}

cray_wrapper_fun <- function(style) {
  style
  fun <- function(...) {
    txt <- paste0(...)
    structure(style(txt), class = "ansi_string")
  }
  class(fun) <- "ansi_style"
  attr(fun, "crayon_style") <- style
  fun
}

## This runs at install time (!), so it cannot itself refer to crayon

cray_wrapper <- function(name) {
  name
  fun <- function(...) {
    txt <- paste0(...)
    atxt <- if (has_crayon()) asNamespace("crayon")[[name]](txt) else txt
    structure(atxt, class = "ansi_string")
  }
  class(fun) <- "ansi_style"
  attr(fun, "crayon_style") <- name
  fun
}

#' @export

print.ansi_string <- function(x, ...) {
  cat("<ansi_string>\n")
  if (length(x)) {
    cat(format(paste0("[", seq_along(x), "] ", format(x))), sep = "\n")
  }
  invisible(x)
}

#' Create a new ANSI style
#'
#' Create a function that can be used to add ANSI styles to text.
#' All arguments are passed to [crayon::make_style()], but see the
#' Details below.
#'
#' Note that the crayon package (at least version 1.3.4) must be installed
#' for styling text.
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
#' The styles (elements of `...`) can be any of the
#' following:
#' * An R color name, see [grDevices::colors()].
#' * A 6- or 8-digit hexa color string, e.g. `#ff0000` means
#'   red. Transparency (alpha channel) values are ignored.
#' * A one-column matrix with three rows for the red, green
#'   and blue channels, as returned by [grDevices::col2rgb()].
#'
#' `make_ansistyle()` detects the number of colors to use
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

make_ansi_style <- function(..., bg = FALSE, grey = FALSE, colors = NULL) {
  colors <- colors %||% num_colors()
  dots <- lapply(list(...), function(x) {
    if (identical(x, "dim")) return("blurred") else x
  })
  args <- c(dots, list(bg = bg , grey = grey, colors = colors))
  style <- do.call(cray_make_style, args)
  cray_wrapper_fun(style)
}

#' @export

print.ansi_style <- function(x, ...) {
  cat("<ansi_style>\n")
  cat(x("Example output"))
  cat("\n")
  invisible(x)
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
#' Note that the crayon package (at least version 1.3.4) must be installed
#' for styling text.
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
  args <- list(...)
  args <- lapply(args, function(x) {
    if (inherits(x, "ansi_style")) get_crayon_style(x) else x
  })
  style <- do.call(cray_combine_styles, args)
  cray_wrapper_fun(style)
}

get_crayon_style <- function(x) {
  style <- attr(x, "crayon_style")
  if (is.character(style)) {
    if (has_crayon()) {
      asNamespace("crayon")[[style]]
    } else {
      function(x) x
    }
  }
}

#' ANSI colored text
#'
#' cli has a number of functions to color and style text at the command
#' line. These all use the crayon package under the hood, but provide a
#' slightly simpler interface.
#'
#' Note that the crayon package (at least version 1.3.4) must be installed
#' for styling text.
#'
#' The `col_*` functions change the (foreground) color to the text.
#' These are the eight original ANSI colors. Note that in some terminals,
#' they might actually look differently, as terminals have their own
#' settings for how to show them.
#'
#' The `bg_*` functions change the background color of the text.
#' These are the eight original ANSI background colors. These, too, can
#' vary in appearence, depending on terminal settings.
#'
#' The `style_*` functions apply other styling to the text. The currently
#' supported styling funtions are:
#' * `style_reset()` to remove any style, including color,
#' * `style_bold()` for boldface / strong text, although some terminals
#'   show a bright, high intensity text instead,
#' * `style_dim()` (or `style_blurred()` reduced intensity text.
#' * `style_italic()` (not widely supported).
#' * `style_underline()`,
#' * `style_inverse()`,
#' * `style_hidden()`,
#' * `style_strikethrough() (not widely supported).
#'
#' The style functions take any number of character vectors as arguments,
#' and they concatenate them using `paste0()` before adding the style.
#'
#' Styles can also be nested, and then inner style takes precedence, see
#' examples below.
#'
#' @param ... Character strings, they will be pasted together with
#'   `paste0()`, before applying the style function.
#' @return An ANSI string (class `ansi_string`), that contains ANSI
#'   sequences, if the current platform supports them. You can simply
#'   use `cat()` to print them to the terminal.
#'
#' @family ANSI styling
#' @name ansi-styles
#' @examples
#' col_blue("Hello ", "world!")
#' cat(col_blue("Hello ", "world!"))
#'
#' cat("... to highlight the", col_red("search term"),
#'     "in a block of text\n")
#'
#' ## Style stack properly
#' cat(col_green(
#'  "I am a green line ",
#'  col_blue(style_underline(style_bold("with a blue substring"))),
#'  " that becomes green again!"
#' ))
#'
#' error <- combine_ansi_styles("red", "bold")
#' warn <- combine_ansi_styles("magenta", "underline")
#' note <- col_cyan
#' cat(error("Error: subscript out of bounds!\n"))
#' cat(warn("Warning: shorter argument was recycled.\n"))
#' cat(note("Note: no such directory.\n"))
#'
NULL

#' @export
#' @name ansi-styles
bg_black    <- cray_wrapper("bgBlack")
#' @export
#' @name ansi-styles
bg_blue     <- cray_wrapper("bgBlue")
#' @export
#' @name ansi-styles
bg_cyan     <- cray_wrapper("bgCyan")
#' @export
#' @name ansi-styles
bg_green    <- cray_wrapper("bgGreen")
#' @export
#' @name ansi-styles
bg_magenta  <- cray_wrapper("bgMagenta")
#' @export
#' @name ansi-styles
bg_red      <- cray_wrapper("bgRed")
#' @export
#' @name ansi-styles
bg_white    <- cray_wrapper("bgWhite")
#' @export
#' @name ansi-styles
bg_yellow   <- cray_wrapper("bgYellow")

#' @export
#' @name ansi-styles
col_black   <- cray_wrapper("black")
#' @export
#' @name ansi-styles
col_blue    <- cray_wrapper("blue")
#' @export
#' @name ansi-styles
col_cyan    <- cray_wrapper("cyan")
#' @export
#' @name ansi-styles
col_green   <- cray_wrapper("green")
#' @export
#' @name ansi-styles
col_magenta <- cray_wrapper("magenta")
#' @export
#' @name ansi-styles
col_red     <- cray_wrapper("red")
#' @export
#' @name ansi-styles
col_white   <- cray_wrapper("white")
#' @export
#' @name ansi-styles
col_yellow  <- cray_wrapper("yellow")
#' @export
#' @name ansi-styles
col_grey    <- cray_wrapper("silver")
#' @export
#' @name ansi-styles
col_silver  <- cray_wrapper("silver")

#' @export
#' @name ansi-styles
style_dim           <- cray_wrapper("blurred")
#' @export
#' @name ansi-styles
style_blurred       <- cray_wrapper("blurred")
#' @export
#' @name ansi-styles
style_bold          <- cray_wrapper("bold")
#' @export
#' @name ansi-styles
style_hidden        <- cray_wrapper("hidden")
#' @export
#' @name ansi-styles
style_inverse       <- cray_wrapper("inverse")
#' @export
#' @name ansi-styles
style_italic        <- cray_wrapper("italic")
#' @export
#' @name ansi-styles
style_reset         <- cray_wrapper("reset")
#' @export
#' @name ansi-styles
style_strikethrough <- cray_wrapper("strikethrough")
#' @export
#' @name ansi-styles
style_underline     <- cray_wrapper("underline")
