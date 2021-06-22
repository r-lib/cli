
test_that("cli_progress_message", {
  withr::local_options(cli.dynamic = FALSE, cli.ansi = FALSE)
  fun <- function() {
    cli_progress_message("Simplest progress 'bar', {.fun fn} {2} two{?s}")
  }
  expect_snapshot(capture_cli_messages(fun()))
})

test_that("cli_progress_message error", {
  fun <- function() {
    withr::local_options(cli.dynamic = FALSE, cli.ansi = FALSE)
    suppressWarnings(testthat::local_reproducible_output())
    cli::cli_progress_message("Simplest progress 'bar', {.fun fn} {2} two{?s}")
    stop("oopsie")
  }

  outfile <- tempfile()
  on.exit(unlink(outfile), add = TRUE)
  expect_error(callr::r(fun, stdout = outfile, stderr = outfile), "oopsie")
  expect_snapshot(readLines(outfile))

  fun2 <- function() {
    withr::local_options(cli.dynamic = TRUE, cli.ansi = TRUE)
    suppressWarnings(testthat::local_reproducible_output())
    cli::cli_progress_message("Simplest progress 'bar', {.fun fn} {2} two{?s}")
    stop("oopsie")
  }

  outfile <- tempfile()
  on.exit(unlink(outfile), add = TRUE)
  expect_error(callr::r(fun2, stdout = outfile, stderr = outfile), "oopsie")
  out <- rawToChar(readBin(outfile, "raw", 1000))
  expect_snapshot(win2unix(out))
})

start_app()
on.exit(stop_app(), add = TRUE)

test_that("cli_progress_step", {
  withr::local_options(cli.dynamic = TRUE, cli.ansi = TRUE)
  suppressWarnings(testthat::local_reproducible_output())
  fun <- function() {
    cli_progress_step("First step")
    cli_progress_step("Second step")
  }
  msgs <- capture_cli_messages(fun())
  expect_snapshot(msgs)
})

test_that("cli_progress_step error", {
  if (getRversion() < "3.5.0") skip("Needs R 3.5.0")
  fun <- function() {
    withr::local_options(cli.dynamic = FALSE, cli.ansi = FALSE)
    suppressWarnings(testthat::local_reproducible_output())
    cli::cli_progress_step("First step")
    cli::cli_progress_step("Second step")
    stop("oopsie")
  }

  outfile <- tempfile()
  on.exit(unlink(outfile), add = TRUE)
  expect_error(callr::r(fun, stdout = outfile, stderr = "2>&1"), "oopsie")
  out <- rawToChar(readBin(outfile, "raw", 1000))
  expect_snapshot(win2unix(out))
})
