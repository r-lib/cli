
#' @useDynLib progresstest, .registration = TRUE, .fixes = "c_"
NULL

#' @export

test0 <- function() {
  this <- "test0"
  .Call(c_test0)
}

#' @export

test00 <- function(progress = FALSE) {
  this <- "test0"
  .Call(c_test00, progress)
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

#' @export

testx <- function() {
  this <- "testx"
  .Call(c_testx)
}

test3 <- function() {
  this <- "test3"
  test2()
}

call_with_cleanup <- function(ptr, ...) {
  .Call(c_cleancall_call, pairlist(ptr, ...), parent.frame())
}

testc <- function() {
  this <- "testc"
  call_with_cleanup(c_testc)
}
