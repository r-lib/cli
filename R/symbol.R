#' Various handy symbols to use in a command line UI
#'
#' @usage
#' symbol
#'
#' @format A named list, see \code{names(symbol)} for all sign names.
#'
#' @details
#'
#' On Windows they have a fallback to less fancy symbols.
#'
#' @name symbol
#' @aliases symbol
#' @export symbol
#'
#' @examples
#' cat(symbol$tick, " SUCCESS\n", symbol$cross, " FAILURE\n", sep = "")
#'
#' ## All symbols
#' cat(paste(format(names(symbol), width = 20),
#'   unlist(symbol)), sep = "\n")
NULL

symbol_utf8 <- list(
  "tick" = '\u2714',
  "cross" = '\u2716',
  "star" = '\u2605',
  "square" = '\u2587',
  "square_small" = '\u25FB',
  "square_small_filled" = '\u25FC',
  "circle" = '\u25EF',
  "circle_filled" = '\u25C9',
  "circle_dotted" = '\u25CC',
  "circle_double" = '\u25CE',
  "circle_circle" = '\u24DE',
  "circle_cross" = '\u24E7',
  "circle_pipe" = '\u24be',
  "circle_question_mark" = '?\u20DD',
  "bullet" = '\u25CF',
  "dot" = '\u2024',
  "line" = '\u2500',
  "double_line" = "\u2550",
  "ellipsis" = '\u2026',
  "continue" = '\u2026',
  "pointer" = '\u276F',
  "info" = '\u2139',
  "warning" = '\u26A0',
  "menu" = '\u2630',
  "smiley" = '\u263A',
  "mustache" = '\u0DF4',
  "heart" = '\u2665',
  "arrow_up" = '\u2191',
  "arrow_down" = '\u2193',
  "arrow_left" = '\u2190',
  "arrow_right" = '\u2192',
  "radio_on" = '\u25C9',
  "radio_off" = '\u25EF',
  "checkbox_on" = '\u2612',
  "checkbox_off" = '\u2610',
  "checkbox_circle_on" = '\u24E7',
  "checkbox_circle_off" = '\u24BE',
  "fancy_question_mark" = '\u2753',
  "neq" = "\u2260",
  "geq" = "\u2265",
  "leq" = "\u2264",
  "times" = "\u00d7",

  "upper_block_1" = "\u2594",
  "upper_block_4" = "\u2580",

  "lower_block_1" = "\u2581",
  "lower_block_2" = "\u2582",
  "lower_block_3" = "\u2583",
  "lower_block_4" = "\u2584",
  "lower_block_5" = "\u2585",
  "lower_block_6" = "\u2586",
  "lower_block_7" = "\u2587",
  "lower_block_8" = "\u2588",

  "full_block" = "\u2588",

  "sup_0" = "\u2070",
  "sup_1" = "\u00b9",
  "sup_2" = "\u00b2",
  "sup_3" = "\u00b3",
  "sup_4" = "\u2074",
  "sup_5" = "\u2075",
  "sup_6" = "\u2076",
  "sup_7" = "\u2077",
  "sup_8" = "\u2078",
  "sup_9" = "\u2079",

  "sup_minus" = "\u207b",
  "sup_plus" = "\u207a",

  "play" = "\u25b6",
  "stop" = "\u25a0",
  "record" = "\u25cf"
)

symbol_win <- list(
  "tick" = '\u221A',
  "cross" = 'x',
  "star" = '*',
  "square" = '\u2588',
  "square_small" = '[ ]',
  "square_small_filled" = '[\u2588]',
  "circle" = '( )',
  "circle_filled" = '(*)',
  "circle_dotted" = '( )',
  "circle_double" = '(o)',
  "circle_circle" = '(o)',
  "circle_cross" = '(x)',
  "circle_pipe" = '(|)',
  "circle_question_mark" = '(?)',
  "bullet" = '*',
  "dot" = '.',
  "line" = '-',
  "double_line" = "=",
  "ellipsis" = '...',
  "continue" = '~',
  "pointer" = '>',
  "info" = 'i',
  "warning" = '\u203C',
  "menu" = '\u2261',
  "smiley" = '\u263A',
  "mustache" = '\u250C\u2500\u2510',
  "heart" = '\u2665',
  "arrow_up" = '^',
  "arrow_down" = 'v',
  "arrow_left" = '<',
  "arrow_right" = '>',
  "radio_on" = '(*)',
  "radio_off" = '( )',
  "checkbox_on" = '[x]',
  "checkbox_off" = '[ ]',
  "checkbox_circle_on" = '(x)',
  "checkbox_circle_off" = '( )',
  "fancy_question_mark" = "(?)",
  "neq" = "!=",
  "geq" = ">=",
  "leq" = "<=",
  "times" = "x",

  "upper_block_1" = "^",
  "upper_block_4" = "^",

  "lower_block_1" = ".",
  "lower_block_2" = "_",
  "lower_block_3" = "_",
  "lower_block_4" = "=",
  "lower_block_5" = "=",
  "lower_block_6" = "*",
  "lower_block_7" = "\u2588",
  "lower_block_8" = "\u2588",

  "full_block" = "\u2588",

  "sup_0" = "0",
  "sup_1" = "1",
  "sup_2" = "2",
  "sup_3" = "3",
  "sup_4" = "4",
  "sup_5" = "5",
  "sup_6" = "6",
  "sup_7" = "7",
  "sup_8" = "8",
  "sup_9" = "9",

  "sup_minus" = "-",
  "sup_plus" = "+",

  "play" = ">",
  "stop" = "#",
  "record" = "o"
)

