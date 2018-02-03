
#' @importFrom glue glue

inline_list <- NULL

#' @importFrom utils globalVariables

if (getRversion() >= "2.15.1") globalVariables(c("self", "private"))

inline_generic <- function(self, private, class, x) {
  cli__container_start(self, private, "span", .auto_close = TRUE,
                       .envir = environment(), class = class)
  style <- private$get_style()
  xx <- paste0(style$before$content, x, style$after$content)
  if (!is.null(style$main$fmt)) xx <- style$main$fmt(xx)
  xx
}

#' @importFrom glue collapse

inline_transformer <- function(code, envir) {
  res <- tryCatch(
    parse(text = code, keep.source = FALSE),
    error = function(e) e
  )
  if (!inherits(res, "error")) return(eval(res, envir = envir))

  code <- collapse(code, "\n")
  m <- regexpr("(?s)^([[:alnum:]_]+)[[:space:]]+(.+)", code, perl = TRUE)
  has_match <- m != -1
  if (!has_match) stop(res)

  starts <- attr(m, "capture.start")
  ends <- starts + attr(m, "capture.length") - 1L
  captures <- substring(code, starts, ends)
  funname <- captures[[1]]
  text <- captures[[2]]
  out <- glue(text, .envir = envir, .transformer = inline_transformer)
  inline_generic(self, private, funname, out)
}

cli__inline <- function(self, private, ..., .envir) {
  ## This makes a copy that can refer to self and private
  environment(inline_transformer) <- environment()
  glue(..., .envir = .envir, .transformer = inline_transformer)
}
