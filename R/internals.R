
#' @importFrom fansi strwrap_ctl

clii__xtext <- function(app, text, .list, indent) {
  style <- app$get_current_style()
  text <- app$inline(text, .list = .list)
  text <- strwrap_ctl(text, width = app$get_width())
  if (!is.null(style$fmt)) text <- style$fmt(text)
  app$cat_ln(text, indent = indent)
  invisible(app)
}

clii__get_width <- function(app) {
  style <- app$get_current_style()
  left <- style$`margin-left` %||% 0
  right <- style$`margin-right` %||% 0
  console_width() - left - right
}

clii__cat <- function(app, lines) {
  if (app$output == "message") {
    clii__message(lines, appendLF = FALSE)
  } else {
    cat(lines, sep = "")
  }
}

clii__cat_ln <- function(app, lines, indent) {
  if (!is.null(item <- app$state$delayed_item)) {
    app$state$delayed_item <- NULL
    return(app$item_text(item$type, NULL, item$cnt_id, .list = lines))
  }

  style <- app$get_current_style()

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
  app$margin <- 0

  bar <- app$get_progress_bar()
  if (is.null(bar)) {
    if (length(app$status_bar)) clii__clear_status_bar(app)
    app$cat(paste0(paste0(lines, "\n"), collapse = ""))
    if (length(app$status_bar)) app$cat(paste0(app$status_bar[[1]]$content))

  } else {
    msg <- paste(lines, sep = "\n")
    msg <- crayon::reset(msg)
    bar$message(msg, set_width = FALSE)
  }
}

clii__vspace <- function(app, n) {
  if (app$margin < n) {
    sp <- strrep("\n", n - app$margin)
    if (app$output == "message") {
      clii__message(sp, appendLF = FALSE)
    } else {
      cat(sp)
    }
    app$margin <- n
  }
}

clii__message <- function(..., domain = NULL, appendLF = TRUE) {
  msg <- .makeMessage(..., domain = domain, appendLF = appendLF)
  msg <- crayon::reset(msg)
  message(msg, appendLF = FALSE)
}
