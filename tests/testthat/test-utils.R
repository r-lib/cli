
test_that("make_space", {
  expect_equal(make_space(0), "")
  expect_equal(make_space(1), " ")
  expect_equal(make_space(5), "     ")
})

test_that("apply_style", {
  expect_error(
    apply_style("text", raw(0)),
    "Not a colour name or ANSI style"
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
  expect_snapshot(
    ruler(20)
  )
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

test_that("dedent", {
  cases <- list(
    list("", 0, ""),
    list("", 1, ""),
    list("", 2, ""),
    list("x", 0, "x"),
    list("x", 1, "x"),
    list("x", 2, "x"),
    list("xx", 0, "xx"),
    list("xx", 1, "xx"),
    list("xx", 2, "xx"),
    list("foobar", 0, "foobar"),
    list("foobar", 1, "foobar"),
    list("foobar", 2, "foobar"),

    list(" ", 0, " "),
    list(" ", 1, ""),
    list(" ", 2, ""),
    list("  ", 0, "  "),
    list("  ", 1, " "),
    list("  ", 2, ""),
    list(" x", 0, " x"),
    list(" x", 1, "x"),
    list(" x", 2, "x"),
    list("  x", 0, "  x"),
    list("  x", 1, " x"),
    list("  x", 2, "x"),

    list(" x  y", 3, "x  y"),
    list(" x  y", 4, "x  y"),
    list(" x  y", 5, "x  y"),
    list(" x  ", 3, "x  "),
    list(" x  ", 4, "x  "),
    list(" x  ", 5, "x  ")
  )

  for (c in cases) expect_identical(dedent(c[[1]], c[[2]]), ansi_string(c[[3]]))
})

test_that("tail_na", {
  cases <- list(
    list(1:4, 4L),
    list(1, 1),
    list(double(), NA_real_),
    list(character(), NA_character_)
  )

  for (i in seq_along(cases)) {
    c <- cases[[i]]
    expect_identical(tail_na(c[[1]]), c[[2]], info = i)
  }

  cases2 <- list(
    list(1:4, 2, 3:4),
    list(1, 2, c(NA_real_, 1)),
    list(double(), 2, c(NA_real_, NA_real_)),
    list(character(), 2, c(NA_character_, NA_character_))
  )

  for (i in seq_along(cases2)) {
    c <- cases2[[i]]
    expect_identical(tail_na(c[[1]], c[[2]]), c[[3]], info = i)
  }
})
