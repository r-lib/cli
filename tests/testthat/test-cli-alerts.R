
context("cli alerts")

test_that("generic", {
  clix$div(theme = list(".alert" = list(before = "GENERIC! ")))
  out <- capt(clix$alert("wow"), print_it = FALSE)
  expect_match(out, "GENERIC")
})

test_that("success", {
  clix$div(theme = list(".alert-success" = list(before = "SUCCESS! ")))
  out <- capt(clix$alert_success("wow"), print_it = FALSE)
  expect_match(out, "SUCCESS")
})

test_that("danger", {
  clix$div(theme = list(".alert-danger" = list(before = "DANGER! ")))
  out <- capt(clix$alert_danger("wow"), print_it = FALSE)
  expect_match(out, "DANGER")
})

test_that("warning", {
  clix$div(theme = list(".alert-warning" = list(before = "WARNING! ")))
  out <- capt(clix$alert_warning("wow"), print_it = FALSE)
  expect_match(out, "WARNING")
})

test_that("info", {
  clix$div(theme = list(".alert-info" = list(before = "INFO! ")))
  out <- capt(clix$alert_info("wow"), print_it = FALSE)
  expect_match(out, "INFO")
})
