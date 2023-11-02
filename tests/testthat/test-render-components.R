test_that("render", {
  txt <- "Labore aliquip deserunt mollit sint enim commodo cupidatat
          officia nulla id. Minim in adipisicing esse elit aute cillum
          anim quis officia."
  expect_snapshot({
    render(cpt_div(cpt_text(txt)), width = 40, theme = list())
    render(cpt_span(cpt_text(txt)), theme = list())
    render(cpt_text(txt), theme = list())
  })

  cpt <- cpt_div()
  cpt[["tag"]] <- "foobar"
  expect_snapshot(error = TRUE, render(cpt, theme = list()))
})

test_that("preview", {
  txt <- "Labore aliquip deserunt mollit sint enim commodo cupidatat
          officia nulla id. Minim in adipisicing esse elit aute cillum
          anim quis officia."
  expect_snapshot({
    preview(cpt_div(cpt_text(txt)), width = 40, theme = list())
    preview(cpt_span(cpt_text(txt)), width = 40, theme = list())
    preview(cpt_text(txt), width = 40, theme = list())
  })
})

test_that("preview_generic", {
  txt <- "Labore aliquip deserunt mollit sint enim commodo cupidatat
          officia nulla id. Minim in adipisicing esse elit aute cillum
          anim quis officia."
  expect_snapshot({
    preview_generic(cpt_div(cpt_text(txt)), width = 40, theme = list())
  })
})

test_that("preview_text", {
  txt <- "Labore aliquip deserunt mollit sint enim commodo cupidatat
          officia nulla id. Minim in adipisicing esse elit aute cillum
          anim quis officia."
  expect_snapshot({
    preview_text(cpt_text(txt), width = 40, theme = list())
  })
})

test_that("preview_span", {
  txt <- "Labore aliquip deserunt mollit sint enim commodo cupidatat
          officia nulla id. Minim in adipisicing esse elit aute cillum
          anim quis officia."
  expect_snapshot({
    preview_span(cpt_span(cpt_text(txt)), width = 40, theme = list())
  })
})
