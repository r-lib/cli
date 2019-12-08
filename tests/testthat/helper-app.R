
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
  if  (strip_style) crayon::strip_style(out) else out
}
