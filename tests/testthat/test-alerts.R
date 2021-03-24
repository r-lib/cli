
start_app()
on.exit(stop_app(), add = TRUE)

test_that("generic", {
  expect_snapshot(local({
    cli_div(theme = list(".alert" = list(before = "GENERIC! ")))
    cli_alert("wow")
  }))
})

test_that_cli("success", {
  expect_snapshot(local({
    cli_alert_success("wow")
  }))
})

test_that("danger", {
  expect_snapshot(local({
    cli_div(theme = list(".alert-danger" = list(before = "DANGER! ")))
    cli_alert_danger("wow")
  }))
})

test_that("warning", {
  expect_snapshot(local({
    cli_div(theme = list(".alert-warning" = list(before = "WARNING! ")))
    cli_alert_warning("wow")
  }))
})

test_that("info", {
  expect_snapshot(local({
    cli_div(theme = list(".alert-info" = list(before = "INFO! ")))
    cli_alert_info("wow")
  }))
})
