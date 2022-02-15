
test_that("cli_progress_bar", {
  withr::local_options(cli.dynamic = FALSE, cli.ansi = FALSE)
  fun <- function() {
    bar <- cli_progress_bar(
      name = "name",
      status = "status",
      format = "{cli::pb_spin} {cli::pb_name}{cli::pb_status}{cli::pb_current}"
    )
    cli_progress_update(force = TRUE)
    cli_progress_done(id = bar)
  }
  expect_snapshot(capture_cli_messages(fun()))
})

test_that("custom format needs a format string", {
  expect_error(cli_progress_bar(type = "custom"), "Need to specify format")
})

test_that("removes previous progress bar", {
  withr::local_options(cli.dynamic = FALSE, cli.ansi = FALSE)
  fun <- function() {
    bar <- cli_progress_bar(format = "first", format_done = "first done", clear = FALSE)
    cli_progress_update(force = TRUE)
    bar2 <- cli_progress_bar(format = "second", format_done = "second done", clear = FALSE)
    cli_progress_update(force = TRUE)
  }

  expect_snapshot(capture_cli_messages(fun()))
})

test_that("backend methods are called", {
  withr::local_options(cli.progress_handlers_only = "logger")
  fun <- function() {
    cli_progress_bar()
    cli_progress_update(force = TRUE)
    cli_progress_done()
  }
  out <- capture_output(fun())
  expect_match(out, "created.*added.*updated.*terminated")
})

test_that("update errors if no progress bar", {
  fun <- function() {
    cli_progress_update()
  }
  expect_error(fun(), "Cannot find current progress bar")

  fun <- function() {
    cli_progress_output("boo")
  }
  expect_error(fun(), "Cannot find current progress bar")
  
  envkey <- NULL
  fun <- function() {
    envkey <<- format(environment())
    clienv$progress_ids[[envkey]] <- "foobar"
    cli_progress_update()
  }
  expect_error(fun(), "Cannot find progress bar")

  envkey <- NULL
  fun <- function() {
    envkey <<- format(environment())
    clienv$progress_ids[[envkey]] <- "foobar"
    cli_progress_output("booboo")
  }
  expect_error(fun(), "Cannot find progress bar")

  clienv$progress_ids[[envkey]] <- NULL
})

test_that("cli_progress_update can update status", {
  withr::local_options(cli.dynamic = FALSE, cli.ansi = FALSE)
  fun <- function() {
    bar <- cli_progress_bar(
      name = "name",
      status = "status",
      format = "{cli::pb_spin} {cli::pb_name}{cli::pb_status}{cli::pb_current}"
    )
    cli_progress_update(force = TRUE)
    cli_progress_update(status = "new status", force = TRUE)
    cli_progress_done(id = bar)
  }
  expect_snapshot(capture_cli_messages(fun()))
})

test_that("cli_progress_update can update extra data", {
  withr::local_options(cli.dynamic = FALSE, cli.ansi = FALSE)
  fun <- function() {
    bar <- cli_progress_bar(
      format = "Extra: {cli::pb_extra$foo}",
      extra = list(foo = "bar")
    )
    cli_progress_update(force = TRUE)
    cli_progress_update(extra = list(foo = "baz"), force = TRUE)
    cli_progress_done(id = bar)
  }
  expect_snapshot(capture_cli_messages(fun()))
})

test_that("update set", {
  withr::local_options(cli.dynamic = FALSE, cli.ansi = FALSE)
  fun <- function() {
    bar <- cli_progress_bar(
      name = "name",
      total = 100,
      format = "{cli::pb_name}{cli::pb_status}{cli::pb_current}/{cli::pb_total}"
    )
    cli_progress_update(force = TRUE)
    cli_progress_update(force = TRUE, set = 50)
    cli_progress_done(id = bar)
  }
  expect_snapshot(capture_cli_messages(fun()))
})

test_that("format changes if we (un)learn total", {
  withr::local_options(cli.dynamic = FALSE, cli.ansi = FALSE)
  fun <- function() {
    bar <- cli_progress_bar(
      name = "name",
      total = NA,
    )
    cli_progress_update(force = TRUE)
    cli_progress_update(force = TRUE, set = 50, total = 100)
    cli_progress_update(force = TRUE, set = 75, total = NA)
    cli_progress_done(id = bar)
  }
  out <- fix_times(capture_cli_messages(fun()))
  expect_snapshot(out)
})

test_that("auto-terminate", {
  withr::local_options(cli.dynamic = FALSE, cli.ansi = FALSE)
  fun <- function() {
    bar <- cli_progress_bar(total = 10, format = "first", format_done = "first done", clear = FALSE)
    cli_progress_update(force = TRUE)
    cli_progress_update(force = TRUE, set = 10)
    cli_text("First is done by now.\n")
    bar2 <- cli_progress_bar(format = "second", format_done = "second done", clear = FALSE)
    cli_progress_update(force = TRUE)
  }

  expect_snapshot(capture_cli_messages(fun()))
})

test_that("done does nothing if no progress bar", {
  fun <- function() {
    cli_progress_done()
  }
  expect_true(fun())
})

test_that("cli_progress_output", {
  skip_if_not_installed("testthat", "3.1.1")
  withr::local_options(cli.dynamic = TRUE, cli.ansi = TRUE)
  fun <- function() {
    bar <- cli_progress_bar(total = 10, format = "first")
    cli_progress_update(force = TRUE)
    cli_progress_output("just {1} text{?s}")
    cli_progress_update(force = TRUE)
  }

  expect_snapshot(capture_cli_messages(fun()))

  withr::local_options(cli.dynamic = TRUE, cli.ansi = FALSE)
  expect_snapshot(capture_cli_messages(fun()))  
})
