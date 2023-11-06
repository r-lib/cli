#' @export

# TODO: nms == "" must be handled specially, because it's not supposed
# to have a left margin. So we need to create two lists, with the same
# marker width, probably.

cpt_bullets <- function(
  text,
  class = NULL,
  style = NULL,
  attr = NULL,
  .envir = parent.frame()
) {
  nms <- names(text) %||% character()
  items <- vector(length(text), mode = "list")
  for (i in seq_along(text)) {
    blt_style <- bullet_name_to_style(nms[i])
    if (inherits(text[[i]], "cli_component_li")) {
      items[[i]] <- text[[i]]
      if (is.null(cpt_get_style("list-style-type"))) {
        cpt_add_style(items[[i]], blt_style)
      }

    } else if (inherits(text[[i]], "cli_component")) {
      items[[i]] <- cpt_li(text[[i]], style = blt_style)

    } else if (is.character(text[[i]])) {
      items[[i]] <- cpt_li(
        cpt_txt(text[[i]], .envir = .envir),
        style = blt_style
      )

    } else {
      stop("`text` must contain components or strings in `cpt_bullets()`")
    }
  }

  cpt_ul(items, class = class, style = style, attr = attr)
}

#' @rdname cpt_bullets
#' @export
bullets <- cpt_bullets

bullet_name_to_style <- function(nm) {
  if (is.na(nm)) nm <- ""
  if (nm %in% c("", " ", "v", "x", "!", "i", "*", ">")) {
    list("list-style-type" = paste0("bullet:", nm))
  } else {
    list("list-style-type" = nm)
  }
}
