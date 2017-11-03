
context("spinners")

test_that("get_spinner", {
  if (fancy_boxes()) {
    expect_equal(get_spinner()$name, "dots")
  } else {
    expect_equal(get_spinner()$name, "line")
  }
})

test_that("list_spinners", {
  ls <- list_spinners()
  expect_true(is.character(ls))
  expect_true("dots" %in% ls)
  expect_true("line" %in% ls)
})
