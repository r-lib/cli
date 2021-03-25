
test_that("one style", {
  testthat::skip_on_covr() # because we are comparing functions
  expect_equal(
    combine_ansi_styles(col_red),
    col_red,
    ignore_function_env = TRUE
  )
  expect_equal(
    combine_ansi_styles(style_bold),
    style_bold,
    ignore_function_env = TRUE
  )
})

test_that_cli(configs = c("plain", "ansi"), "style objects", {
  expect_equal(
    combine_ansi_styles(col_red, style_bold)("blah"),
    col_red(style_bold("blah"))
  )
  expect_equal(
    combine_ansi_styles(col_red, style_bold, style_underline)("foo"),
    col_red(style_bold(style_underline("foo")))
  )
})

test_that_cli(configs = c("plain", "ansi"), "create styles on the fly", {
  expect_equal(
    combine_ansi_styles("darkolivegreen", style_bold)("blah"),
    make_ansi_style("darkolivegreen")((style_bold("blah")))
  )
  expect_equal(
    combine_ansi_styles(style_bold, "darkolivegreen", style_underline)("foo"),
    style_bold(make_ansi_style("darkolivegreen")(style_underline("foo")))
  )
})
