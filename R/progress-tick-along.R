
#' @export

tick_along <- function(x,
                       name = NULL,
                       total = length(x),
                       ...,
                       .envir = parent.frame()) {
  if (getRversion() < "3.5.0") return(seq_along(x))
  id <- cli_progress_bar(name = name, total = total, ..., .envir = .envir)
  .Call(clic_tick_along, x, clienv$progress[[id]])
}
