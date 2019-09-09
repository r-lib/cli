
context("substitution")

setup(start_app())
teardown(stop_app())

test_that("glue errors", {
  expect_error(cli_h1("foo { asdfasdfasdf } bar"))
  expect_error(cli_text("foo {cmd {dsfsdf()}}"))
})
