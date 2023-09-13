
#' @export

render_cpt <- function(cpt) {
  if (is_cpt_block(cpt)) {
    render_cpt_block(cpt)
  } else {
    render_cpt_inline(cpt)
  }
}

prerender_cpt <- function(cpt) {
  if (is_cpt_block(cpt)) {
    prerender_cpt_block(cpt)
  } else {
    prerender_cpt_inline(cpt)
  }
}

render_cpt_block <- function(cpt) {
  blocks <- prerender_cpt_block(cpt)
  render_prerendered_blocks(blocks)
}

render_prerendered_blocks <- function(blocks) {
  # TODO
  print(blocks)
}

render_cpt_inline <- function(cpt) {
  if (!is_cpt_inline(cpt)) stop("Not an inline element: ", cpt[["tag"]])

  switch(
    cpt[["tag"]],
    "span" = {
      style <- cpt[["attr"]][["style"]]
      render_text_with_style(cpt$str, style)
    },
    "text" = cpt$str
  )
}

render_text_with_style <- function(text, style) {

}

prerender_cpt_inline <- function(cpt) {
  list(
    type = "inline",
    contents = render_cpt_inline(cpt)
  )
}

prerender_cpt_block <- function(cpt) {
  if (!is_cpt_block(cpt)) stop("Not a block element: ", cpt[["tag"]])

  style <- cpt[["attr"]][["style"]]

  list(
    type = "block",
    margins = c(
      style[["margin-top"]] %||% 0 + style[["padding-top"]] %||% 0,
      style[["margin-right"]] %||% 0 + style[["padding-right"]] %||% 0,
      style[["margin-bottom"]] %||% 0 + style[["padding-bottom"]] %||% 0,
      style[["margin-left"]] %||% 0 + style[["padding-left"]] %||% 0
    ),
    contents = lapply(cpt[["children"]], prerender_cpt)
  )
}
