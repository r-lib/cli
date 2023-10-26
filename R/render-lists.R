render_li <- function(
  cpt,
  width = console_width(),
  marker = symbol$bullet
) {
  if (inherits(cpt, "cli_component_tree")) {
    style <- cpt[["style"]] %||%
    cpt[["prestyle"]] %||%
    cpt[["component"]][["attr"]][["style"]]
  } else if (inherits(cpt, "cli_component")) {
    style <- cpt[["attr"]][["style"]]
  } else {
    stop("Cannot render object of class ", class(cpt)[1])
  }

  margin_left <- min(style[["margin-left"]] %||% 2L, 2L)
  style[["margin-left"]] <- margin_left
  marker <- format_list_marker(
    marker,
    width = margin_left - 1L
  )

  item_lines <- render_text_box(
    cpt[["children"]],
    width = width,
    style = style
   )

   if (length(item_lines) == 0) {
    item_lines <- marker
   } else {
     item_lines[1] <- paste0(
      marker,
      ansi_substr(item_lines[1], margin_left, nchar(item_lines[1]))
    )
   }

   margin_top <- style[["margin-top"]] %||% 0L
   margin_bottom <- style[["margin-bottom"]] %||% 0L
   c(rep("", margin_top), item_lines, rep("", margin_bottom))
}

format_list_marker <- function(marker, width) {
  if (nchar(marker, type = "width") > width) {
    marker <- ansi_strtrim(marker, width)
  }
  ansi_align(marker, width = width, align = "right")
}

render_ul <- function(cpt, width = console_width()) {
  if (inherits(cpt, "cli_component_tree")) {
    style <- cpt[["style"]] %||% cpt[["prestyle"]] %||%
    cpt[["component"]][["attr"]][["style"]]
  } else if (inherits(cpt, "cli_component")) {
    style <- cpt[["attr"]][["style"]]
  } else {
    stop("Cannot render object of class ", class(cpt)[1])
  }

  # TODO: style

  children_lines <- lapply(cpt[["children"]], render)
  unlist(children_lines)
}
