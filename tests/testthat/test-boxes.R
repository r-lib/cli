
test_that_cli(configs = c("plain", "unicode"), "empty label", {
  expect_snapshot(boxx(""))
})

test_that_cli(configs = c("plain", "unicode"), "empty label 2", {
  expect_snapshot(boxx(character()))
})

test_that_cli(configs = c("plain", "unicode"), "label", {
  expect_snapshot(boxx("label"))
})

test_that_cli(configs = c("plain", "unicode"), "label vector", {
  expect_snapshot(boxx(c("label", "l2")))
})

test_that_cli(configs = c("plain", "unicode"), "border style", {
  expect_snapshot(boxx("label", border_style = "classic"))
})

test_that_cli(configs = c("plain", "unicode"), "padding", {
  expect_snapshot(boxx("label", padding = 2))
  expect_snapshot(boxx("label", padding = c(1,2,1,2)))
  expect_snapshot(boxx("label", padding = c(1,2,0,2)))
  expect_snapshot(boxx("label", padding = c(1,2,0,0)))
})

test_that_cli(configs = c("plain", "unicode"), "margin", {
  expect_snapshot(boxx("label", margin = 1))
  expect_snapshot(boxx("label", margin = c(1,2,3,4)))
  expect_snapshot(boxx("label", margin = c(0,1,2,0)))
})

test_that_cli(configs = c("plain", "unicode"), "float", {
  expect_snapshot(boxx("label", float = "center", width = 20))
  expect_snapshot(boxx("label", float = "right", width = 20))
})

test_that_cli("background_col", {
  expect_snapshot(boxx("label", background_col = "red"))
  expect_snapshot(boxx("label", background_col = col_red))
})

test_that_cli("border_col", {
  expect_snapshot(boxx("label", border_col = "red"))
  expect_snapshot(boxx("label", border_col = col_red))
})

test_that_cli(configs = c("plain", "unicode"), "align", {
  expect_snapshot(boxx(c("label", "l2"), align = "center"))
  expect_snapshot(boxx(c("label", "l2"), align = "right"))
})

test_that_cli(configs = c("plain", "unicode"), "header", {
  expect_snapshot(boxx("foobar", header = "foo"))
})

test_that_cli(configs = c("plain", "unicode"), "footer", {
  expect_snapshot(boxx("foobar", footer = "foo"))
})
