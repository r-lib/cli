
context("cat helpers")

test_that("cat_line", {
  out <- capt0(cat_line("This is ", "a ", "line of text."))
  exp <- rebox("This is a line of text.")
  expect_equal(out, exp)

  withr::with_options(
    list(crayon.enabled = TRUE, crayon.colors = 256), {
      out <- capt0(cat_line("This is ", "a ", "line of text.", col = "red"))
      expect_true(crayon::has_style(out))
      exp <- rebox("This is a line of text.")
      expect_equal(crayon::strip_style(out), exp)

      out <- capt0(cat_line("This is ", "a ", "line of text.",
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
  out <- capt0(cat_bullet(letters[1:5]))
  exp <- rebox("● a\n● b\n● c\n● d\n● e")
  expect_equal(out, exp)
})

test_that("cat_boxx", {
  out <- capt0(cat_boxx("foo"))
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
    capt0(cat_rule("title"))
  )
  exp <- rebox("── title ───────────")
  expect_equal(out, exp)
})

test_that("cat_print", {
  out <- capt0(cat_print(boxx("")))
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
