
#' @export

tick_along <- function(x,
                       name = NULL,
                       total = length(x),
                       ...,
                       .envir = parent.frame()) {

  name; total; .envir; list(...)

  if (getRversion() < "3.5.0") return(seq_along(x))
  id <- cli_progress_bar(name = name, total = total, ..., .envir = .envir)
  sax <- seq_along(x)
  clienv$progress[[id]]$caller <- .envir
  ta <- structure(
    .Call(clic_tick_along, sax, clienv$progress[[id]]),
    class = "cli_tick_along",
    length = length(sax)
  )
  ta
}

#' @export

format.cli_tick_along <- function(x, ...) {
  paste0("<cli tick_along() of length ", attr(x, "length"), ">")
}

#' @export

print.cli_tick_along <- function(x, ...) {
  cat(format(x, ...), sep = "\n")
}

#' @export

as.list.cli_tick_along <- function(x, ...) {
  x
}
