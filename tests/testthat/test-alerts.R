
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

test_that_cli("danger", {
  expect_snapshot(local({
    cli_alert_danger("wow")
  }))
})

test_that_cli("warning", {
  expect_snapshot(local({
    cli_alert_warning("wow")
  }))
})

test_that_cli("info", {
  expect_snapshot(local({
    cli_alert_info("wow")
  }))
})

test_that("before and after can have spaces", {
  expect_snapshot(local({
    cli_div(theme = list(.alert = list(before = "x  ", after = "  x")))
    cli_alert("continuing that first alert", wrap = TRUE)
  }))
})
