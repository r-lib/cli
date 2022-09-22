
test_that("stop_app() errors", {
  expect_snapshot(
    error = TRUE,
    stop_app(1:10)
  )
})
