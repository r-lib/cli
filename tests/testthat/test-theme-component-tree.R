test_that("theme_component_tree basic", {
  cpt <- cpt_div()
  cpt2 <- cpt_div(cpt_div())
  cpt3 <- cpt_div(cpt_txt("foo {.emph bar} {.val {1:5}} end"))
  tree <- map_component_tree(cpt)
  tree2 <- map_component_tree(cpt2)
  tree3 <- map_component_tree(cpt3)

  expect_snapshot({
    theme_component_tree(tree)
    theme_component_tree(tree2)
    theme_component_tree(tree3)
  })

  expect_snapshot({
    theme_component_tree(tree, list(div = list(color = "green")))$prestyle
    theme_component_tree(
      tree2,
      list("div div" = list(color = "green"))
    )$children[[1]]$prestyle
    theme_component_tree(
      tree3,
      list("span.val" = list(color = "green"))
    )$children[[1]]$children[[4]]$prestyle
  })

  expect_snapshot(error = TRUE, {
    theme_component_tree(cpt)
  })
})

test_that("theme_component_tree classes", {
  cpt <- cpt_div(attr = list(class = "cl"))
  cpt2 <- cpt_div(cpt_div(), attr = list(class = "cl"))
  cpt3 <- cpt_div(
    cpt_txt("foo {.emph bar} {.val {1:5}} end"),
    attr = list(class = "cl")
  )
  tree <- map_component_tree(cpt)
  tree2 <- map_component_tree(cpt2)
  tree3 <- map_component_tree(cpt3)

  expect_snapshot({
    theme_component_tree(tree, list(.cl = list(color = "green")))$prestyle
    theme_component_tree(
      tree2,
      list(".cl div" = list(color = "green"))
    )$children[[1]]$prestyle
    theme_component_tree(
      tree3,
      list(".cl span.val" = list(color = "green"))
    )$children[[1]]$children[[4]]$prestyle
  })
})

test_that("theme_component_tree styles", {
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
    cpt_txt("foo {.emph bar} "),
    cpt_span(
      cpt_txt("1:5"),
      attr = list(
        class = "val",
        style = list("class-map" = list("rclass" = "cliclass"), digits = 10)
      )
    ),
    cpt_txt(" end"),
    attr = list(class = "cl")
  )
  tree <- map_component_tree(cpt)
  tree2 <- map_component_tree(cpt2)
  tree3 <- map_component_tree(cpt3)


  ttree <- theme_component_tree(
    tree,
    list(.cl = list(color = "green", custom2 = "foo"))
  )
  ttree2 <- theme_component_tree(
    tree2,
    list(".cl div" = list(color = "green", custom2 = "foo"))
  )
  ttree3 <- theme_component_tree(
    tree3,
    list(".cl span.val" = list(
      color = "green",
      "class-map" = list("rc2" = "c2")
    ))
  )

  expect_snapshot({
    ttree[["prestyle"]]
    ttree2[["children"]][[1]][["prestyle"]]
    ttree3[["children"]][[2]][["prestyle"]]
  })
})
