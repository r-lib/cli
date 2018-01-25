
cli__get_width <- function(self, private) {
  style <- tail(private$state, 1)[[1]]$style
  left <- style$left %||% 0
  right <- style$right %||% 0
  console_width() - left - right
}

cli__cat <- function(self, private, lines, sep) {
  cat(lines, file = private$stream, sep = sep)
  private$margin <- 0
}

cli__cat_ln <- function(self, private, lines) {
  style <- tail(private$state, 1)[[1]]$style
  left <- style$left %||% 0
  if (length(lines) && left) lines <- paste0(strrep(" ", left), lines)
  private$margin <- 0
  cat(lines, file = private$stream, sep = "\n")
}

cli__vspace <- function(self, private, n) {
  if (private$margin < n) {
    cat(strrep("\n", n - private$margin), sep = "")
    private$margin <- n
  }
}
