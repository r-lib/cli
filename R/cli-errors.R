
cli_error <- function(..., .data = NULL, .envir = parent.frame()) {
  cnd <- new_error(
    format_error(
      .envir = .envir,
      c(
        ...
      )
    )
  )

  if (length(.data)) cnd[names(.data)] <- .data

  cnd
}

stop_if_not <- function(message, ..., .envir = parent.frame(),
                        call. = sys.call(-1)) {
  conds <- list(...)
  for (cond in conds) {
    if (!cond) {
      throw(
        new_error(format_error(.envir = .envir, message), call. = call.),
        frame = .envir
      )
    }
  }
}
