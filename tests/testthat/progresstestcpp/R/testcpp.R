#' @useDynLib progresstestcpp, .registration = TRUE
NULL

#' @export

test_baseline <- function() {
  test_baseline_()
}

#' @export

test_cli <- function() {
  test_cli_()
}

#' @export

test_template <- function() {
  test_template_()
}
