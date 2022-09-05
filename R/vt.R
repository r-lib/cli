
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

  vapply(screen, intToUtf8, character(1))
}
