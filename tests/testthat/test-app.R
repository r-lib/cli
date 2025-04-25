test_that("stop_app() errors", {
  expect_snapshot(
    error = TRUE,
    stop_app(1:10)
  )
})

test_that("warning if inactive app", {
  app <- start_app(.auto_close = FALSE)
  stop_app(app)
  expect_snapshot(
    stop_app(app)
  )
})
