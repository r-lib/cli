
rule_class <- function(x) {
  structure(x, class = c("rule", "ansi_string", "character"))
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

# to work around https://github.com/r-lib/withr/issues/167
local_rng_version <- function(version, .local_envir = parent.frame()) {
  withr::defer(RNGversion(getRversion()), envir = .local_envir)
  suppressWarnings(RNGversion(version))
}
