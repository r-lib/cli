
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

test_that("is_utf8_output", {

  mockery::stub(
    is_utf8_output, "l10n_info",
    list(MBCS = TRUE, `UTF-8` = TRUE, `Latin-1` = FALSE)
  )
  withr::with_options(
    list(cli.unicode = NULL),
    expect_true(is_utf8_output())
  )

  mockery::stub(
    is_utf8_output, "l10n_info",
    list(MBCS = FALSE, `UTF-8` = FALSE, `Latin-1` = TRUE)
  )
  withr::with_options(
    list(cli.unicode = NULL),
    expect_false(is_utf8_output())
  )
})

test_that("is_latex_output", {

  mockery::stub(is_latex_output, "loadedNamespaces", "foobar")
  expect_false(is_latex_output())

  mockery::stub(is_latex_output, "loadedNamespaces", "knitr")
  mockery::stub(
    is_latex_output, "get",
    function(x, ...) {
      if (x == "is_latex_output") {
        function() TRUE
      } else {
        base::get(x, ...)
      }
    }
  )
  expect_true(is_latex_output())
})
