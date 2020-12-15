
context("cli headers")

setup(start_app())
teardown(stop_app())

test_that("headers", {
  cli_div(class = "testcli", theme = test_style())

  withr::with_options(list(cli.num_colors = 256L), {
    out <- capt0(cli_h1("HEADER"))
    expect_true(ansi_has_any(out))
    expect_equal(ansi_strip(out), "\nHEADER\n\n")

    out <- capt0(cli_h2("Header"))
    expect_true(ansi_has_any(out))
    expect_equal(ansi_strip(out), "Header\n\n")

    out <- capt0(cli_h3("Header"))
    expect_true(ansi_has_any(out))
    expect_equal(ansi_strip(out), "Header\n")

    x <- "foobar"
    xx <- 100
    out <- capt0(cli_h2("{xx}. header: {x}"))
    expect_equal(ansi_strip(out), "\n100. header: foobar\n\n")
  })
})
