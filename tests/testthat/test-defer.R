test_that("errors", {
  skip_if_no_srcrefs()
  fun <- function() {
    defer(1 + "")
  }

  expect_snapshot(
    error = TRUE,
    fun()
  )
})
