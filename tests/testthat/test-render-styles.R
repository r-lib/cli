test_that_cli("hardcoded style", configs = c("plain", "ansi"), {
  txt <- "Labore aliquip deserunt mollit sint enim commodo cupidatat
          officia nulla id. Minim in adipisicing esse elit aute cillum
          anim quis officia."
  cpt <- cpt_div(cpt_txt(txt), attr = list(style = list(color = "green")))
  ccpt <- style_component_tree(theme_component_tree(map_component_tree(cpt)))
  expect_snapshot({
    preview(ccpt, width = 40)
  })
})

test_that_cli("themed style", configs = c("plain", "ansi"), {
  txt <- "Labore aliquip deserunt mollit sint enim commodo cupidatat
          officia nulla id. Minim in adipisicing esse elit aute cillum
          anim quis officia."
  cpt <- cpt_div(cpt_txt(txt))
  theme <- list(div = list(color = "orange"))
  ccpt <- style_component_tree(theme_component_tree(
    map_component_tree(cpt),
    theme = theme
  ))
  expect_snapshot({
    preview(ccpt, width = 40)
  })
})

test_that_cli("inherited style", configs = c("plain", "ansi"), {
  txt <- "Some numbers: {.val {1:10}}."
  cpt <- cpt_div(cpt_txt(txt))
  theme <- list(
    div = list(color = "orange", "vec-sep" = " -> "),
    span.val = list(color = "blue")
  )
  ccpt <- style_component_tree(theme_component_tree(
    map_component_tree(cpt),
    theme = theme
  ))
  expect_snapshot({
    preview(ccpt, width = 40)
  })
})
