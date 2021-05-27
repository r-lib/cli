
#' @export

should_tick <- function() {
  .Call(clic_should_tick)
}

#' `cli_tick_reset()` resets the cli status bar timer after an update
#'
#' @export
#' @rdname should_tick

cli_tick_reset <- function() {
  .Call(clic_tick_reset)
}

#' @export
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
