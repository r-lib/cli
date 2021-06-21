
test_that("cli_progress_along crud", {
  fun <- function() {
    sapply(cli_progress_along(letters), function(i) i)
  }
  capture_cli_messages(ret <- fun())
  expect_identical(ret, seq_along(letters))
})

test_that("progress bar terminated at mapping function exit", {
  fun <- function() {
    snap <- as.character(names(clienv$progress))
    sapply(cli_progress_along(letters), function(i) i)
    expect_identical(as.character(names(clienv$progress)), snap)
  }
  capture_cli_messages(fun())
})

test_that("interpolation uses the right env", {
  if (getRversion() < "3.5.0") skip("Needs ALTREP")
  fun <- function() {
    withr::local_options(
      cli.ansi = TRUE,
      cli.dynamic = TRUE,
      cli.progress_show_after = 0,
      cli.progress_handlers_only = "cli"
    )
    x <- 10
    sapply(cli_progress_along(1:5, format = "x: {x}"), function(i) i)
  }

  out <- capture_cli_messages(cli_with_ticks(fun()))
  expect_snapshot(out)
})

test_that("cli_progress_along", {
  if (getRversion() < "3.5.0") skip("Needs ALTREP")
  withr::local_envvar(CLI_NO_THREAD = "1")
  fun <- function() {
    withr::local_options(
      cli.ansi = TRUE,
      cli.dynamic = TRUE,
      cli.progress_show_after = 0,
      cli.progress_handlers_only = "logger"
    )
    vapply(cli::cli_progress_along(1:10), function(i) i, integer(1))
  }

  lines <- fix_logger_output(capture.output(cli_with_ticks(fun())))
  expect_snapshot(lines)
})

test_that("cli_progress_along error", {
  if (getRversion() < "3.5.0") skip("Needs ALTREP")
  withr::local_envvar(CLI_NO_THREAD = "1")
  fun <- function() {
    withr::local_options(
      cli.ansi = TRUE,
      cli.dynamic = TRUE,
      cli.progress_show_after = 0,
      cli.progress_handlers_only = "logger"
    )
    suppressWarnings(testthat::local_reproducible_output())
    lapply(
      cli::cli_progress_along(1:10, clear = FALSE),
      function(i) { if (i == 5) stop("oops") }
    )
  }

  outfile <- tempfile()
  expect_error(callr::r(fun, stdout = outfile, stderr = outfile))

  lines <- fix_logger_output(readLines(outfile))
  expect_snapshot(lines)
})

test_that("old R is just seq_along", {
  # It is tricky to check that we get seq_along(), because
  # identical(cli_progress_along(1:10), seq_along(1:10)) holds,
  # so we just check that no progress bar is created.
  mockery::stub(cli_progress_along, "getRversion", package_version("3.4.0"))
  snapshot <- names(clienv$progress)
  it <- cli_progress_along(1:10)
  expect_identical(snapshot, names(clienv$progress))
  expect_identical(it, seq_along(1:10))
})

test_that("error in handler is a single warning", {
  if (getRversion() < "3.5.0") skip("Needs ALTREP")
  fun <- function() {
    withr::local_options(
      cli.ansi = TRUE,
      cli.dynamic = TRUE,
      cli.progress_show_after = 0,
      cli.progress_handlers_only = "cli"
    )
    x <- 10
    sapply(cli_progress_along(1:5, format = "{1+''}"), function(i) i)
  }

  expect_snapshot(cli_with_ticks(fun()))
})

test_that("length 1 seq", {
  fun <- function() {
    sapply(cli_progress_along(1L), function(i) i)
  }
  capture_cli_messages(ret <- cli_with_ticks(fun()))
  expect_identical(ret, 1L)
})

test_that("ALTREP methods", {
  if (getRversion() < "3.5.0") skip("Needs ALTREP")
  seq <- cli_progress_along(1:10)
  expect_output(.Internal(inspect(seq)), "progress_along")

  expect_equal(is.unsorted(seq), FALSE)
  expect_equal(sum(seq), sum(1:10))

  seq <- cli_progress_along(letters)
  expect_equal(min(seq), 1L)
  expect_equal(max(seq), length(letters))

  z <- cli_progress_along(character())
  expect_equal(min(z), Inf)

  seq <- cli_progress_along(letters)
  expect_equal(.Call(clic_dataptr, seq), seq_along(letters) * 2)

  seq2 <- seq
  expect_silent(seq2[1] <- 100)
})
