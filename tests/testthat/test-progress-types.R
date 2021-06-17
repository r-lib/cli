
start_app()
on.exit(stop_app(), add = TRUE)

test_that("iterator", {
  withr::local_options(
    cli.dynamic = TRUE,
    cli.ansi = TRUE,
    cli.spinner = NULL,
    cli.spinner_unicode = NULL,
    cli.progress_format_iterator = NULL,
    cli.progress_format_iterator_nototal= NULL
  )

  fun <- function() {
    cli_progress_bar(type = "iterator", total = 100)
    cli_progress_update(set = 50, force = TRUE)
  }
  out <- fix_times(capture_cli_messages(fun()))
  expect_snapshot(out)

  fun <- function() {
    cli_progress_bar(type = "iterator", total = NA)
    cli_progress_update(set = 50, force = TRUE)
  }
  out <- fix_times(capture_cli_messages(fun()))
  expect_snapshot(out)
})

test_that("tasks", {
  withr::local_options(
    cli.dynamic = TRUE,
    cli.ansi = TRUE,
    cli.spinner = NULL,
    cli.spinner_unicode = NULL,
    cli.progress_format_tasks = NULL,
    cli.progress_format_tasks_nototal= NULL
  )

  fun <- function() {
    cli_progress_bar(type = "tasks", total = 100)
    cli_progress_update(set = 50, force = TRUE)
  }
  out <- fix_times(capture_cli_messages(fun()))
  expect_snapshot(out)

  fun <- function() {
    cli_progress_bar(type = "tasks", total = NA)
    cli_progress_update(set = 50, force = TRUE)
  }
  out <- fix_times(capture_cli_messages(fun()))
  expect_snapshot(out)
})

test_that("download", {
  withr::local_options(
    cli.dynamic = TRUE,
    cli.ansi = TRUE,
    cli.spinner = NULL,
    cli.spinner_unicode = NULL,
    cli.progress_format_download = NULL,
    cli.progress_format_download_nototal= NULL
  )

  fun <- function() {
    cli_progress_bar(type = "download", total = 1024 * 1024)
    cli_progress_update(set = 52 * 1024, force = TRUE)
  }
  out <- fix_times(capture_cli_messages(fun()))
  expect_snapshot(out)

  fun <- function() {
    cli_progress_bar(type = "download", total = NA)
    cli_progress_update(set = 52 * 1024, force = TRUE)
  }
  out <- fix_times(capture_cli_messages(fun()))
  expect_snapshot(out)
})

test_that("customize with options, iterator", {
  withr::local_options(
    cli.dynamic = TRUE,
    cli.ansi = TRUE,
    cli.progress_format_iterator = "new format {pb_current}",
    cli.progress_format_iterator_nototal = NULL
  )

  fun <- function(type, total, set = 50) {
    cli_progress_bar(type = type, total = total)
    cli_progress_update(set = set, force = TRUE)
  }

  expect_snapshot(capture_cli_messages(fun("iterator", 100)))
  expect_snapshot(capture_cli_messages(fun("iterator", NA)))

  withr::local_options(
    cli.progress_format_iterator_nototal = "new too {pb_current}"
  )

  expect_snapshot(capture_cli_messages(fun("iterator", 100)))
  expect_snapshot(capture_cli_messages(fun("iterator", NA)))
})

test_that("customize with options, tasks", {
  withr::local_options(
    cli.dynamic = TRUE,
    cli.ansi = TRUE,
    cli.progress_format_tasks = "new format {pb_current}",
    cli.progress_format_tasks_nototal = NULL
  )

  fun <- function(type, total, set = 50) {
    cli_progress_bar(type = type, total = total)
    cli_progress_update(set = set, force = TRUE)
  }

  expect_snapshot(capture_cli_messages(fun("tasks", 100)))
  expect_snapshot(capture_cli_messages(fun("tasks", NA)))

  withr::local_options(
    cli.progress_format_tasks_nototal = "new too {pb_current}"
  )

  expect_snapshot(capture_cli_messages(fun("tasks", 100)))
  expect_snapshot(capture_cli_messages(fun("tasks", NA)))
})

test_that("customize with options, download", {
  withr::local_options(
    cli.dynamic = TRUE,
    cli.ansi = TRUE,
    cli.progress_format_download = "new format {pb_current_bytes}",
    cli.progress_format_download_nototal = NULL
  )

  fun <- function(type, total, set = 50) {
    cli_progress_bar(type = type, total = total)
    cli_progress_update(set = set, force = TRUE)
  }

  expect_snapshot(capture_cli_messages(fun("download", 1024 * 1024, 512 * 1024)))
  expect_snapshot(capture_cli_messages(fun("download", NA, 512 * 1024)))

  withr::local_options(
    cli.progress_format_download_nototal = "new too {pb_current_bytes}"
  )

  expect_snapshot(capture_cli_messages(fun("download", 1024 * 1024, 512 * 1024)))
  expect_snapshot(capture_cli_messages(fun("download", NA, 512 * 1024)))
})
