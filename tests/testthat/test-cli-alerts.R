
context("cli alerts")

test_that("generic", {
  clix$div(theme = list(".alert::before" = list(content = "GENERIC! ")))
  out <- capt0(clix$alert("wow"))
  expect_match(out, "GENERIC")
})

test_that("success", {
  clix$div(theme = list(".alert-success::before" = list(content = "SUCCESS! ")))
  out <- capt0(clix$alert_success("wow"))
  expect_match(out, "SUCCESS")
})

test_that("danger", {
  clix$div(theme = list(".alert-danger::before" = list(content = "DANGER! ")))
  out <- capt0(clix$alert_danger("wow"))
  expect_match(out, "DANGER")
})

test_that("warning", {
  clix$div(theme = list(".alert-warning::before" = list(content = "WARNING! ")))
  out <- capt0(clix$alert_warning("wow"))
  expect_match(out, "WARNING")
})

test_that("info", {
  clix$div(theme = list(".alert-info::before" = list(content = "INFO! ")))
  out <- capt0(clix$alert_info("wow"))
  expect_match(out, "INFO")
})
