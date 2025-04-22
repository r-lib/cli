
test_that("cli_progress_demo", {
  withr::local_options(cli.ansi = TRUE)
  out <- cli_progress_demo(live = FALSE, at = 50)
  out$lines <- fix_times(out$lines)
  expect_snapshot(out)

  out <- cli_progress_demo(live = FALSE, at = NULL, total = 3)
  out$lines <- fix_times(out$lines)
  expect_snapshot(out)

  out <- cli_progress_demo(live = FALSE, at = NULL, total = NA, delay = 0.001)
  out$lines <- fix_times(out$lines)
  expect_snapshot(out)

  fun <- function() {
    options(cli.progress_handlers_only = "cli")
    cli_progress_demo(live = TRUE, at = NULL, total = 3)
  }

  msgs <- capture_cli_messages(out <- fun())
  expect_snapshot(out)
  expect_snapshot(msgs)
})

test_that("pb_bar", {
  expect_equal(cli__pb_bar(NULL), "")
  withr::local_options(cli__pb = list(current = 15, total = NA))
  expect_snapshot(cli_text("-{cli::pb_bar}-"))
  withr::local_options(cli__pb = list(current = 15, total = 30))
  expect_snapshot(cli_text("-{cli::pb_bar}-"))
})

test_that("pb_current", {
  expect_equal(cli__pb_current(NULL), "")
  withr::local_options(cli__pb = list(current = 15))
  expect_equal(cli::pb_current, 15)
})

test_that("pb_current_bytes", {
  expect_equal(cli__pb_current_bytes(NULL), "")
  expect_snapshot({
    cli__pb_current_bytes(list(current = 0))
    cli__pb_current_bytes(list(current = 1))
    cli__pb_current_bytes(list(current = 1000))
    cli__pb_current_bytes(list(current = 1000 * 23))
    cli__pb_current_bytes(list(current = 1000 * 1000 * 23))
  })
})

test_that("pb_elapsed", {
  expect_equal(cli__pb_elapsed(NULL), "")
  withr::local_options(cli__pb = list(start = 0, speed_time = 1))
  local_mocked_bindings(.Call = function(...) 1)
  expect_snapshot(cli__pb_elapsed())
  local_mocked_bindings(.Call = function(...) 21)
  expect_snapshot(cli__pb_elapsed())
  local_mocked_bindings(.Call = function(...) 58)
  expect_snapshot(cli__pb_elapsed())
  local_mocked_bindings(.Call = function(...) 60 * 65)
  expect_snapshot(cli__pb_elapsed())
})

test_that("pb_elapsed_clock", {
  expect_equal(cli__pb_elapsed_clock(NULL), "")
  withr::local_options(cli__pb = list(start = 0, speed_time = 1))
  local_mocked_bindings(.Call = function(...) 1)
  expect_snapshot(cli__pb_elapsed_clock())
  local_mocked_bindings(.Call = function(...) 21)
  expect_snapshot(cli__pb_elapsed_clock())
  local_mocked_bindings(.Call = function(...) 58)
  expect_snapshot(cli__pb_elapsed_clock())
  local_mocked_bindings(.Call = function(...) 60 * 65)
  expect_snapshot(cli__pb_elapsed_clock())
})

test_that("pb_elapsed_raw", {
  expect_equal(cli__pb_elapsed_raw(NULL), "")
  withr::local_options(cli__pb = list(start = 0, speed_time = 1))
  local_mocked_bindings(.Call = function(...) 1)
  expect_snapshot(cli__pb_elapsed_raw())
  local_mocked_bindings(.Call = function(...) 21)
  expect_snapshot(cli__pb_elapsed_raw())
  local_mocked_bindings(.Call = function(...) 58)
  expect_snapshot(cli__pb_elapsed_raw())
  local_mocked_bindings(.Call = function(...) 60 * 65)
  expect_snapshot(cli__pb_elapsed_raw())
})

test_that("pb_eta", {
  expect_equal(cli__pb_eta(NULL), "")
  local_mocked_bindings(cli__pb_eta_raw = function(...) NA_real_)
  expect_snapshot(cli__pb_eta(list()))
  local_mocked_bindings(cli__pb_eta_raw = function(...) as.difftime(12, units = "secs"))
  expect_snapshot(cli__pb_eta(list()))
})

test_that("pb_eta_raw", {
  expect_equal(cli__pb_eta_raw(NULL), "")
  withr::local_options(cli__pb = list(total = NA))
  expect_identical(cli__pb_eta_raw(), NA_real_)
  local_mocked_bindings(.Call = function(...) 0)
  withr::local_options(cli__pb = list(start = -10, total = 100, current = 0))
  expect_snapshot(cli__pb_eta_raw())
  withr::local_options(cli__pb = list(start = -10, total = 100, current = 20))
  expect_snapshot(cli__pb_eta_raw())
  withr::local_options(cli__pb = list(start = -40, total = 100, current = 80))
  expect_snapshot(cli__pb_eta_raw())
  withr::local_options(cli__pb = list(start = -50, total = 100, current = 100))
  expect_snapshot(cli__pb_eta_raw())
})

test_that("pb_eta_str", {
  expect_equal(cli__pb_eta_str(NULL), "")
  withr::local_options(cli__pb = list(total = NA))
  expect_identical(cli__pb_eta_str(), "")
  local_mocked_bindings(cli__pb_eta = function(...) "?")
  expect_snapshot(cli__pb_eta_str(list()))
  local_mocked_bindings(cli__pb_eta = function(...) " 1s")
  expect_snapshot(cli__pb_eta_str(list()))
})

