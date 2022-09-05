
vt_simulate <- function(output, width = 80L, height = 25L) {
  if (is.character(output)) {
    output <- charToRaw(paste(output, collapse = ""))
  }

  screen <- .Call(
    clic_vt_simulate,
    output,
    as.integer(width),
    as.integer(height)
  )

  for (i in seq_along(screen)) {
    screen[[i]][[1]] <- intToUtf8(screen[[i]][[1]])
  }

  screen
}
