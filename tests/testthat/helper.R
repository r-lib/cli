
rule_class <- function(x) {
  structure(x, class = c("rule", "ansi_string", "character"))
}

test_that_cli <- function(desc, code, configs = NULL) {
  code <- substitute(code)

  doconfigs <- list(
    list(id = "plain",   unicode = FALSE, num_colors =   1, locale = NULL),
    list(id = "ansi",    unicode = FALSE, num_colors = 256, locale = NULL),
    list(id = "unicode", unicode = TRUE,  num_colors =   1, locale = NULL),
    list(id = "fancy",   unicode = TRUE,  num_colors = 256, locale = NULL)
  )

  lapply(doconfigs, function(conf) {
    if (!is.null(configs) && ! conf$id %in% configs) return()
    code2 <- substitute({
      testthat::local_reproducible_output(
        crayon = num_colors > 1,
        unicode = unicode
      )
      code_
    }, c(conf, list(code_ = code)))
    desc2 <- paste0(desc, " [", conf$id, "]")
    test <- substitute(
      test_that(desc, code),
      list(desc = desc2, code = code2)
    )
    eval(test)
  })
}

capture_messages <- function(expr) {
  msgs <- character()
  i <- 0
  suppressMessages(withCallingHandlers(
    expr,
    message = function(e) msgs[[i <<- i + 1]] <<- conditionMessage(e)))
  paste0(msgs, collapse = "")
}

capt <- function(expr, print_it = TRUE) {
  pr <- if (print_it) print else identity
  paste(capture.output(pr(expr)), collapse = "\n")
}

capt0 <- function(expr, strip_style = FALSE) {
  out <- capture_messages(expr)
  if  (strip_style) ansi_strip(out) else out
}

local_cli_config <- function(unicode = FALSE, dynamic = FALSE,
                             ansi = FALSE, num_colors = 1,
                             .local_envir = parent.frame()) {
  withr::local_options(
    cli.dynamic = dynamic,
    cli.ansi = ansi,
    cli.unicode = unicode,
    crayon.enabled = num_colors > 1,
    crayon.colors = num_colors,
    .local_envir = .local_envir
  )
  withr::local_envvar(
    PKG_OMIT_TIMES = "true",
    PKG_OMIT_SIZES = "true",
    .local_envir = .local_envir
  )
}

test_style <- function() {
  list(
    ".testcli h1" = list(
      "font-weight" = "bold",
      "font-style" = "italic",
      "margin-top" = 1,
      "margin-bottom" = 1),
    ".testcli h2" = list(
      "font-weight" = "bold",
      "margin-top" = 1,
      "margin-bottom" = 1),
    ".testcli h3" = list(
      "text-decoration" = "underline",
      "margin-top" = 1)
  )
}
