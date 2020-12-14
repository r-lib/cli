
context("ansi combine_ansi_styles")

test_that("one style", {
  testthat::skip_on_covr()
  expect_equal(combine_ansi_styles(col_red), col_red)
  expect_equal(combine_ansi_styles(style_bold), style_bold)
})

test_that("style objects", {
  withr::with_options(
    list(cli.num_colots = 256L), {
      expect_equal(
        combine_ansi_styles(col_red, style_bold)("blah"),
        col_red(style_bold("blah"))
      )
      expect_equal(
        combine_ansi_styles(col_red, style_bold, style_underline)("foo"),
        col_red(style_bold(style_underline("foo")))
      )
    }
  )
})

test_that("create styles on the fly", {
  withr::with_options(
    list(cli.num_colors = 256L), {
      expect_equal(
        combine_ansi_styles("darkolivegreen", style_bold)("blah"),
        make_ansi_style("darkolivegreen")((style_bold("blah")))
      )
      expect_equal(
        combine_ansi_styles(style_bold, "darkolivegreen", style_underline)("foo"),
        style_bold(make_ansi_style("darkolivegreen")(style_underline("foo")))
      )
    }
  )
})
