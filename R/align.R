
col_align <- function(text, align = c("left", "center", "right"),
                      width = max(col_nchar(text))) {

  assert_that(is.character(text))
  align <- match.arg(align)
  assert_that(is_count(width))

  if (align == "left") {
    text

  } else if (align == "center") {
    ns <- (width - col_nchar(text)) / 2
    pref <- make_space(floor(ns))
    post <- make_space(ceiling(ns))
    paste0(pref, text, post)

  } else if (align == "right") {
    nc <- col_nchar(text)
    paste0(make_space(width - nc), text)
  }
}
