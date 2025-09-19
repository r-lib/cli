test_that("cli_progress_builtin_handlers", {
  expect_true(is.character(cli_progress_builtin_handlers()))
  expect_true(all(
    c("cli", "shiny", "rstudio") %in% cli_progress_builtin_handlers()
  ))
})

test_that("cli_progress_select_handlers #1", {
  # only handlers
  withr::local_options(
    "cli.progress_handlers" = c("foo", "bar"),
    "cli.progress_handlers_force" = c("forced"),
    "cli.progress_handlers_only" = "logger"
  )
  expect_equal(
    names(cli_progress_select_handlers(list(), environment())),
    "logger"
  )
})

test_that("cli_progress_select_handlers #2", {
  # auto-select
  withr::local_options(
    "cli.progress_handlers" = c("foo", "bar", "baz"),
    "cli.progress_handlers_force" = NULL,
    "cli.progress_handlers_only" = NULL
  )
  fake <- list(
    foo = list(able = function(...) FALSE),
    bar = list(),
    baz = list(),
    forced = list()
  )
  local_mocked_bindings(builtin_handlers = function() fake)
  expect_equal(cli_progress_select_handlers(), fake["bar"])
})

test_that("cli_progress_select_handlers #3", {
  # auto-select
  withr::local_options(
    "cli.progress_handlers" = c("foo", "bar", "baz"),
    "cli.progress_handlers_force" = c("forced"),
    "cli.progress_handlers_only" = NULL
  )
  fake <- list(
    foo = list(able = function(...) FALSE),
    bar = list(able = function(...) TRUE),
    baz = list(),
    forced = list()
  )
  local_mocked_bindings(builtin_handlers = function() fake)
  expect_equal(cli_progress_select_handlers(), fake[c("bar", "forced")])
})

test_that("builtin_handlers", {
  expect_true(is.list(builtin_handlers()))
  expect_true(all(c("cli", "shiny", "rstudio") %in% names(builtin_handlers())))
})
