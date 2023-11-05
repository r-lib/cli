test_that("map_component_tree", {
  cpt <- cpt_div()
  cpt2 <- cpt_div(cpt_div())
  cpt3 <- cpt_div(cpt_txt("foo {.emph bar} {.val {1:5}} end"))
  expect_snapshot({
    map_component_tree(cpt)
    map_component_tree(cpt2)
    map_component_tree(cpt3)
  })

  expect_snapshot({
    map_component_tree(cpt2)$children[[1]]
    map_component_tree(cpt3)$children[[1]]$children
  })

  expect_snapshot(error = TRUE, {
    map_component_tree(1:10)
  })
})

test_that("parse_class_attr", {
  expect_snapshot({
    parse_class_attr(NULL)
    parse_class_attr(character())
    parse_class_attr("")
    parse_class_attr("foo")
    parse_class_attr(" foo")
    parse_class_attr("  foo")
    parse_class_attr("foo ")
    parse_class_attr("foo  ")
    parse_class_attr("foo bar")
    parse_class_attr("foo  bar")
  })
})