symbol_bytes <- list(
  "tick" = '\xE2\x9C\x94',
  "cross" = '\xE2\x9C\x96',
  "star" = '\xE2\x98\x85',
  "square" = '\xE2\x96\x87',
  "square_small" = '\xE2\x97\xBB',
  "square_small_filled" = '\xE2\x97\xBC',
  "circle" = '\xE2\x97\xAF',
  "circle_filled" = '\xE2\x97\x89',
  "circle_dotted" = '\xE2\x97\x8C',
  "circle_double" = '\xE2\x97\x8E',
  "circle_circle" = '\xE2\x93\x9E',
  "circle_cross" = '\xE2\x93\xA7',
  "circle_pipe" = '\xE2\x92\xBE',
  "circle_question_mark" = '\x3F\xE2\x83\x9D',
  "bullet" = '\xE2\x97\x8F',
  "dot" = '\xE2\x80\xA4',
  "line" = '\xE2\x94\x80',
  "double_line" = "\xE2\x95\x90",
  "ellipsis" = '\xE2\x80\xA6',
  "continue" = '\xE2\x80\xA6',
  "pointer" = '\xE2\x9D\xAF',
  "info" = '\xE2\x84\xB9',
  "warning" = '\xE2\x9A\xA0',
  "menu" = '\xE2\x98\xB0',
  "smiley" = '\xE2\x98\xBA',
  "mustache" = '\xE0\xB7\xB4',
  "heart" = '\xE2\x99\xA5',
  "arrow_up" = '\xE2\x86\x91',
  "arrow_down" = '\xE2\x86\x93',
  "arrow_left" = '\xE2\x86\x90',
  "arrow_right" = '\xE2\x86\x92',
  "radio_on" = '\xE2\x97\x89',
  "radio_off" = '\xE2\x97\xAF',
  "checkbox_on" = '\xE2\x98\x92',
  "checkbox_off" = '\xE2\x98\x90',
  "checkbox_circle_on" = '\xE2\x93\xA7',
  "checkbox_circle_off" = '\xE2\x92\xBE',
  "fancy_question_mark" = '\xE2\x9D\x93',
  "neq" = "\xE2\x89\xA0",
  "geq" = "\xE2\x89\xA5",
  "leq" = "\xE2\x89\xA4",
  "times" = "\xC3\x97",

  "upper_block_1" = "\xE2\x96\x94",
  "upper_block_4" = "\xE2\x96\x80",

  "lower_block_1" = "\xE2\x96\x81",
  "lower_block_2" = "\xE2\x96\x82",
  "lower_block_3" = "\xE2\x96\x83",
  "lower_block_4" = "\xE2\x96\x84",
  "lower_block_5" = "\xE2\x96\x85",
  "lower_block_6" = "\xE2\x96\x86",
  "lower_block_7" = "\xE2\x96\x87",
  "lower_block_8" = "\xE2\x96\x88",

  "full_block" = "\xE2\x96\x88",

  "sup_0" = "\xE2\x81\xB0",
  "sup_1" = "\xC2\xB9",
  "sup_2" = "\xC2\xB2",
  "sup_3" = "\xC2\xB3",
  "sup_4" = "\xE2\x81\xB4",
  "sup_5" = "\xE2\x81\xB5",
  "sup_6" = "\xE2\x81\xB6",
  "sup_7" = "\xE2\x81\xB7",
  "sup_8" = "\xE2\x81\xB8",
  "sup_9" = "\xE2\x81\xB9",

  "sup_minus" = "\xE2\x81\xBB",
  "sup_plus" = "\xE2\x81\xBA",

  "play" = "\xE2\x96\xB6",
  "stop" = "\xE2\x96\xA0",
  "record" = "\xE2\x97\x8F"
)
