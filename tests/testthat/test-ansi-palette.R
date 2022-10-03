
test_that("ansi_palette_show", {
  local_clean_cli_context()
  expect_snapshot(
    ansi_palette_show(colors = truecolor)
  )

  withr::local_options(cli.palette = "iterm-snazzy")
  expect_snapshot(
    ansi_palette_show(colors = truecolor)
  )
})

test_that("error", {
  expect_snapshot(
    error = TRUE,
    withr::with_options(
      list(cli.palette = "foobar12"),
      ansi_palette_show(colors = 256)
    )
  )
})
