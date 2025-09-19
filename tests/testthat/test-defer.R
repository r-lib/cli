test_that("errors", {
  fun <- function() {
    defer(1 + "")
  }

  expect_snapshot(
    error = TRUE,
    fun()
  )
})
