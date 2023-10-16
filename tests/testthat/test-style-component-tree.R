test_that("style_component_tree basic", {
  cpt <- cpt_div()
  cpt2 <- cpt_div(cpt_div())
  cpt3 <- cpt_div(cpt_text("foo {.emph bar} {.val {1:5}} end"))
  tree <- map_component_tree(cpt)
  tree2 <- map_component_tree(cpt2)
  tree3 <- map_component_tree(cpt3)

  expect_snapshot({
    style_component_tree(theme_component_tree(tree))
    style_component_tree(theme_component_tree(tree2))
    style_component_tree(theme_component_tree(tree3))
  })

  expect_snapshot({
    style_component_tree(theme_component_tree(
      tree,
      list(div = list(color = "green"))
    ))$style
    style_component_tree(theme_component_tree(
      tree2,
      list("div div" = list(color = "green"))
    ))$children[[1]]$style
    style_component_tree(theme_component_tree(
      tree3,
      list("span.val" = list(color = "green"))
    ))$children[[1]]$children[[4]]$style
  })

  expect_snapshot(error = TRUE, {
    style_component_tree(1:10)
  })

  expect_snapshot(error = TRUE, {
    style_component_tree(tree)
  })
})

test_that("inherited_styles", {
  expect_snapshot(inherited_styles())
})

test_that("inherit_styles", {
  expect_snapshot({
    inherit_styles(NULL, NULL, "foo")

    # not inherited
    inherit_styles(NULL, list(color = "red"))
    inherit_styles(list(color = "red"), NULL)
    inherit_styles(list(color = "red"), list(color = "green"))

    # inherited
    inherit_styles(NULL, list(collapse = "-"))
    inherit_styles(list(collapse = "|"), NULL)
    inherit_styles(list(collapse = "|"), list(collapse = "-"))

    # merged
    inherit_styles(NULL, list("class-map" = list(c = "foo")))
    inherit_styles(list("class-map" = list(c = "foo")), NULL)
    inherit_styles(
      list("class-map" = list(c = "foo"), d = "bar"),
      list("class-map" = list(d = "baz"))
    )
  })
})

test_that("style_component_tree classes", {
  cpt <- cpt_div(attr = list(class = "cl"))
  cpt2 <- cpt_div(cpt_div(), attr = list(class = "cl"))
  cpt3 <- cpt_div(
    cpt_text("foo {.emph bar} {.val {1:5}} end"),
    attr = list(class = "cl")
  )
  tree <- map_component_tree(cpt)
  tree2 <- map_component_tree(cpt2)
  tree3 <- map_component_tree(cpt3)

  expect_snapshot({
    style_component_tree(theme_component_tree(
      tree,
      list(.cl = list(color = "green"))
    ))$style
    style_component_tree(theme_component_tree(
      tree2,
      list(".cl div" = list(color = "green"))
    ))$children[[1]]$style
    style_component_tree(theme_component_tree(
      tree3,
      list(".cl span.val" = list(color = "green"))
    ))$children[[1]]$children[[4]]$style
  })
})

test_that("style_component_tree styles", {
  cpt <- cpt_div(attr = list(
    class = "cl",
    style = list(color = "red", "custom" = "grey")
  ))
  cpt2 <- cpt_div(
    attr = list(class = "cl"),
    cpt_div(
      attr = list(
        style = list(color = "red", custom = "grey")
      )
    )
  )
  cpt3 <- cpt_div(
    cpt_text("foo {.emph bar} "),
    cpt_span(
      cpt_text("1:5"),
      attr = list(
        class = "val",
        style = list("class-map" = list("rclass" = "cliclass"), digits = 10)
      )
    ),
    cpt_text(" end"),
    attr = list(class = "cl")
  )
  tree <- map_component_tree(cpt)
  tree2 <- map_component_tree(cpt2)
  tree3 <- map_component_tree(cpt3)


  ttree <- style_component_tree(theme_component_tree(
    tree,
    list(.cl = list(color = "green", custom2 = "foo", digits = 5))
  ))
  ttree2 <- style_component_tree(theme_component_tree(
    tree2,
    list(".cl div" = list(color = "green", custom2 = "foo", digits = 5))
  ))
  ttree3 <- style_component_tree(theme_component_tree(
    tree3,
    list(".cl span.val" = list(
      color = "green",
      "class-map" = list("rc2" = "c2"),
      digits = 5
    ))
  ))

  expect_snapshot({
    ttree[["style"]]
    ttree2[["children"]][[1]][["style"]]
    ttree3[["children"]][[2]][["style"]]
  })
})
