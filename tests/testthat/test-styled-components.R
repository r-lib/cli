test_that("new_styled_component", {
  div <- cpt_div(cpt_text("foo"))
  sdiv <- new_styled_component(div, list("margin-left" = 2))
  expect_snapshot(sdiv)
})

test_that("as_component", {
  div <- cpt_div(cpt_text("foo"))
  sdiv <- new_styled_component(div, list("margin-left" = 2))
  expect_equal(div, as_component(div))
  expect_equal(div, as_component(sdiv))
  expect_snapshot(
    error = TRUE,
    as_component(1:10)
  )
})

test_that("as_styled_component", {
  div <- cpt_div(cpt_text("foo"))
  sdiv <- new_styled_component(div, list("margin-left" = 2))
  expect_equal(sdiv, as_styled_component(sdiv))
  expect_equal(div, as_component(as_styled_component(div)))

  div <- cpt_div(cpt_text("foo"), attr = list(style = list(color = "red")))
  expect_snapshot(
    get_style(as_styled_component(div))
  )

  expect_snapshot(
    error = TRUE,
    as_styled_component(1:10)
  )
})
