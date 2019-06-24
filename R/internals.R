
#' @importFrom fansi strwrap_ctl

clii__xtext <- function(self, private, ..., .list, indent) {
  style <- private$get_style()$main
  text <- private$inline(..., .list = .list)
  text <- strwrap_ctl(text, width = private$get_width())
  if (!is.null(style$fmt)) text <- style$fmt(text)
  private$cat_ln(text, indent = indent)
  invisible(self)
}

clii__get_width <- function(self, private) {
  style <- private$get_style()$main
  left <- style$`margin-left` %||% 0
  right <- style$`margin-right` %||% 0
  console_width() - left - right
}

clii__cat <- function(self, private, lines) {
  if (private$output == "message") {
    clii__message(lines, appendLF = FALSE)
  }  else {
    cat(lines, sep = "")
  }
  private$margin <- 0
}

clii__cat_ln <- function(self, private, lines, indent) {
  if (!is.null(item <- private$state$delayed_item)) {
    private$state$delayed_item <- NULL
    return(private$item_text(item$type, NULL, item$cnt_id, .list = lines))
  }

  style <- private$get_style()$main

  ## left margin
  left <- style$`margin-left` %||% 0
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

  bar <- private$get_progress_bar()
  if (is.null(bar)) {
    if (private$output == "message") {
      clii__message(paste0(lines, "\n"), appendLF = FALSE)
    } else {
      cat(paste0(lines, "\n"), sep = "")
    }
  } else {
    msg <- paste(lines, sep = "\n")
    msg <- crayon::reset(msg)
    bar$message(msg, set_width = FALSE)
  }
}

clii__vspace <- function(self, private, n) {
  if (private$margin < n) {
    sp <- strrep("\n", n - private$margin)
    if (private$output == "message") {
      clii__message(sp, appendLF = FALSE)
    } else {
      cat(sp)
    }
    private$margin <- n
  }
}

clii__message <- function(..., domain = NULL, appendLF = TRUE) {
  msg <- .makeMessage(..., domain = domain, appendLF = appendLF)
  msg <- crayon::reset(msg)
  message(msg, appendLF = FALSE)
}
