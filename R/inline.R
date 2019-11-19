
#' @importFrom utils globalVariables

if (getRversion() >= "2.15.1") globalVariables("app")

inline_generic <- function(app, class, x) {
  id <- clii__container_start(app, "span", class = class)
  on.exit(clii__container_end(app, id), add = TRUE)
  style <- app$get_current_style()
  xx <- paste0(style$before, x, style$after)
  if (!is.null(style$fmt)) xx <- vcapply(xx, style$fmt)
  inline_collapse(xx)
}

inline_collapse <- function(x) {
  glue_collapse(x, sep = ", ", last = " and ")
}

#' @importFrom glue glue glue_collapse

inline_transformer <- local({
  inline_styling <- FALSE
  function(code, envir) {
    res <- tryCatch({
      expr <- parse(text = code, keep.source = FALSE)
      eval(expr, envir = envir)
    }, error = function(e) e)
    if (!inherits(res, "error")) {
      if (inline_styling) return(res) else return(inline_collapse(res))
    }

    code <- glue_collapse(code, "\n")
    m <- regexpr("(?s)^[.]([[:alnum:]_]+)[[:space:]]+(.+)", code, perl = TRUE)
    has_match <- m != -1
    if (!has_match) stop(res)

    starts <- attr(m, "capture.start")
    ends <- starts + attr(m, "capture.length") - 1L
    captures <- substring(code, starts, ends)
    funname <- captures[[1]]
    text <- captures[[2]]

    inline_styling <<- TRUE
    on.exit(inline_styling <<- FALSE, add = TRUE)
    out <- glue(text, .envir = envir, .transformer = inline_transformer)
    inline_generic(app, funname, out)
  }
})

clii__inline <- function(app, text, .list) {
  ## Inject that app, so we can style
  assign("app", app, envir = environment(inline_transformer))
  on.exit(rm(list = "app", envir = environment(inline_transformer)), add = TRUE)
  texts <- c(if (!is.null(text)) list(text), .list)
  out <- lapply(texts, function(t) {
    glue(t$str, .envir = t$values %||% emptyenv(), .transformer = inline_transformer)
  })
  paste(out, collapse = "")
}

make_cmd_transformer <- function(values) {
  values

  function(code, envir) {
    res <- tryCatch({
      expr <- parse(text = code, keep.source = FALSE)
      eval(expr, envir = envir)
    }, error = function(e) e)

    if (!inherits(res, "error")) {
      id <- paste0("v", length(values))
      values[[id]] <- res
      return(paste0("{", id, "}"))
    }

    code <- glue_collapse(code, "\n")
    m <- regexpr("(?s)^[.]([[:alnum:]_]+)[[:space:]]+(.+)", code, perl = TRUE)
    has_match <- m != -1
    if (!has_match) stop(res)

    starts <- attr(m, "capture.start")
    ends <- starts + attr(m, "capture.length") - 1L
    captures <- substring(code, starts, ends)
    funname <- captures[[1]]
    text <- captures[[2]]

    out <- glue(text, .envir = envir, .transformer = sys.function())
    paste0("{.", funname, " ", out, "}")
  }
}

glue_cmd <- function(..., .envir) {
  str <- unlist(list(...), use.names = FALSE)
  values <- new.env(parent = emptyenv())
  transformer <- make_cmd_transformer(values)
  args <- c(str, list(.envir = .envir, .transformer = transformer))
  glue_delay(str = do.call(glue, args), values = values)
}

glue_delay <- function(str, values = NULL) {
  structure(
    list(str = str, values = values),
    class = "cli_glue_delay"
  )
}
