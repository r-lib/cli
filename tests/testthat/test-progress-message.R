test_that("cli_progress_message", {
  withr::local_options(cli.dynamic = FALSE, cli.ansi = FALSE)
  fun <- function() {
    cli_progress_message("Simplest progress 'bar', {.fun fn} {2} two{?s}")
  }
  expect_snapshot(capture_cli_messages(fun()))
})

test_that("cli_progress_message error", {
  # we need the env var as well, because the on.exit handler of the progress
  # bar might run after the on.exit handler that removes the `cli.dynamic`
  # option.
  withr::local_envvar(R_CLI_DYNAMIC = "false")
  fun <- function() {
    suppressWarnings(testthat::local_reproducible_output())
    options(cli.dynamic = FALSE, cli.ansi = FALSE)
    cli::cli_progress_message("Simplest progress 'bar', {.fun fn} {2} two{?s}")
    stop("oopsie")
  }

  outfile <- tempfile()
  on.exit(unlink(outfile), add = TRUE)
  expect_snapshot(error = TRUE, {
    callr::r(fun, stdout = outfile, stderr = outfile)
  })
  expect_snapshot(readLines(outfile))

  # we need the env var as well, because the on.exit handler of the progress
  # bar might run after the on.exit handler that removes the `cli.dynamic`
  # option.
  withr::local_envvar(R_CLI_DYNAMIC = "true")
  fun2 <- function() {
    suppressWarnings(testthat::local_reproducible_output())
    options(cli.dynamic = TRUE, cli.ansi = TRUE)
    cli::cli_progress_message("Simplest progress 'bar', {.fun fn} {2} two{?s}")
    stop("oopsie")
  }

  outfile <- tempfile()
  on.exit(unlink(outfile), add = TRUE)
  expect_snapshot(error = TRUE, {
    callr::r(fun2, stdout = outfile, stderr = outfile)
  })
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
  msgs <- fix_times(capture_cli_messages(fun()))
  expect_snapshot(msgs)
})

test_that("cli_progress_step error", {
  if (getRversion() < "3.5.0") skip("Needs R 3.5.0")
  fun <- function() {
    options(
      cli.dynamic = FALSE,
      cli.ansi = FALSE,
      cli.unicode = FALSE,
      cli.width = 80,
      width = 80,
      cli.num_colors = 1
    )
    cli::cli_progress_step("First step")
    cli::cli_progress_step("Second step")
    stop("oopsie")
  }

  outfile <- tempfile()
  on.exit(unlink(outfile), add = TRUE)
  expect_snapshot(error = TRUE, {
    callr::r(fun, stdout = outfile, stderr = "2>&1")
  })
  out <- fix_times(rawToChar(readBin(outfile, "raw", 1000)))
  expect_snapshot(win2unix(out))
})
