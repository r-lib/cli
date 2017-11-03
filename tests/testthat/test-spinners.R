
context("spinners")

test_that("list_spinners", {
  if (fancy_boxes()) {
    expect_equal(get_spinner()$name, "dots")
  } else {
    expect_equal(get_spinner()$name, "line")
  }
})
