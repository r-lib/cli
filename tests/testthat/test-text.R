
start_app()
on.exit(stop_app(), add = TRUE)

test_that("text is wrapped", {
  expect_snapshot(local({
    cli_div(class = "testcli", theme = test_style())
    withr::local_options(cli.width = 60)
    withr::local_rng_version("3.5.0")
    withr::local_seed(42)
    cli_h1("Header")
    cli_text(lorem_ipsum())
  }))
})

test_that("verbatim text is not wrapped", {
  cli_div(class = "testcli", theme = test_style())
  withr::local_options(cli.width = 60)
  suppressMessages(cli_h1("Header"))
  txt <- strrep("1234567890 ", 20)
  out <- capt0(cli_verbatim(txt), strip_style = TRUE)
  expect_equal(out, paste0(txt, "\n"))
})
