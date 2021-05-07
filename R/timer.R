
#' Whether it is time to update the cli status bar
#'
#' TODO
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
#' @rdname should_tick

ccli_tick_reset <- NULL
