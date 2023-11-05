test_that("render_inline_text", {
  txt <- "This is text with {1:5} sub and {.emph style}."
  expect_snapshot({
    render_inline_text(cpt_txt(txt))
  })
})
