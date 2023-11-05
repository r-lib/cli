test_that("render", {
  txt <- "Labore aliquip deserunt mollit sint enim commodo cupidatat
          officia nulla id. Minim in adipisicing esse elit aute cillum
          anim quis officia."
  expect_snapshot({
    format(preview(cpt_div(cpt_txt(txt)), width = 40, theme = list()))
    format(preview(cpt_span(cpt_txt(txt)), theme = list()))
    format(preview(cpt_txt(txt), theme = list()))
  })

  cpt <- cpt_div()
  cpt[["tag"]] <- "foobar"
  expect_snapshot(error = TRUE, format(preview(cpt, theme = list())))
})

test_that("preview", {
  txt <- "Labore aliquip deserunt mollit sint enim commodo cupidatat
          officia nulla id. Minim in adipisicing esse elit aute cillum
          anim quis officia."
  expect_snapshot({
    preview(cpt_div(cpt_txt(txt)), width = 40, theme = list())
    preview(cpt_span(cpt_txt(txt)), width = 40, theme = list())
    preview(cpt_txt(txt), width = 40, theme = list())
  })
})

test_that("preview_generic", {
  txt <- "Labore aliquip deserunt mollit sint enim commodo cupidatat
          officia nulla id. Minim in adipisicing esse elit aute cillum
          anim quis officia."
  expect_snapshot({
    preview(cpt_div(cpt_txt(txt)), width = 40, theme = list())
  })
})

test_that("preview_text", {
  txt <- "Labore aliquip deserunt mollit sint enim commodo cupidatat
          officia nulla id. Minim in adipisicing esse elit aute cillum
          anim quis officia."
  expect_snapshot({
    preview(cpt_txt(txt), width = 40, theme = list())
  })
})

test_that("preview_span", {
  txt <- "Labore aliquip deserunt mollit sint enim commodo cupidatat
          officia nulla id. Minim in adipisicing esse elit aute cillum
          anim quis officia."
  expect_snapshot({
    preview(cpt_span(cpt_txt(txt)), width = 40, theme = list())
  })
})
