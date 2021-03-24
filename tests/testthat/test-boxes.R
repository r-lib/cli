
test_that("empty label", {
  expect_snapshot(boxx(""))
})

test_that("empty label 2", {
  expect_snapshot(boxx(character()))
})

test_that("label", {
  expect_snapshot(boxx("label"))
})

test_that("label vector", {
  expect_snapshot(boxx(c("label", "l2")))
})

test_that("border style", {
  expect_snapshot(boxx("label", border_style = "classic"))
})

test_that("padding", {
  expect_snapshot(boxx("label", padding = 2))
  expect_snapshot(boxx("label", padding = c(1,2,1,2)))
  expect_snapshot(boxx("label", padding = c(1,2,0,2)))
  expect_snapshot(boxx("label", padding = c(1,2,0,0)))
})

test_that("margin", {
  expect_snapshot(boxx("label", margin = 1))
  expect_snapshot(boxx("label", margin = c(1,2,3,4)))
  expect_snapshot(boxx("label", margin = c(0,1,2,0)))
})

test_that("float", {
  expect_snapshot(boxx("label", float = "center", width = 20))
  expect_snapshot(boxx("label", float = "right", width = 20))
})

test_that("background_col", {
  local_cli_config(num_colors = 256L)
  expect_snapshot(boxx("label", background_col = "red"))
  expect_snapshot(boxx("label", background_col = col_red))
})

test_that("border_col", {
  local_cli_config(num_colors = 256L)
  expect_snapshot(boxx("label", border_col = "red"))
  expect_snapshot(boxx("label", border_col = col_red))
})

test_that("align", {
  expect_snapshot(boxx(c("label", "l2"), align = "center"))
  expect_snapshot(boxx(c("label", "l2"), align = "right"))
})

test_that("header", {
  expect_snapshot(boxx("foobar", header = "foo"))
})

test_that("footer", {
  expect_snapshot(boxx("foobar", footer = "foo"))
})
