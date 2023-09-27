
#' @export

render_cpt <- function(cpt, width = console_width()) {
  lot <- lay_out(cpt, width = width)
  render_layout(lot)
}

render_layout <- function(lot) {
  current_margin <- 0L

  lot
}

new_queue <- function() {
  queue <- new.env(parent = emptyenv())
  queue[["length"]] <- 0L
  queue
}

queue_add_text <- function(queue) {
  queue[["block"]]$text <- paste0(queue[["block"]], cpt$data$str)
}

queue_add_block <- function(queue) {
  n <- queue[["length"]]
  queue[[paste0(n)]] <- queue[["block"]]
}

lay_out <- function(cpt, width = console_width()) {
  queue <- new.queue()
  lay_out_internal(cpt, width = width, queue = queue)
  queue_add_block(queue)
  queue
}

lay_out_internal <- function(cpt, width, queue) {
  if (cpt[["tag"]] == "text") {

  } else if (cpt[["tag"]] == "span") {
    style <- cpt[["attr"]][["style"]]
    list(
      contents = lapply(cpt[["children"]], lay_out)
    )
  } else {
    style <- cpt[["attr"]][["style"]]
    list(
      margins = c(
        style[["margin-top"]] %||% 0 + style[["padding-top"]] %||% 0,
        style[["margin-right"]] %||% 0 + style[["padding-right"]] %||% 0,
        style[["margin-bottom"]] %||% 0 + style[["padding-bottom"]] %||% 0,
        style[["margin-left"]] %||% 0 + style[["padding-left"]] %||% 0
      ),
      contents = lapply(cpt[["children"]], lay_out)
    )
  }
}
