
test_that_cli(configs = c("plain", "unicode"), "list_border_styles", {
  expect_snapshot(
    for (st in list_border_styles()) print(boxx("", border_style = st))
  )
})
