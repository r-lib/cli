test_that_cli("make_progress_bar", {
  withr::local_options(
    cli.progress_bar_style = NULL,
    cli.progress_bar_style_unicode = NULL,
    cli.progress_bar_style_ascii = NULL
  )
  expect_snapshot(make_progress_bar(.5))
})

test_that_cli(configs = "fancy", "cli_progress_styles", {
  withr::local_options(
    cli.progress_bar_style_unicode = NULL,
    cli.progress_bar_style_ascii = NULL
  )

  withr::local_options(cli.progress_bar_style = "classic")
  expect_snapshot(make_progress_bar(.5))

  withr::local_options(cli.progress_bar_style = "squares")
  expect_snapshot(make_progress_bar(.5))

  withr::local_options(cli.progress_bar_style = "dot")
  expect_snapshot(make_progress_bar(.5))

  withr::local_options(cli.progress_bar_style = "fillsquares")
  expect_snapshot(make_progress_bar(.5))

  withr::local_options(cli.progress_bar_style = "bar")
  expect_snapshot(make_progress_bar(.5))
})

test_that_cli(configs = c("plain", "unicode"), "custom style", {
  mybar <- list(complete = "X", incomplete = "O", current = ">")
  withr::local_options(
    cli.progress_bar_style = mybar,
    cli.progress_bar_style_unicode = NULL,
    cli.progress_bar_style_ascii = NULL
  )
  expect_snapshot(make_progress_bar(.5))
})
