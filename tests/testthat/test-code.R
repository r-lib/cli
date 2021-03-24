
start_app()
on.exit(stop_app(), add = TRUE)

test_that("issue #154", {
  expect_snapshot({
    cli_code("a\nb\nc")
  })
})
