test_that("ticking", {
  withr::local_options(
    cli.ansi = TRUE,
    cli.dynamic = TRUE,
    cli.progress_show_after = 0,
    cli.progress_handlers_only = "cli"
  )

  fun <- function() {
    i <- 0L
    while (
      ticking(
        i < 10L,
        total = 10L,
        name = "ticking",
        format = "{cli::pb_current}/{cli::pb_total}"
      )
    ) {
      i <- i + 1L
    }
  }

  out <- capture_cli_messages(cli_with_ticks(fun()))
  expect_snapshot(out)
})
