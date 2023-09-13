
#' @export

format_cpt <- function(cpt) {
  
  format_cpt_internal(cpt)
}

format_cpt_internal <- function(cpt, doc) {
  switch(
    cpt$tag,
    "doc" = ,
    "div" = format_cpt_div(cpt, doc),
    "span" = format_cpt_span(cpt, doc),
    "text" = format_cpt_text(cpt, doc),
    warning("\"", cpt$tag, "\" is not implemented yet")
  )
}

format_cpt_div <- function(cpt, doc) {
  doc$start_tag
  unlist(lapply(cpt$children, format_cpt_internal, doc = doc))
  
}

format_cpt_span <- function(cpt, doc) {

}

format_cpt_text <- function(cpt, doc) {

}
