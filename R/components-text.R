
#' @export

cpt_text <- function(txt, .envir = parent.frame()) {
  new_component(
    "text",
    data = parse_cli_text(txt, .envir = .envir, .call = call)
  )
}

# Create a <span> for inline styles, with the proper class.
# The span needs to have a text coponent, because only text coponents
# are allowed to contain plain text.

cpt_text_inline <- function(txt, envir, transformer, funname) {
  embtxt <- new_component(
    "text",
    data = parse_cli_text_internal(txt, envir, transformer)
  )
  cpt_span(embtxt, attr = list(class = funname))
}

parse_cli_text <- function(txt, .envir, .call = sys.call(-1)) {
  transformer <- make_text_transformer(.call = .call)
  res <- parse_cli_text_internal(txt, .envir, transformer)
  if (attr(transformer, "values")$postprocess) {
    res$pieces <- post_process_plurals2(res$pieces)
  }
  res
}

parse_cli_text_internal <- function(txt, envir, transformer) {
  pieces <- glue2(
    txt,
    .envir = envir,
    .transformer = transformer,
    .cli = TRUE,
    .trim = FALSE
  )
  list(pieces = pieces)
}

make_text_transformer <- function(.call) {
  values <- new.env(parent = emptyenv())
  values$qty <- NA_integer_
  values$postprocess <- FALSE

  # These are common because of purrr's default argument names, so we
  # hardcode them es exceptions. They are in packages
  # crossmap, crosstable, rstudio.prefs, rxode2, starter.
  # rxode2 has the other ones, and we should fix that in rxode2
  # the function calls are in the oolong packagee, need to fix this as well.
  exceptions <- c(
    ".x", ".y", ".",
    ".md", ".met", ".med", ".mul", ".muR", ".dir", ".muU",
    ".sym_flip(bool_word)", ".sym_flip(bool_topic)", ".sym_flip(bool_wsi)"
  )

  # it is not easy to do better than this, we would need to pass a call
  # down from the exported functions
  caller <- .call %||% sys.call(-1)

  tr <- function(code, envir) {
    first_char <- substr(code, 1, 1)

    if (first_char == "?") {
      # {?} pluralization
      qty <- make_quantity(values$qty)
      if (!is.na(qty)) {
        process_plural(qty, code)
      } else {
        values$postprocess <- TRUE
        structure(list(code = code), class = "cli_plural_marker")
      }

    } else if (first_char == "." && !code %in% exceptions) {
      # {.} cli style
      m <- regexpr(inline_regex(), code, perl = TRUE)
      has_match <- m != -1
      if (!has_match) {
        throw(cli_error(
          call. = caller,
          "Invalid cli literal: {.code {{{abbrev(code, 10)}}}} starts with a dot.",
          "i" = "Interpreted literals must not start with a dot in cli >= 3.4.0.",
          "i" = paste("{.code {{}}} expressions starting with a dot are",
                      "now only used for cli styles."),
          "i" = paste("To avoid this error, put a space character after",
                      "the starting {.code {'{'}} or use parentheses:",
                      "{.code {{({abbrev(code, 10)})}}}.")
        ))
      }

      starts <- attr(m, "capture.start")
      ends <- starts + attr(m, "capture.length") - 1L
      captures <- substring(code, starts, ends)
      funname <- captures[[1]]
      text <- captures[[2]]

      cpt_text_inline(text, envir, sys.function(), funname)

    } else {
      # {} plain substitution
      expr <- parse(text = code, keep.source = FALSE) %??%
        cli_error(
          call. = caller,
          "Could not parse cli {.code {{}}} expression:
           {.code {abbrev(code, 20)}}."
        )
      res <- eval(expr, envir = envir) %??%
        cli_error(
          call. = caller,
          "Could not evaluate cli {.code {{}}} expression:
           {.code {abbrev(code, 20)}}."
        )

      values$qty <- if (length(res) == 0) 0 else res
      structure(list(value = res, code = code), class = "cli_sub")
    }
  }

  attr(tr, "values") <- values
  tr
}

#' @export

format.cli_component_text <- function(x, ...) {
  c("<text>",
    paste0("  ", unlist(lapply(x$data$pieces, function(x) {
      if (is.character(x)) {
        paste0("txt: ", substr(x, 1, 20), if (nchar(x) > 20) "...")
      } else if (inherits(x, "cli_sub")) {
        paste0("sub: ", x$code)
      } else if (inherits(x, "cli_component")) {
        class <- x[["attr"]][["class"]]
        class <- class %&&% paste0(" class=\"", class, "\"")
        c(paste0("<", x[["tag"]], class, ">"),
          paste0("  ", unlist(lapply(x[["children"]], format))),
          paste0("</", x[["tag"]], ">")
          )
      } else {
        stop("Internal error, invalie text piece found: ", class(text))
      }
    }))),
    "</text>"
  )
}
