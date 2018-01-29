
#' @importFrom glue glue

inline_list <- NULL

#' @importFrom utils globalVariables

if (getRversion() >= "2.15.1") globalVariables(c("self", "private"))

create_inline_list <- function() {
  list(
    code = inline_code,
    emph = inline_emph,
    strong = inline_strong,
    pkg = inline_pkg,
    fun = inline_fun,
    arg = inline_arg,
    key = inline_key,
    file = inline_file,
    email = inline_email,
    url = inline_url,
    var = inline_var,
    envvar = inline_envvar
  )
}

inline_generic <- function(x, self, private, tag = "span", class = NA) {
  cli__container_start(self, private, tag, .auto_close = TRUE,
                       .envir = environment(), class = class)
  style <- private$get_style()
  xx <- paste0(style$before, x, style$after)
  if (!is.null(style$fmt)) xx <- style$fmt(xx)
  xx
}

inline_code <- function(x, self, private) {
  inline_generic(x, self, private, tag = "code")
}

inline_emph <- function(x, self, private) {
  inline_generic(x, self, private, tag = "emph")
}

inline_strong <- function(x, self, private) {
  inline_generic(x, self, private, tag = "strong")
}

inline_pkg <- function(x, self, private) {
  inline_generic(x, self, private, class = "pkg")
}

inline_fun <- function(x, self, private) {
  inline_generic(x, self, private, class = "fun")
}

inline_arg <- function(x, self, private) {
  inline_generic(x, self, private, class = "arg")
}

inline_key <- function(x, self, private) {
  inline_generic(x, self, private, class = "key")
}

inline_file <- function(x, self, private) {
  inline_generic(x, self, private, class = "file")
}

inline_email <- function(x, self, private) {
  inline_generic(x, self, private, class = "email")
}

inline_url <- function(x, self, private) {
  inline_generic(x, self, private, class = "url")
}

inline_var <- function(x, self, private) {
  inline_generic(x, self, private, class = "var")
}

inline_envvar <- function(x, self, private) {
  inline_generic(x, self, private, class = "envvar")
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
  fun <- inline_list[[funname]] %||% get(funname, envir = envir)
  fun(out, self, private)
}

cli__inline <- function(self, private, ..., .envir) {
  ## This makes a copy that can refer to self and private
  environment(inline_transformer) <- environment()
  glue(..., .envir = .envir, .transformer = inline_transformer)
}
