test_that("make_style without name", {
  pink <- make_ansi_style("pink")
  expect_true(inherits(pink, "cli_ansi_style"))
})

test_that("hexa color regex works", {
  positive <- c(
    "#000000",
    "#ffffff",
    "#0f0f0f",
    "#f0f0f0",
    "#00000000",
    "#ffffffff",
    "#0f0f0f00",
    "#f0f0f055"
  )

  negative <- c(
    "",
    "#12345",
    "123456",
    "1234567",
    "12345678",
    "#1234567",
    "#1234ffg",
    "#gggggx",
    "foo#123456",
    "foo#123456bar"
  )

  for (color in positive) {
    expect_true(grepl(hash_color_regex, color))
    expect_true(grepl(hash_color_regex, toupper(color)))
  }

  for (color in negative) {
    expect_false(grepl(hash_color_regex, color))
    expect_false(grepl(hash_color_regex, toupper(color)))
  }
})

test_that("we fall back for ANSI 8 if needed", {
  yellow3 <- make_ansi_style("yellow3", colors = 8)
  expect_equal(yellow3("foobar"), col_yellow("foobar"))
})

test_that("we can create a style from an R color", {
  red4 <- make_ansi_style("red4")
  red_text <- red4("text")
  expect_true(num_ansi_colors() == 1 || ansi_has_any(red_text))
})

test_that("errors", {
  expect_snapshot(
    error = TRUE,
    make_ansi_style(1:10)
  )
})

test_that("make_ansi_style", {
  withr::local_options(cli.num_colors = 256)
  cf <- crayon::red
  expect_equal(
    make_ansi_style(cf)("foo"),
    col_red("foo")
  )

  expect_equal(
    make_ansi_style("dim")("foo"),
    style_blurred("foo")
  )

  expect_equal(
    make_ansi_style("red", bg = TRUE)("red"),
    bg_red("red")
  )

  expect_equal(
    make_ansi_style(cbind(c(200, 200, 100)), grey = TRUE)("200-200-100"),
    ansi_string("\033[38;5;250m200-200-100\033[39m")
  )

  withr::local_options(cli.num_colors = truecolor)
  expect_equal(
    make_ansi_style(cbind(c(200, 200, 100)))("200-200-100"),
    ansi_string("\033[38;2;200;200;100m200-200-100\033[39m")
  )

  expect_equal(
    make_ansi_style(cbind(c(200, 200, 100)), bg = TRUE)("200-200-100"),
    ansi_string("\033[48;2;200;200;100m200-200-100\033[49m")
  )

  # errors
  expect_snapshot(
    error = TRUE,
    make_ansi_style(1:10)
  )

  expect_snapshot(
    error = TRUE,
    make_ansi_style("foobar")
  )
})
