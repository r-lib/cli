
test_that("does not break", {
  expect_snapshot(local({
    withr::local_options(cli.width = 40)
    str30 <- "123456789 123456789 1234567890"
    cli_text(c(str30, "this\u00a0is\u00a0not\u00a0breaking"))
  }))
})
