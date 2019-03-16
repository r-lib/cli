
context("cat helpers")

test_that("cat_line", {
  out <- capt00(cat_line("This is ", "a ", "line of text."))
  exp <- rebox("This is a line of text.")
  expect_equal(out, exp)

  if (!has_crayon()) return()

  withr::with_options(
    list(crayon.enabled = TRUE, crayon.colors = 256), {
      out <- capt00(cat_line("This is ", "a ", "line of text.", col = "red"))
      expect_true(crayon::has_style(out))
      exp <- rebox("This is a line of text.")
      expect_equal(crayon::strip_style(out), exp)

      out <- capt00(cat_line("This is ", "a ", "line of text.",
                            background_col = "green"))
      expect_true(crayon::has_style(out))
      exp <- rebox("This is a line of text.")
      expect_equal(crayon::strip_style(out), exp)
    }
  )

  tmp <- tempfile()
  on.exit(unlink(tmp), add = TRUE)
  cat_line("This is ", "a ", "line of text.", file = tmp)
  exp <- rebox("This is a line of text.")
  expect_equal(readLines(tmp, warn = FALSE), exp)
})

test_that("cat_bullet", {
  out <- capt00(cat_bullet(letters[1:5]))
  exp <- rebox("● a\n● b\n● c\n● d\n● e")
  expect_equal(out, exp)
})

test_that("cat_boxx", {
  out <- capt00(cat_boxx("foo"))
  exp <- rebox(
    "┌─────────┐",
    "│         │",
    "│   foo   │",
    "│         │",
    "└─────────┘")
  expect_equal(out, exp)
})

test_that("cat_rule", {
  out <- withr::with_options(
    c(cli.width = 20),
    capt00(cat_rule("title"))
  )
  exp <- rebox("── title ───────────")
  expect_equal(out, exp)
})

test_that("cat_print", {
  out <- capt00(cat_print(boxx("")))
  exp <- rebox(
    "┌──────┐",
    "│      │",
    "│      │",
    "│      │",
    "└──────┘")
  expect_equal(out, exp)

  tmp <- tempfile()
  on.exit(unlink(tmp), add = TRUE)
  expect_silent(cat_print(boxx(""), file = tmp))
  expect_equal(paste(readLines(tmp, warn = FALSE), collapse = "\n"), exp)
})
