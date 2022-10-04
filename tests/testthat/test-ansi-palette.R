
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

test_that("custom palettes", {
  withr::local_options(
    cli.num_colors = 256,
    cli.palette = "iterm-snazzy"
  )
  expect_snapshot({
    col_black("black")
    col_red("red")
    col_green("green")
    col_yellow("yellow")
    col_blue("blue")
    col_magenta("magenta")
    col_cyan("cyan")
    col_white("white")

    col_br_black("br_black")
    col_br_red("br_red")
    col_br_green("br_green")
    col_br_yellow("br_yellow")
    col_br_blue("br_blue")
    col_br_magenta("br_magenta")
    col_br_cyan("br_cyan")
    col_br_white("br_white")
  })
})
