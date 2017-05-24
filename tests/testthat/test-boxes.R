
context("boxes")

test_that("empty label", {
  expect_output(
    print(boxx("")),
    paste(c("┌──────┐",
            "│      │",
            "│      │",
            "│      │",
            "└──────┘"),
          collapse = "\n"),
    fixed = TRUE
  )
})

test_that("empty label 2", {
  expect_output(
    print(boxx(character())),
    paste(c("┌──────┐",
            "│      │",
            "│      │",
            "└──────┘"),
          collapse = "\n"),
    fixed = TRUE
  )
})

test_that("label", {
  expect_output(
    print(boxx("label")),
    paste(c("┌───────────┐",
            "│           │",
            "│   label   │",
            "│           │",
            "└───────────┘"),
          collapse = "\n"),
    fixed = TRUE
  )
})

test_that("label vector", {
  expect_output(
    print(boxx(c("label", "l2"))),
    paste(c("┌───────────┐",
            "│           │",
            "│   label   │",
            "│   l2      │",
            "│           │",
            "└───────────┘"),
          collapse = "\n"),
    fixed = TRUE
  )
})

test_that("border style", {
  expect_output(
    print(boxx("label", border_style = "classic")),
    paste(c("+-----------+",
            "|           |",
            "|   label   |",
            "|           |",
            "+-----------+"),
          collapse = "\n"),
    fixed = TRUE
  )
})

test_that("padding", {
  expect_output(
    print(boxx("label", padding = 2)),
    paste(c("┌─────────────────┐",
            "│                 │",
            "│                 │",
            "│      label      │",
            "│                 │",
            "│                 │",
            "└─────────────────┘"),
          collapse = "\n"),
    fixed = TRUE
  )

  expect_output(
    print(boxx("label", padding = c(1,2,1,2))),
    paste(c("┌─────────┐",
            "│         │",
            "│  label  │",
            "│         │",
            "└─────────┘"), collapse = "\n"),
    fixed = TRUE
  )

  expect_output(
    print(boxx("label", padding = c(1,2,0,2))),
    paste(c("┌─────────┐",
            "│  label  │",
            "│         │",
            "└─────────┘"), collapse = "\n"),
    fixed = TRUE
  )

  expect_output(
    print(boxx("label", padding = c(1,2,0,0))),
    paste(c("┌───────┐",
            "│  label│",
            "│       │",
            "└───────┘"), collapse = "\n"),
    fixed = TRUE
  )
})

test_that("margin", {
  expect_output(
    print(boxx("label", margin = 1)),
    paste(c("",
            "   ┌───────────┐",
            "   │           │",
            "   │   label   │",
            "   │           │",
            "   └───────────┘",
            ""),
          collapse = "\n"),
    fixed = TRUE
  )

  expect_output(
    print(boxx("label", margin = c(1,2,3,4))),
    paste(c("", "", "",
            "  ┌───────────┐",
            "  │           │",
            "  │   label   │",
            "  │           │",
            "  └───────────┘",
            ""),
          collapse = "\n"),
    fixed = TRUE
  )

  expect_output(
    print(boxx("label", margin = c(0,1,2,0))),
    paste(c("", "",
            " ┌───────────┐",
            " │           │",
            " │   label   │",
            " │           │",
            " └───────────┘"),
          collapse = "\n"),
    fixed = TRUE
  )
})

test_that("float", {
  expect_output(
    print(boxx("label", float = "center", width = 20)),
    paste(c("    ┌───────────┐",
            "    │           │",
            "    │   label   │",
            "    │           │",
            "    └───────────┘"),
          collapse = "\n"),
    fixed = TRUE
  )

  expect_output(
    print(boxx("label", float = "right", width = 20)),
    paste(c("       ┌───────────┐",
            "       │           │",
            "       │   label   │",
            "       │           │",
            "       └───────────┘"),
          collapse = "\n"),
    fixed = TRUE
  )
})

test_that("background_color", {
  withr::with_options(
    list(crayon.enabled = TRUE, crayon.colors = 256), {
      bx <- boxx("label", background_color = "red")
      expect_true(crayon::has_style(bx))
      expect_equal(
        crayon::strip_style(unclass(bx)),
        paste(c("┌───────────┐",
                "│           │",
                "│   label   │",
                "│           │",
                "└───────────┘"),
              collapse = "\n")
      )

      bx <- boxx("label", background_color = crayon::red)
      expect_true(crayon::has_style(bx))
      expect_equal(
        crayon::strip_style(unclass(bx)),
        paste(c("┌───────────┐",
                "│           │",
                "│   label   │",
                "│           │",
                "└───────────┘"),
              collapse = "\n")
      )
    }
  )
})

test_that("border_color", {
  withr::with_options(
    list(crayon.enabled = TRUE, crayon.colors = 256), {
      bx <- boxx("label", border_color = "red")
      expect_true(crayon::has_style(bx))
      expect_equal(
        crayon::strip_style(unclass(bx)),
        paste(c("┌───────────┐",
                "│           │",
                "│   label   │",
                "│           │",
                "└───────────┘"),
              collapse = "\n")
      )

      bx <- boxx("label", border_color = crayon::red)
      expect_true(crayon::has_style(bx))
      expect_equal(
        crayon::strip_style(unclass(bx)),
        paste(c("┌───────────┐",
                "│           │",
                "│   label   │",
                "│           │",
                "└───────────┘"),
              collapse = "\n")
      )
    }
  )
})

test_that("align", {
  expect_output(
    print(boxx(c("label", "l2"), align = "center")),
    paste(c("┌───────────┐",
            "│           │",
            "│   label   │",
            "│     l2    │",
            "│           │",
            "└───────────┘"),
          collapse = "\n"),
    fixed = TRUE
  )
  expect_output(
    print(boxx(c("label", "l2"), align = "right")),
    paste(c("┌───────────┐",
            "│           │",
            "│   label   │",
            "│      l2   │",
            "│           │",
            "└───────────┘"),
          collapse = "\n"),
    fixed = TRUE
  )
})
