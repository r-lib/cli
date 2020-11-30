
#' ANSI colored text
#'
#' cli has a number of functions to color and style text at the command
#' line. These all use the crayon package under the hood, but provide a
#' slightly simpler interface.
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
#' * `style_strikethrough()` (not widely supported).
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
bg_black    <- create_ansi_style("bg_black")
#' @export
#' @name ansi-styles
bg_blue     <- create_ansi_style("bg_blue")
#' @export
#' @name ansi-styles
bg_cyan     <- create_ansi_style("bg_cyan")
#' @export
#' @name ansi-styles
bg_green    <- create_ansi_style("bg_green")
#' @export
#' @name ansi-styles
bg_magenta  <- create_ansi_style("bg_magenta")
#' @export
#' @name ansi-styles
bg_red      <- create_ansi_style("bg_red")
#' @export
#' @name ansi-styles
bg_white    <- create_ansi_style("bg_white")
#' @export
#' @name ansi-styles
bg_yellow   <- create_ansi_style("bg_yellow")

#' @export
#' @name ansi-styles
col_black   <- create_ansi_style("black")
#' @export
#' @name ansi-styles
col_blue    <- create_ansi_style("blue")
#' @export
#' @name ansi-styles
col_cyan    <- create_ansi_style("cyan")
#' @export
#' @name ansi-styles
col_green   <- create_ansi_style("green")
#' @export
#' @name ansi-styles
col_magenta <- create_ansi_style("magenta")
#' @export
#' @name ansi-styles
col_red     <- create_ansi_style("red")
#' @export
#' @name ansi-styles
col_white   <- create_ansi_style("white")
#' @export
#' @name ansi-styles
col_yellow  <- create_ansi_style("yellow")
#' @export
#' @name ansi-styles
col_grey    <- create_ansi_style("silver")
#' @export
#' @name ansi-styles
col_silver  <- create_ansi_style("silver")

#' @export
#' @name ansi-styles
style_dim           <- create_ansi_style("blurred")
#' @export
#' @name ansi-styles
style_blurred       <- create_ansi_style("blurred")
#' @export
#' @name ansi-styles
style_bold          <- create_ansi_style("bold")
#' @export
#' @name ansi-styles
style_hidden        <- create_ansi_style("hidden")
#' @export
#' @name ansi-styles
style_inverse       <- create_ansi_style("inverse")
#' @export
#' @name ansi-styles
style_italic        <- create_ansi_style("italic")
#' @export
#' @name ansi-styles
style_reset         <- create_ansi_style("reset")
#' @export
#' @name ansi-styles
style_strikethrough <- create_ansi_style("strikethrough")
#' @export
#' @name ansi-styles
style_underline     <- create_ansi_style("underline")
