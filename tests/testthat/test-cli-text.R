
context("cli text")

test_that("text is wrapped", {
  clix$reset()
  clix$div(class = "testcli", theme = test_style())

  withr::with_options(c(cli.width = 60), {
    capt(clix$h1("Header"))
    out <- capt(clix$text(lorem_ipsum()), print_it = FALSE)
    len <- nchar(strsplit(out, "\n", fixed = TRUE)[[1]])
    expect_true(all(len <= 60))
  })
})

test_that("verbatim text is not wrapped", {
  clix$reset()
  clix$div(class = "testcli", theme = test_style())

  withr::with_options(c(cli.width = 60), {
    capt(clix$h1("Header"))
    txt <- strrep("1234567890 ", 20)
    out <- capt(clix$verbatim(txt), print_it = FALSE)
    expect_equal(out, txt)
  })
})

test_that("md text is not implemented yet", {
  expect_error(
    clix$md_text("# Header\n\n* item 1\n* item 2\n\nFoobar\n"),
    "not implemented"
  )
})

test_that("blockquote is not implemented yet", {
  expect_error(
    clix$blockquote("This is a quote", "by somebody"),
    "not implemented"
  )
})

test_that("table is not implemented yet", {
  expect_error(clix$table(iris), "not implemented")
})
