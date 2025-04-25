test_that("is_windows", {
  expect_equal(is_windows(), .Platform$OS.type == "windows")
})

test_that("make_space", {
  expect_equal(make_space(0), "")
  expect_equal(make_space(1), " ")
  expect_equal(make_space(5), "     ")
})

test_that("apply_style", {
  expect_error(
    apply_style("text", raw(0)),
    "must be a color name or an ANSI style function"
  )
  expect_equal(
    apply_style("foo", function(x) toupper(x)),
    "FOO"
  )

  withr::local_options(cli.num_ansi_colors = truecolor)
  expect_equal(
    apply_style("foo", "red"),
    col_red("foo")
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
  local_mocked_bindings(
    l10n_info = function() list(MBCS = TRUE, `UTF-8` = TRUE, `Latin-1` = FALSE)
  )
  withr::with_options(
    list(cli.unicode = NULL),
    expect_true(is_utf8_output())
  )

  local_mocked_bindings(
    l10n_info = function() list(MBCS = FALSE, `UTF-8` = FALSE, `Latin-1` = TRUE)
  )
  withr::with_options(
    list(cli.unicode = NULL),
    expect_false(is_utf8_output())
  )
})

test_that("is_latex_output", {
  local_mocked_bindings(loadedNamespaces = function() "foobar")
  expect_false(is_latex_output())

  local_mocked_bindings(
    loadedNamespaces = function() "knitr",
    get = function(x, ...) {
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

test_that("get_ppid", {
  expect_equal(
    ps::ps_ppid(),
    get_ppid()
  )
})

test_that("na.omit", {
  expect_snapshot({
    na.omit(character())
    na.omit(integer())
    na.omit(1:5)
    na.omit(c(1, NA, 2, NA))
    na.omit(c(NA_integer_, NA_integer_))
    na.omit(list(1, 2, 3))
  })
})

test_that("get_rstudio_theme", {
  local_mocked_bindings(
    getThemeInfo = function() function(...) warning("just a word"),
    .package = "rstudioapi"
  )
  expect_silent(get_rstudio_theme())
})

test_that("try_silently", {
  expect_silent(
    try_silently(1:10)
  )
  expect_s3_class(
    try_silently(stop("not this")),
    "error"
  )
})

test_that("str_trim", {
  expect_snapshot({
    str_trim("foo")
    str_trim(character())
    str_trim("   foo")
    str_trim("foo  ")
    str_trim("   foo  ")
    str_trim(c(NA_character_, " foo  ", NA_character_, "  bar  "))
  })
})

test_that("leading_space", {
  testthat::local_reproducible_output(unicode = TRUE)
  expect_snapshot({
    paste0("-", leading_space("foo"), "-")
    paste0("-", leading_space("  foo"), "-")
    paste0("-", leading_space("  foo  "), "-")
    paste0("-", leading_space(" \t foo  "), "-")
    paste0("-", leading_space("\u00a0foo  "), "-")
    paste0("-", leading_space(" \u00a0 foo  "), "-")
  })
})

test_that("trailing_space", {
  testthat::local_reproducible_output(unicode = TRUE)
  expect_snapshot({
    paste0("-", trailing_space("foo"), "-")
    paste0("-", trailing_space("foo  "), "-")
    paste0("-", trailing_space("  foo  "), "-")
    paste0("-", trailing_space("  foo \t "), "-")
    paste0("-", trailing_space("  foo\u00a0"), "-")
    paste0("-", trailing_space(" \u00a0 foo \u00a0 "), "-")
  })
})

test_that("abbrev", {
  expect_snapshot({
    abbrev("123456789012345")
    abbrev("12345678901")
    abbrev("1234567890")
    abbrev("123456789")
    abbrev("12345")
    abbrev("1")
    abbrev("")
    abbrev("\033[31m1234567890\033[39m")
    abbrev(c("\033[31m1234567890\033[39m", "", "1234567890123"), 5)
    abbrev(rep("\033[31m1234567890\033[39m", 5), 5)
  })
})
