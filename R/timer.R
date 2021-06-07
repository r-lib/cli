
#' The cli timer
#'
#' @description
#' cli includes a timer that is alerted periodically. When the the
#' timer is alerted, the `should_tick` variable is set to `TRUE`.
#'
#' `cli_tick_reset()` resets it to `FALSE`.
#'
#' `ccli_tick_reset` can be used in `.Call()` and it is marginally faster
#' than calling `cli_tick_reset().
#'
#' By default the timer is alerted every `r cli:::cli_timer_interactive`
#' milliseconds in interactive sessions and every
#' `r cli:::cli_timer_non_interactive` milliseconds in non-interactive
#' sessions.
#'
#' @format NULL
#' @return `should_tick` is a logical scalar on R vesions 3.6.0 and later,
#' it is an integer scalar with values 0L or 1L on R 3.5.x. It is a logical
#' scalar on older r vresions.
#'
#' `cli_tick_reset()` returns `NULL`.
#'
#' @export
should_tick <- FALSE

#' `cli_tick_reset()` resets the cli status bar timer after an update
#'
#' @export
#' @rdname should_tick

cli_tick_reset <- function() {
  .Call(clic_tick_reset)
}

#' @export
#' @format NULL
#' @rdname should_tick

ccli_tick_reset <- NULL

cli_tick_set <- function(tick_time = NULL, speed_time = NULL) {
  tick_time <- tick_time %||% clienv$tick_time
  speed_time <- speed_time %||% clienv$speed_time

  clienv$speed_time <- as.double(speed_time)
  clienv$tick_time <- as.integer(tick_time)
  .Call(clic_tick_set, clienv$tick_time, clienv$speed_time)
  invisible()
}
