context("test-cat.R")

test_that("cat_line appends to file", {
  tmp <- tempfile()
  cat_line("a", file = tmp)
  cat_line("b", file = tmp)
  expect_equal(readLines(tmp), c("a", "b"))
})
