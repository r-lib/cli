
start_app()
on.exit(stop_app(), add = TRUE)

test_that("glue errors", {
  expect_error(cli_h1("foo { asdfasdfasdf } bar"))
  expect_error(cli_text("foo {cmd {dsfsdf()}}"))
})
