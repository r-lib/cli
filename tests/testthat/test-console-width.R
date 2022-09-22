
test_that("errors", {
  withr::local_options(cli.width = letters)
  expect_snapshot_error(
    console_width()
  )

  withr::local_options(cli.width = NA_integer_)
  expect_snapshot_error(
    console_width()
  )

  withr::local_options(cli.width = -100L)
  expect_snapshot_error(
    console_width()
  )

  mockery::stub(tty_size, ".Call", function(...) stop("failed :("))
  expect_snapshot(
    error = TRUE,
    tty_size(),
    transform = sanitize_srcref
  )
})
