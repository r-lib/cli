
ESC <- "\u001b["
OSC <- "\u001b]"
BEL <- "\u0007"
SEP <- ";"

is_int <- function(x) {
  is.numeric(x) && length(x) == 1 && !is.na(x) && x >= -Inf && x < Inf &&
    isTRUE(as.integer(x) == x)
}

is_count <- function(x) {
  is_int(x) && x >= 1L
}

is_count0 <- function(x) {
  is_int(x) && x >= 0L
}

is_apply_terminal <- local({
  isit <- NULL
  function() {
    if (is.null(isit)) {
      isit <<- Sys.getenv("TERM_PROGRAM", "") ==  "Apple_Terminal"
    }
    isit
  }
})

#' @export

ansi <- list()

ansi$cursor_to <- function(x, y = NULL) {
  assert_that(
    is_count(x),
    is_count(y) || is.null(y))

  if (is.null(y)) {
    paste0(ESC, x, "G")
  } else {
    paste0(ESC, y, ";", x, "H")
  }
}

ansi$cursor_move <- function(x, y = NULL) {
  assert_that(
    is_int(x),
    is_int(y) || is.null(y))

  paste0(
    if (x < 0) paste0(-x, "D"),
    if (x > 0) paste0( x, "C"),
    if (y < 0) paste0(-y, "A"),
    if (y > 0) paste0( y, "B")
  )
}

ansi$cursor_up <- function(count = 1L) {
  assert_that(is_count0(count))
  paste0(ESC, count, "A")
}

ansi$cursor_down <- function(count = 1L) {
  assert_that(is_count0(count))
  paste0(ESC, count, "B")
}

ansi$cursor_forward <- function(count = 1L) {
  assert_that(is_count0(count))
  paste0(ESC, count, "C")
}

ansi$cursor_backward <- function(count = 1L) {
  assert_that(is_count0(count))
  paste0(ESC, count, "D")
}

ansi$cursor_left <- function() paste0(ESC, "G")

ansi$cursor_save_position <- function() {
  paste0(ESC, if (is_apple_terminal()) "7" else "s")
}

ansi$cursor_restore_position <- function() {
  paste0(ESC, if (is_apple_terminal()) "8" else "u")
}

ansi$cursor_get_position <-  function() paste0(ESC, "6n")

ansi$cursor_next_line <- function() paste0(ESC, "E")
ansi$cursor_prev_line <- function() paste0(ESC,  "F")

ansi$cursor_hide <- function() paste0(ESC, "?25l")
ansi$cursor_show <- function() paste0(ESC, "?25h")

ansi$erase_lines <- function(count) {
  assert_that(is_count0(count))
  if (count == 0) return("")

  paste0(
    rep(paste0(ansi$erase_line(), ansi$cursor_up()), count - 1),
    ansi$cursor_left()
  )
}

ansi$erase_end_line <- function() paste0(ESC, "K")
ansi$erase_start_line <- function() paste0(ESC, "1K")
ansi$erase_line <- function() paste0(ESC , "2K")
ansi$erase_down <- function() paste0(ESC, "J")
ansi$erase_up <- function() paste0(ESC,  "1J")
ansi$erase_screen <- function() paste0(ESC, "2J")

ansi$scroll_up <- function() paste0(ESC, "S")
ansi$scroll_down <- function() paste0(ESC, "T")

ansi$clear_screen <- function() "\u001Bc"
ansi$beep <- function() BEL

ansi$link <- function(text, url, stream = stderr()) {
  assert_that(
    is_string(text),
    is_string(url))

  if (supports_hyperlinks(stream)) {
    paste0(OSC, "8", SEP, SEP, url, BEL, text, OSC, "8", SEP, SEP, BEL)
  } else {
    paste0(text, " (", url, ")")
  }
}

#' @importFrom  base64enc base64encode

ansi$image <- function(buf, width = NULL, height = NULL, keep_asp = TRUE) {
  assert_that(
    is.raw(buf),
    is.null(width) || is_count(width),
    is.null(height) || is_count(height),
    is_flag(keep_asp))

  paste0(
    OSC, "1337;File=inline=1",
    if (!is.null(width)) paste0(";width=", width),
    if (!is.null(height)) paste0(";height=", height),
    if (!keep_asp) ";preserveAspectRation=0",
    ":", base64encode(buf), BEL
  )
}

ansi$iterm <- list()

ansi$iterm$set_wd <- function(wd = getwd()) {
  paste0(OSC,  "50;CurrentDir=", wd, BEL)
}
