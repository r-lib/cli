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

test_that("inherited_styles", {
  expect_snapshot(inherited_styles())
})

test_that("merge_styles", {
  expect_snapshot({
    merge_styles(NULL, NULL, "foo")

    # not inherited
    merge_styles(NULL, list(color = "red"))
    merge_styles(list(color = "red"), NULL)
    merge_styles(list(color = "red"), list(color = "green"))

    # inherited
    merge_styles(NULL, list(collapse = "-"))
    merge_styles(list(collapse = "|"), NULL)
    merge_styles(list(collapse = "|"), list(collapse = "-"))

    # merged
    merge_styles(NULL, list("class-map" = list(c = "foo")))
    merge_styles(list("class-map" = list(c = "foo")), NULL)
    merge_styles(
      list("class-map" = list(c = "foo"), d = "bar"),
      list("class-map" = list(d = "baz"))
    )
  })
})

test_that("inherit_style", {
  div <- cpt_div(attr = list(style = list(
    "class-map" = list(c = "bar", d = "bar"),
    color = "red",
    collapse = "|"
  )))

  sdiv <- inherit_style(div, list(
    "class-map" = list(c = "no", e = "baz"),
    color = "green",
    "background-color" = "grey",
    collapse = "-",
    "vec-sep" = ";"
  ))

  expect_snapshot(get_style(sdiv))

  # text pieces

  pcs <- parse_cli_text("foo {1:5} bar", environment())
  spc1 <- inherit_style(pcs[[1]], list(color = "green", collapse = "|"))
  expect_snapshot(attr(spc1, "style"))

  spc2 <- inherit_style(pcs[[2]], list(color = "green", collapse = "|"))
  expect_snapshot(spc2)
})
