
cli__xtext <- function(self, private, ..., .envir, indent) {
  text <- private$inline(..., .envir = .envir)
  text <- ansi_strwrap(text, width = private$get_width())
  private$cat_ln(text, indent = indent)
  invisible(self)
}

cli__get_width <- function(self, private) {
  style <- private$get_style()
  left <- style$left %||% 0
  right <- style$right %||% 0
  console_width() - left - right
}

cli__cat <- function(self, private, lines, sep) {
  cat(lines, file = private$stream, sep = sep)
  private$margin <- 0
}

cli__cat_ln <- function(self, private, lines, indent) {
  style <- private$get_style()

  ## left margin
  left <- style$left %||% 0
  if (length(lines) && left) lines <- paste0(strrep(" ", left), lines)

  ## indent or negative indent
  if (length(lines)) {
    if (indent < 0) {
      lines[1] <- dedent(lines[1], - indent)
    } else if (indent > 0) {
      lines[1] <- paste0(strrep(" ", indent), lines[1])
    }
  }

  ## zero out margin
  private$margin <- 0

  cat(lines, file = private$stream, sep = "\n")
}

cli__vspace <- function(self, private, n) {
  if (private$margin < n) {
    cat(strrep("\n", n - private$margin), sep = "")
    private$margin <- n
  }
}
