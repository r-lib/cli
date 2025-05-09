test_that("Classes", {
  expect_equal(
    class(style_underline("foo")),
    c("cli_ansi_string", "ansi_string", "character")
  )
})

test_that("Coloring and highlighting works", {
  local_reproducible_output(crayon = TRUE)
  expect_equal(c(style_underline("foo")), "\u001b[4mfoo\u001b[24m")
  expect_equal(c(col_red("foo")), "\u001b[31mfoo\u001b[39m")
  expect_equal(c(bg_red("foo")), "\u001b[41mfoo\u001b[49m")
})

test_that("Applying multiple styles at once works", {
  local_reproducible_output(crayon = TRUE)
  st <- combine_ansi_styles(col_red, bg_green, "underline")
  expect_equal(
    c(st("foo")),
    "\u001b[31m\u001b[42m\u001b[4mfoo\u001b[24m\u001b[49m\u001b[39m"
  )
  st <- combine_ansi_styles(style_underline, "red", bg_green)
  expect_equal(
    c(st("foo")),
    "\u001b[4m\u001b[31m\u001b[42mfoo\u001b[49m\u001b[39m\u001b[24m"
  )
})

test_that("Nested styles are supported", {
  local_reproducible_output(crayon = TRUE)
  st <- combine_ansi_styles(style_underline, bg_blue)
  expect_equal(
    c(col_red("foo", st("bar"), "!")),
    "\u001b[31mfoo\u001b[4m\u001b[44mbar\u001b[49m\u001b[24m!\u001b[39m"
  )
})

test_that("Nested styles of the same type are supported", {
  local_reproducible_output(crayon = TRUE)
  expect_equal(
    c(col_red("a", col_blue("b", col_green("c"), "b"), "c")),
    "\u001b[31ma\u001b[34mb\u001b[32mc\u001b[34mb\u001b[31mc\u001b[39m"
  )
})

test_that("Reset all styles", {
  local_reproducible_output(crayon = TRUE)
  st <- combine_ansi_styles("red", bg_green, "underline")
  ok <- c(
    paste0(
      "\033[0m\033[31m\033[42m\033[4mfoo\033[24m\033[49m\033[39m",
      "foo\033[0m\033[22m\033[23m\033[24m\033[27m\033[28m",
      "\033[29m\033[39m\033[49m"
    ),
    paste0(
      "\u001b[0m\u001b[31m\u001b[42m\u001b[4mfoo\u001b[24m\u001b[49m",
      "\u001b[39mfoo\u001b[0m"
    )
  )
  expect_true(style_reset(st("foo"), "foo") %in% ok)
})

test_that("Variable number of arguments", {
  local_reproducible_output(crayon = TRUE)
  expect_equal(c(col_red("foo", "bar")), "\u001b[31mfoobar\u001b[39m")
})

test_that("print.cli_ansi_style", {
  expect_snapshot(
    print(col_red)
  )
})

test_that("print.cli_ansi_string", {
  withr::local_options(cli.num_colors = 256)
  expect_snapshot(
    print(col_red("red"))
  )
})

test_that("ansi-scale", {
  expect_snapshot({
    ansi_scale(c(0, 0, 0))
    ansi_scale(c(255, 100, 0))
    ansi_scale(c(255, 100, 0), round = FALSE)
  })
})

test_that("zero length vectors", {
  withr::local_options(cli.num_colors = 1)
  expect_equal(length(col_cyan(character())), 0)
  expect_equal(length(bg_cyan(character())), 0)
  expect_equal(length(col_br_cyan(character())), 0)
  expect_equal(length(bg_br_cyan(character())), 0)

  withr::local_options(cli.num_colors = 8)
  expect_equal(length(col_cyan(character())), 0)
  expect_equal(length(bg_cyan(character())), 0)
  expect_equal(length(col_br_cyan(character())), 0)
  expect_equal(length(bg_br_cyan(character())), 0)

  withr::local_options(cli.num_colors = 256)
  expect_equal(length(col_cyan(character())), 0)
  expect_equal(length(bg_cyan(character())), 0)
  expect_equal(length(col_br_cyan(character())), 0)
  expect_equal(length(bg_br_cyan(character())), 0)

  withr::local_options(cli.num_colors = truecolor)
  expect_equal(length(col_cyan(character())), 0)
  expect_equal(length(bg_cyan(character())), 0)
  expect_equal(length(col_br_cyan(character())), 0)
  expect_equal(length(bg_br_cyan(character())), 0)
})
