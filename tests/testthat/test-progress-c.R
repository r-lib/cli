
test_that("c api #1", {
  skip_on_cran()
  withr::local_options(cli.ansi = TRUE, cli.dynamic = TRUE)
  withr::local_options(cli.progress_handlers_only = "cli")

  dll <- make_c_function(test_path("progress-1.c"), linkingto = "cli")
  on.exit(dyn.unload(dll[["path"]]), add = TRUE)

  # simple crud
  out <- capture_cli_messages(cli_with_ticks(
    ret <- .Call(dll$clitest__progress_crud, NULL)
  ))
  out <- fix_times(out)
  expect_snapshot(out)

  # config can be FALSE
  out <- capture_cli_messages(cli_with_ticks(
    ret <- .Call(dll$clitest__progress_crud, FALSE)
  ))
  expect_false(ret)
  expect_equal(out, character())

  # config can override defaults
  out <- capture_cli_messages(cli_with_ticks(
    ret <- .Call(
      dll$clitest__progress_crud,
      list(format = "{cli::pb_current}/{cli::pb_total}")
    )
  ))
  expect_snapshot(out)

  # config must be a named list
  expect_error(
    .Call(dll$clitest__progress_crud, list(123)),
    "list elements must be named"
  )
  expect_error(
    .Call(dll$clitest__progress_crud, 100L),
    "Unknown cli progress bar configuation"
  )

  # config can be a progress bar name
  withr::local_options(
    cli.progress_format_iterator = "{cli::pb_name}{cli::pb_current}"
  )
  out <- capture_cli_messages(cli_with_ticks(
    ret <- .Call(dll$clitest__progress_crud, "me llama")
  ))
  expect_snapshot(out)

  # set various options
  out <- capture_cli_messages(cli_with_ticks(
    ret <- .Call(dll$clitest__progress_sets)
  ))
  expect_snapshot(out)

  # cli_progress_add
  out <- capture_cli_messages(cli_with_ticks(
    ret <- .Call(dll$clitest__progress_add)
  ))
  expect_snapshot(out)

  # cli_progress_num
  before <- .Call(dll$clitest__progress_num)
  bar <- cli_progress_bar()
  after <- .Call(dll$clitest__progress_num)
  cli_progress_done()
  expect_true(before + 1 == after)

  # cli_progress_update
  out <- capture_cli_messages(cli_without_ticks(
    ret <- .Call(dll$clitest__progress_update)
  ))
  expect_snapshot(out)
  out <- capture_cli_messages(cli_without_ticks(
    ret <- .Call(dll$clitest__progress_update2)
  ))
  expect_snapshot(out)
  out <- capture_cli_messages(cli_with_ticks(
    ret <- .Call(dll$clitest__progress_update3)
  ))
  expect_snapshot(out)

  # C progress bars have ids
  withr::local_options(cli.progress_handlers_only = "logger")
  out <- capture.output(cli_with_ticks(
    ret <- .Call(dll$clitest__progress_crud, NULL)
  ))
  out <- fix_logger_output(out)
  expect_snapshot(out)

  # cli_progress_sleep
  tic <- .Call(clic_get_time)
  .Call(dll$clitest__progress_sleep, 0L, 100L * 1000L * 1000L)
  toc <- .Call(clic_get_time)
  expect_true(toc - tic > 0.05)

  # progress vars in format_done
  withr::local_options(cli.progress_handlers_only = "cli")
  out <- capture_cli_messages(cli_with_ticks(
    ret <- .Call(
      dll$clitest__progress_crud,
      list(
        format = "{cli::pb_current}/{cli::pb_total}",
        format_done = "Just did {cli::pb_current} step{?s}.",
        clear = FALSE
      )
    )
  ))
  expect_snapshot(out)
})

test_that("c api #2", {
  skip_on_cran()
  dll <- make_c_function(test_path("progress-2.c"), linkingto = "cli")
  ret <- cli_with_ticks(.Call(dll$clitest__init_timer))
  expect_equal(ret, c(0L, 1L))
})

test_that("clic__find_var", {
  x <- 10
  expect_equal(.Call(clic__find_var, environment(), as.symbol("x")), 10)
  # not inherit
  env <- new.env(parent = environment())
  expect_error(
    .Call(clic__find_var, env, as.symbol("x")),
    "Cannot find variable"
  )
  expect_error(
    .Call(clic__find_var, environment(), as.symbol(basename(tempfile()))),
    "Cannot find variable"
  )
})

test_that("unloading stops the thread", {
  # It is important to skip this on CRAN, because in ASAN we do not
  # kill the tick thread on unload, because it triggers an ASAN crash,
  # which is similar to https://github.com/google/sanitizers/issues/1152
  skip_on_cran()
  fun <- function() {
    before <- ps::ps_num_threads()
    library(cli)
    between <- ps::ps_num_threads()
    unloadNamespace("cli")
    after <- ps::ps_num_threads()
    list(before = before, between = between, after = after)
  }

  out <- callr::r(fun)
  expect_equal(out$between, out$before + 1L)
  expect_equal(out$after, out$between - 1L)
})
