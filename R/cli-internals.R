
cli__cat <- function(self, private, lines, sep) {
  cat(lines, file = private$stream, sep = sep)
}
