
context("box styles")

test_that("list_border_styles", {
  expect_silent(bs <- list_border_styles())
  expect_true(is.character(bs))
  expect_true(!any(is.na(bs)))
  expect_true(length(bs) > 0)
})
