
test_that("strwrap_fixed", {
  skip_on_os("windows")
  expect_equal(
    strwrap2_fixed("\U0001F477 1 2 3", 4),
    c("\U0001f477", "1 2", "3")
  )
})
