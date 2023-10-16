render_inline_span <- function(cpt) {
  stopifnot(inherits(cpt, "cli_component"))
  style <- cpt[["attr"]][["style"]]
  val <- paste(unlist(lapply(cpt[["children"]], render)), collapse = "")

  # before, after
  before <- call_if_fun(style[["before"]])
  after <- call_if_fun(style[["after"]])
  val <- paste0(before, val, after)

  # prefix, postfix
  prefix <- call_if_fun(style[["prefix"]])
  postfix <- call_if_fun(style[["postfix"]])
  val <- paste0(prefix, val, postfix)

  # padding
  padding_left <- style[["padding-left"]] %||% 0L
  padding_right <- style[["padding-right"]] %||% 0L
  if (padding_left > 0) val <- paste0(strrep("\u00a0", padding_left), val)
  if (padding_right > 0) val <- paste0(val, strrep("\u00a0", padding_right))

  # handles backgrond-color, color, fmt, font-style, font-weight,
  # text-decoration
  formatter <- create_formatter(style)[["fmt"]]
  if (!is.null(formatter)) val <- formatter(val)

  # margins, TODO: these should be collapsing, possibly with a custom ANSi seq
  margin_left <- style[["margin-left"]] %||% 0L
  margin_right <- style[["margin-right"]] %||% 0L
  if (margin_left > 0) val <- paste0(strrep("\u00a0", margin_left), val)
  if (margin_right > 0) val <- paste0(val, strrep("\u00a0", margin_right))

  ansi_string(val)
}
