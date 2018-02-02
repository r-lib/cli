
context("cli headers")

test_that("headers", {
  clix$reset()
  clix$div(class = "testcli", theme = test_style())

  withr::with_options(list(crayon.enabled = TRUE, crayon.colors = 256), {
    out <- capt(clix$h1("HEADER"), print_it = FALSE)
    expect_true(crayon::has_style(out))
    expect_equal(crayon::strip_style(out), "\nHEADER\n")

    out <- capt(clix$h2("Header"), print_it = FALSE)
    expect_true(crayon::has_style(out))
    expect_equal(crayon::strip_style(out), "Header\n")

    out <- capt(clix$h3("Header"), print_it = FALSE)
    expect_true(crayon::has_style(out))
    expect_equal(crayon::strip_style(out), "Header")

    x <- "foobar"
    xx <- 100
    out <- capt(clix$h2("{xx}. header: {x}"), print_it = FALSE)
    expect_equal(crayon::strip_style(out), "\n100. header: foobar\n")
  })
})
