
context("utils")

test_that("make_space", {
  expect_equal(make_space(0), "")
  expect_equal(make_space(1), " ")
  expect_equal(make_space(5), "     ")
})
