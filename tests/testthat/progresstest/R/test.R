
#' @useDynLib progresstest, .registration = TRUE, .fixes = "c_"
NULL

#' @export

test0 <- function() {
  this <- "test0"
  .Call(c_test0)
}

#' @export

test1 <- function() {
  this <- "test1"
  .Call(c_test1)
}

#' @export

test2 <- function() {
  this <- "test2"
  .Call(c_test2)
}

test3 <- function() {
  this <- "test3"
  test2()
}
