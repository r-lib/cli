
test_that("meta", {
  expect_snapshot(
    cli::cli({
      message("This is before")
      cli_alert_info("First message")
      message("This as well")
      cli_alert_success("Success!")
    })
  )
})