test_that("pb_extra", {
  expect_equal(cli__pb_extra(NULL), "")
  expect_equal(cli__pb_extra(list(extra = list(a = 1))), list(a = 1))
})

test_that("pb_id", {
  expect_equal(cli__pb_id(NULL), "")
  expect_equal(cli__pb_id(list(id = 123)), 123)
})

test_that("pb_name", {
  expect_equal(cli__pb_name(NULL), "")
  expect_equal(cli__pb_name(list(name = NULL)), "")
  expect_equal(cli__pb_name(list(name = "foo")), "foo ")
})

test_that("pb_percent", {
  expect_equal(cli__pb_percent(NULL), "")
  expect_snapshot({
    cli__pb_percent(list(current = 0, total = 99))
    cli__pb_percent(list(current = 5, total = 99))
    cli__pb_percent(list(current = 10, total = 99))
    cli__pb_percent(list(current = 25, total = 99))
    cli__pb_percent(list(current = 99, total = 99))
    cli__pb_percent(list(current = 100, total = 99))
  })
})

test_that("pb_pid", {
  expect_equal(cli__pb_pid(NULL), "")
  expect_equal(cli__pb_pid(list()), Sys.getpid())
  expect_equal(cli__pb_pid(list(pid = 100)), 100)
})

test_that("pb_rate", {
  expect_equal(cli__pb_rate(NULL), "")
  local_mocked_bindings(cli__pb_rate_raw = function(...) NaN)
  expect_snapshot(cli__pb_rate(list()))
  local_mocked_bindings(cli__pb_rate_raw = function(...) Inf)
  expect_snapshot(cli__pb_rate(list()))
  local_mocked_bindings(cli__pb_rate_raw = function(...) 1 / 10)
  expect_snapshot(cli__pb_rate(list()))
  local_mocked_bindings(cli__pb_rate_raw = function(...) 12.4)
  expect_snapshot(cli__pb_rate(list()))
})

test_that("pb_rate_raw", {
  expect_equal(cli__pb_rate_raw(NULL), "")
  local_mocked_bindings(cli__pb_elapsed_raw = function(...) this)
  this <- 0
  expect_equal(cli__pb_rate_raw(list(current = 0)), NaN)
  expect_equal(cli__pb_rate_raw(list(current = 23)), Inf)
  this <- 1
  expect_equal(cli__pb_rate_raw(list(current = 23)), 23)
  this <- 10
  expect_equal(cli__pb_rate_raw(list(current = 1)), 1/10)
})

test_that("pb_rate_bytes", {
  expect_equal(cli__pb_rate_bytes(NULL), "")
  local_mocked_bindings(cli__pb_rate_raw = function(...) NaN)
  expect_snapshot(cli__pb_rate_bytes(list()))
  local_mocked_bindings(cli__pb_rate_raw = function(...) Inf)
  expect_snapshot(cli__pb_rate_bytes(list()))
  local_mocked_bindings(cli__pb_rate_raw = function(...) 0)
  expect_snapshot(cli__pb_rate_bytes(list()))
  local_mocked_bindings(cli__pb_rate_raw = function(...) 1024)
  expect_snapshot(cli__pb_rate_bytes(list()))
  local_mocked_bindings(cli__pb_rate_raw = function(...) 1024 * 23)
  expect_snapshot(cli__pb_rate_bytes(list()))
  local_mocked_bindings(cli__pb_rate_raw = function(...) 1024 * 1024 * 23)
  expect_snapshot(cli__pb_rate_bytes(list()))
})

test_that("pb_spin", {
  expect_equal(cli__pb_spin(NULL), "")
  withr::local_options(cli.spinner = "line")
  withr::local_options(cli__pb = list(tick = 1))
  expect_snapshot(cli_text("-{cli::pb_spin}-{cli::pb_spin}-"))
  withr::local_options(cli__pb = list(tick = 2))
  expect_snapshot(cli_text("-{cli::pb_spin}-{cli::pb_spin}-"))
  withr::local_options(cli__pb = list(tick = 10))
  expect_snapshot(cli_text("-{cli::pb_spin}-{cli::pb_spin}-"))
})

test_that("pb_status", {
  expect_equal(cli__pb_status(NULL), "")
  expect_equal(cli__pb_status(NULL), "")
  expect_equal(cli__pb_status(list(status = NULL)), "")
  expect_equal(cli__pb_status(list(status = "foo")), "foo ")
})

test_that("pb_timestamp", {
  expect_equal(cli__pb_timestamp(NULL), "")
  fake <- .POSIXct(1623974954, tz = "GMT")
  local_mocked_bindings(Sys.time = function() fake)
  expect_snapshot(cli__pb_timestamp(list()))

  backup <- mget(c("load_time", "speed_time"), clienv)
  on.exit({
    clienv$load_time <- backup$load_time
    clienv$speed_time <- backup$speed_time
  }, add = TRUE)

  clienv$load_time <- fake - 10
  clienv$speed_time <- 3.0
  expect_snapshot(cli__pb_timestamp(list()))
})

test_that("pb_total", {
  expect_equal(cli__pb_total(NULL), "")
  expect_equal(cli__pb_total(list(total = 101)), 101)
})

test_that("pb_total_bytes", {
  expect_equal(cli__pb_total_bytes(NULL), "")
  expect_snapshot({
    cli__pb_total_bytes(list(total = 0))
    cli__pb_total_bytes(list(total = 1))
    cli__pb_total_bytes(list(total = 1000))
    cli__pb_total_bytes(list(total = 1000 * 23))
    cli__pb_total_bytes(list(total = 1000 * 1000 * 23))
  })
})
