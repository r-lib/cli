
test_that("custom handler works", {
  conds <- list()
  withr::with_options(
    list(cli.default_handler = function(msg) conds <<- c(conds, list(msg))),
    { cli_h1("title"); cli_h2("subtitle"); cli_text("text") }
  )
  expect_equal(length(conds), 3)
  lapply(conds, expect_s3_class, "cli_message")
  expect_equal(conds[[1]]$type, "h1")
  expect_equal(conds[[2]]$type, "h2")
  expect_equal(conds[[3]]$type, "text")
})
