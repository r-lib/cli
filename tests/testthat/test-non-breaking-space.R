
context("non breaking space")

test_that("does not break", {
  op <- options(cli.width = 40)
  on.exit(options(op))
  str30 <- "123456789 123456789 1234567890"
  out <- capt0(cli_text(c(str30, "this\u00a0is\u00a0not\u00a0breaking")))
  expect_equal(
    ansi_strip(out),
    "123456789 123456789\n1234567890this is not breaking\n"
  )
})
