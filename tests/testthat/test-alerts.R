
context("cli alerts")

setup(start_app())
teardown(stop_app())

test_that("generic", {
  cli_div(theme = list(".alert::before" = list(content = "GENERIC! ")))
  out <- capt0(cli_alert("wow"))
  expect_match(out, "GENERIC")
})

test_that("success", {
  cli_div(theme = list(".alert-success::before" = list(content = "SUCCESS! ")))
  out <- capt0(cli_alert_success("wow"))
  expect_match(out, "SUCCESS")
})

test_that("danger", {
  cli_div(theme = list(".alert-danger::before" = list(content = "DANGER! ")))
  out <- capt0(cli_alert_danger("wow"))
  expect_match(out, "DANGER")
})

test_that("warning", {
  cli_div(theme = list(".alert-warning::before" = list(content = "WARNING! ")))
  out <- capt0(cli_alert_warning("wow"))
  expect_match(out, "WARNING")
})

test_that("info", {
  cli_div(theme = list(".alert-info::before" = list(content = "INFO! ")))
  out <- capt0(cli_alert_info("wow"))
  expect_match(out, "INFO")
})
