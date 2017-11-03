
context("utils")

test_that("make_space", {
  expect_equal(make_space(0), "")
  expect_equal(make_space(1), " ")
  expect_equal(make_space(5), "     ")
})

test_that("apply_style", {
  expect_error(
    apply_style("text", raw(0)),
    "Not a colour name or crayon style"
  )
})

test_that("viapply", {
  expect_equal(
    viapply(c("foo", "foobar"), length),
    vapply(c("foo", "foobar"), length, integer(1))
  )

  expect_equal(
    viapply(character(), length),
    vapply(character(), length, integer(1))
  )
})

test_that("ruler", {
  out <- capt0(ruler(20))
  exp <- rebox(
    "----+----1----+----2",
    "12345678901234567890"
  )
  expect_equal(crayon::strip_style(out), exp)
})

test_that("rpad", {
  expect_equal(rpad(character()), character())
  expect_equal(rpad("foo"), "foo")
  expect_equal(rpad(c("foo", "foobar")), c("foo   ", "foobar"))
})

test_that("lpad", {
  expect_equal(lpad(character()), character())
  expect_equal(lpad("foo"), "foo")
  expect_equal(lpad(c("foo", "foobar")), c("   foo", "foobar"))
})
