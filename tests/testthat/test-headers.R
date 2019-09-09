
context("cli headers")

setup(start_app())
teardown(stop_app())

test_that("headers", {
  cli_div(class = "testcli", theme = test_style())

  withr::with_options(list(crayon.enabled = TRUE, crayon.colors = 256), {
    out <- capt0(cli_h1("HEADER"))
    expect_true(crayon::has_style(out))
    expect_equal(crayon::strip_style(out), "\nHEADER\n\n")

    out <- capt0(cli_h2("Header"))
    expect_true(crayon::has_style(out))
    expect_equal(crayon::strip_style(out), "Header\n\n")

    out <- capt0(cli_h3("Header"))
    expect_true(crayon::has_style(out))
    expect_equal(crayon::strip_style(out), "Header\n")

    x <- "foobar"
    xx <- 100
    out <- capt0(cli_h2("{xx}. header: {x}"))
    expect_equal(crayon::strip_style(out), "\n100. header: foobar\n\n")
  })
})
