
setup(start_app())
teardown(stop_app())

test_that("issue #154", {
  out <- capt0(cli_code("a\nb\nc"))
  expect_equal(out, "a\nb\nc\n")
})
