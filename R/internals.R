
clii__xtext <- function(app, text, .list, indent, padding) {
  style <- app$get_current_style()
  text <- app$inline(text, .list = .list)
  text <- strwrap_fixed(text, width = app$get_width(extra = padding))

  text[1] <- paste0(style$before, text[1])
  text[length(text)] <- paste0(text[length(text)], style$after)

  if (!is.null(style$fmt)) text <- style$fmt(text)
  app$cat_ln(text, indent = indent, padding)
  invisible(app)
}

clii__get_width <- function(app, extra) {
  style <- app$get_current_style()
  left <- style$`margin-left` %||% 0 + style$`padding-left` %||% 0
  right <- style$`margin-right` %||% 0 + style$`padding-right` %||% 0
  console_width() - left - right - extra
}

clii__cat <- function(app, lines) {
  clii__message(lines, appendLF = FALSE, output = app$output)
}

clii__cat_ln <- function(app, lines, indent, padding) {
  if (!is.null(item <- app$state$delayed_item)) {
    app$state$delayed_item <- NULL
    return(app$item_text(item$type, NULL, item$cnt_id, .list = lines))
  }

  style <- app$get_current_style()

  ## left margin
  left <- padding + style$`margin-left` %||% 0 + style$`padding-left` %||% 0
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

  if (length(app$status_bar)) clii__clear_status_bar(app)
  app$cat(paste0(paste0(lines, "\n"), collapse = ""))
  if (length(app$status_bar)) app$cat(paste0(app$status_bar[[1]]$content))
}

clii__vspace <- function(app, n) {
  if (app$margin < n) {
    sp <- strrep("\n", n - app$margin)
    clii__message(sp, appendLF = FALSE, output = app$output)
    app$margin <- n
  }
}

get_real_output <- function(output) {
  if (! inherits(output, "connection")) {
    output <- switch(
      output,
      "auto" = cli_output_connection(),
      "message" = ,
      "stderr" = stderr(),
      "stdout" = stdout()
    )
  }
  output
}

clii__message <- function(..., domain = NULL, appendLF = TRUE,
                          output = stderr()) {

  msg <- .makeMessage(..., domain = domain, appendLF = appendLF)
  output <- get_real_output(output)

  withRestarts(muffleMessage = function() NULL, {
    signalCondition(simpleMessage(msg))
    cat(msg, file = output, sep = "")
  })
}
