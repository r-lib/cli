
test_that("cli_progress_num", {
  withr::local_options(cli.progress_handlers_only = "cli")
  fun <- function() {
    before <- cli_progress_num()
    cli_progress_bar()
    after <- cli_progress_num()
    expect_equal(before + 1, after)
  }

  capture_cli_messages(fun())
})

test_that("cli_progress_cleanup", {
  fun <- function() {
    num <- NULL
    cli::cli_progress_bar()
    fun2 <- function() {
      cli::cli_progress_bar()
      cli::cli_progress_cleanup()
      num <<- cli::cli_progress_num()
    }
    fun2()
  }

  out <- callr::r(fun)
  expect_equal(out, 0L)
})

test_that("should_run_progress_examples", {
  withr::local_envvar(NOT_CRAN = "true")
  expect_true(should_run_progress_examples())

  mockery::stub(should_run_progress_examples, "is_rcmd_check", TRUE)
  expect_false(should_run_progress_examples())
})

test_that("is_rcmd_check", {
  withr::local_envvar(NOT_CRAN = NA, "_R_CHECK_PACKAGE_NAME_" = NA)
  expect_false(is_rcmd_check())
  withr::local_envvar(NOT_CRAN = NA, "_R_CHECK_PACKAGE_NAME_" = "cli")
  expect_true(is_rcmd_check())
})
