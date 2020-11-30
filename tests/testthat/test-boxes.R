
context("boxes")

test_that("empty label", {
  out <- capt(boxx(""))
  exp <- rebox(
    "┌──────┐",
    "│      │",
    "│      │",
    "│      │",
    "└──────┘")
  expect_equal(out, exp)
})

test_that("empty label 2", {
  out <- capt(boxx(character()))
  exp <- rebox(
    "┌──────┐",
    "│      │",
    "│      │",
    "└──────┘")
  expect_equal(out, exp)
})

test_that("label", {
  out <- capt(boxx("label"))
  exp <- rebox(
    "┌───────────┐",
    "│           │",
    "│   label   │",
    "│           │",
    "└───────────┘")
  expect_equal(out, exp)
})

test_that("label vector", {
  out <- capt(boxx(c("label", "l2")))
  exp <- rebox(
    "┌───────────┐",
    "│           │",
    "│   label   │",
    "│   l2      │",
    "│           │",
    "└───────────┘")
  expect_equal(out, exp)
})

test_that("border style", {
  out <- capt(boxx("label", border_style = "classic"))
  exp <- rebox(
    "+-----------+",
    "|           |",
    "|   label   |",
    "|           |",
    "+-----------+")
  expect_equal(out, exp)
})

test_that("padding", {
  out <- capt(boxx("label", padding = 2))
  exp <- rebox(
    "┌─────────────────┐",
    "│                 │",
    "│                 │",
    "│      label      │",
    "│                 │",
    "│                 │",
    "└─────────────────┘")
  expect_equal(out, exp)

  out <- capt(boxx("label", padding = c(1,2,1,2)))
  exp <- rebox(
    "┌─────────┐",
    "│         │",
    "│  label  │",
    "│         │",
    "└─────────┘")
  expect_equal(out, exp)

  out <- capt(boxx("label", padding = c(1,2,0,2)))
  exp <- rebox(
    "┌─────────┐",
    "│  label  │",
    "│         │",
    "└─────────┘")
  expect_equal(out, exp)

  out <- capt(boxx("label", padding = c(1,2,0,0)))
  exp <- rebox(
    "┌───────┐",
    "│  label│",
    "│       │",
    "└───────┘")
  expect_equal(out, exp)
})

test_that("margin", {
  out <- capt(boxx("label", margin = 1))
  exp <- rebox("",
    "   ┌───────────┐",
    "   │           │",
    "   │   label   │",
    "   │           │",
    "   └───────────┘", "")
  expect_equal(out, exp)

  out <- capt(boxx("label", margin = c(1,2,3,4)))
  exp <- rebox("", "", "",
    "  ┌───────────┐",
    "  │           │",
    "  │   label   │",
    "  │           │",
    "  └───────────┘", "")
  expect_equal(out, exp)

  out <- capt(boxx("label", margin = c(0,1,2,0)))
  exp <- rebox("", "",
    " ┌───────────┐",
    " │           │",
    " │   label   │",
    " │           │",
    " └───────────┘")
  expect_equal(out, exp)
})

test_that("float", {
  out <- capt(boxx("label", float = "center", width = 20))
  exp <- rebox(
    "    ┌───────────┐",
    "    │           │",
    "    │   label   │",
    "    │           │",
    "    └───────────┘")
  expect_equal(out, exp)

  out <- capt(boxx("label", float = "right", width = 20))
  exp <- rebox(
    "       ┌───────────┐",
    "       │           │",
    "       │   label   │",
    "       │           │",
    "       └───────────┘")
  expect_equal(out, exp)
})

test_that("background_col", {
  withr::with_options(
    list(crayon.enabled = TRUE, crayon.colors = 256), {
      bx <- boxx("label", background_col = "red")
      expect_true(ansi_has_any(bx))
      out <- capt_cat(ansi_strip(unclass(bx)))
      exp <- rebox(
        "┌───────────┐",
        "│           │",
        "│   label   │",
        "│           │",
        "└───────────┘")
      expect_equal(out, exp)

      bx <- boxx("label", background_col = col_red)
      expect_true(ansi_has_any(bx))
      out <- capt_cat(ansi_strip(unclass(bx)))
      exp <- rebox(
        "┌───────────┐",
        "│           │",
        "│   label   │",
        "│           │",
        "└───────────┘")
      expect_equal(out, exp)
    }
  )
})

test_that("border_col", {
  withr::with_options(
    list(crayon.enabled = TRUE, crayon.colors = 256), {
      bx <- boxx("label", border_col = "red")
      expect_true(ansi_has_any(bx))
      out <- capt_cat(ansi_strip(unclass(bx)))
      exp <- rebox(
        "┌───────────┐",
        "│           │",
        "│   label   │",
        "│           │",
        "└───────────┘")
      expect_equal(out, exp)

      bx <- boxx("label", border_col = col_red)
      expect_true(ansi_has_any(bx))
      out <- capt_cat(ansi_strip(unclass(bx)))
      exp <- rebox(
        "┌───────────┐",
        "│           │",
        "│   label   │",
        "│           │",
        "└───────────┘")
      expect_equal(out, exp)
    }
  )
})

test_that("align", {
  out <- capt(boxx(c("label", "l2"), align = "center"))
  exp <- rebox(
    "┌───────────┐",
    "│           │",
    "│   label   │",
    "│     l2    │",
    "│           │",
    "└───────────┘")
  expect_equal(out, exp)

  out <- capt(boxx(c("label", "l2"), align = "right"))
  exp <- rebox(
    "┌───────────┐",
    "│           │",
    "│   label   │",
    "│      l2   │",
    "│           │",
    "└───────────┘")
  expect_equal(out, exp)
})

test_that("header", {
  out <- capt(boxx("foobar", header = "foo"))
  exp <- rebox(
    "┌ foo ───────┐",
    "│            │",
    "│   foobar   │",
    "│            │",
    "└────────────┘")
  expect_equal(out, exp)
})

test_that("footer", {
  out <- capt(boxx("foobar", footer = "foo"))
  exp <- rebox(
    "┌────────────┐",
    "│            │",
    "│   foobar   │",
    "│            │",
    "└─────── foo ┘")
  expect_equal(out, exp)
})
