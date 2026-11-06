test_that("llm handler prints compact, rate limited lines", {
  local_mocked_bindings(is_llm = function() TRUE)
  withr::local_options(
    cli.progress_show_after = 0,
    cli.progress_llm_interval = 1000,
    cli.progress_handlers_only = "llm",
    cli.num_colors = 1
  )
  fun <- function() {
    cli_progress_bar("Fitting", total = 100)
    for (i in 1:100) {
      cli_progress_update(force = TRUE)
    }
  }
  expect_snapshot(fun(), transform = function(x) {
    sub("[0-9.]+m?s$", "<time>", x)
  })
})

test_that("llm handler is selected by default for agents", {
  local_mocked_bindings(is_llm = function() TRUE)
  expect_true(builtin_handler_llm$able(NULL, NULL))
  expect_equal(
    pb__default_format("iterator", NA),
    "{cli::pb_name}{cli::pb_status}{cli::pb_current} done | {cli::pb_elapsed}"
  )
})
