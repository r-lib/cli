
context("crayon combine_ansi_styles")

test_that("style objects", {
  withr::with_options(
    list(crayon.enabled = TRUE, crayon.colors = 256), {
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
    list(crayon.enabled = TRUE, crayon.colors = 256), {
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
