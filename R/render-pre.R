render_pre <- function(cpt, width = console_width()) {
  if (inherits(cpt, "cli_component_tree")) {
    style <- cpt[["style"]] %||%
    cpt[["prestyle"]] %||%
    cpt[["component"]][["attr"]][["style"]]
  } else if (inherits(cpt, "cli_component")) {
    style <- cpt[["attr"]][["style"]]
  } else {
    stop("Cannot render object of class ", class(cpt)[1])
  }

  style[["white-space"]] <- style[["white-space"]] %||% "pre"

  pre_lines <- render_block(
    cpt[["children"]],
    width = width,
    style = style
  )

  pre_lines
}