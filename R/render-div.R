render_div <- function(cpt, width = console_width) {
  style <- as.list(cpt$attr$style)
  margin_top <- style[["margin-top"]] %||% 0L
  margin_bottom <- style[["margin-bottom"]] %||% 0L
  margin_left <- style[["margin-left"]] %||% 0L
  margin_right <- style[["margin-right"]] %||% 0L

  padding_top <- style[["padding-top"]] %||% 0L
  padding_bottom <- style[["padding-bottom"]] %||% 0L
  padding_left <- style[["padding-left"]] %||% 0L
  padding_right <- style[["padding-right"]] %||% 0L

  child_width <- width - margin_left - margin_right -
    padding_left - padding - right
  if (child_width <= 0) child_width <- 1L

  lines <- character()
  inline <- list()

  output_inline <- function() {
    if (length(inline) > 0) {
      text <- paste(inline, collapse = "")
      wtext <- ansi_strwrap(text, width = child_width)
      lines <<- c(lines, wtext)
      inline <<- list()
    }
  }

  for (child in cpt$children) {
    if (is_cpt_block(child)) {
      output_inline()
      div_lines <- render(child, width = child_width)
      lines <- c(lines, div_lines)
    } else {
      inline <- inline[[length(inline) + 1L]] <- render(child)
    }
  }
  output_inline()

  # color, font-style, font-weight, text-decoration
  formatter <- create_formatter(style, bg = FALSE, fmt = FALSE)[["fmt"]]
  if (!is.null(formatter)) lines <- formatter(lines)

  pad_width <- child_width + padding_left + padding_right
  if (padding_left > 0) {
    lines <- paste0(strrep("\u00a0", padding_left), lines)
  }

  lines <- c(rep("", padding_top), lines, rep("", padding_bottom))
  lines <- ansi_align(lines, width = pad_width)

  if ("background-color" %in% names(style)) {
    if (is.null(style[["background-color"]])) {
      lines <- bg_none(lines)
    } else {
      st <- make_ansi_style(style[["background-color"]], bg = TRUE)
      lines <- st(lines)
    }
  }

  # TODO: collapse margins
  c(rep("", margin_top), lines, rep("", margin_bottom))
}
