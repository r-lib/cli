
start_app()
on.exit(stop_app(), add = TRUE)

test_that("collapsing without formatting, n>3", {
  expect_snapshot({
    pkgs <- paste0("pkg", 1:5)
    cli_text("Packages: {pkgs}.")
  })
})

test_that("collapsing without formatting, n<3", {
  expect_snapshot({
    pkgs <- paste0("pkg", 1:2)
    cli_text("Packages: {pkgs}.")
  })
})

test_that("collapsing with formatting", {
  expect_snapshot(local({
    cli_div(theme = list(".pkg" = list(fmt = function(x) paste0(x, " (P)"))))
    pkgs <- paste0("pkg", 1:5)
    cli_text("Packages: {.pkg {pkgs}}.")
  }))
})

test_that("collapsing with formatting, custom seps", {
  expect_snapshot(local({
    cli_div(theme = list(div = list("vec-sep" = " ... ")))
    pkgs <- paste0("pkg", 1:5)
    cli_text("Packages: {.pkg {pkgs}}.")
  }))
})

test_that("collapsing a cli_vec", {
  expect_snapshot({
    pkgs <- cli_vec(
      paste0("pkg", 1:5),
      style = list("vec-sep" = " & ", "vec-last" = " & ")
    )
    cli_text("Packages: {pkgs}.")
  })
})

test_that_cli(configs = c("plain", "ansi"), "collapsing a cli_vec with styling", {
  expect_snapshot(local({
    cli_div(theme = list(body = list("vec-sep" = " ... ")))
    pkgs <- cli_vec(
      paste0("pkg", 1:5),
      style = list("vec-sep" = " & ", "vec-last" = " & ", color = "blue")
    )
    cli_text("Packages: {pkgs}.")
  }))
})

test_that("head", {
  v <- function(n, t = 5) {
    cli_vec(
      seq_len(n),
      style = list("vec-trunc-style" = "head", "vec-trunc" = t)
    )
  }
  expect_snapshot({
    cli_text("{v(0,1)}")
    cli_text("{v(1,1)}")
    cli_text("{v(2,1)}")
    cli_text("{v(3,1)}")
    cli_text("{v(4,1)}")

    cli_text("{v(0,2)}")
    cli_text("{v(1,2)}")
    cli_text("{v(2,2)}")
    cli_text("{v(3,2)}")
    cli_text("{v(4,2)}")

    cli_text("{v(0,3)}")
    cli_text("{v(1,3)}")
    cli_text("{v(2,3)}")
    cli_text("{v(3,3)}")
    cli_text("{v(4,3)}")

    cli_text("{v(0,4)}")
    cli_text("{v(1,4)}")
    cli_text("{v(2,4)}")
    cli_text("{v(3,4)}")
    cli_text("{v(4,4)}")

    cli_text("{v(0,5)}")
    cli_text("{v(1,5)}")
    cli_text("{v(2,5)}")
    cli_text("{v(3,5)}")
    cli_text("{v(4,5)}")

    cli_text("{v(10,5)}")
  })
})

test_that("both-ends", {
  v <- function(n, t = 5) {
    cli_vec(
      seq_len(n),
      style = list("vec-trunc-style" = "both-ends", "vec-trunc" = t)
    )
  }
  expect_snapshot({
    cli_text("{v(0,1)}")
    cli_text("{v(1,1)}")
    cli_text("{v(2,1)}")
    cli_text("{v(3,1)}")
    cli_text("{v(4,1)}")
    cli_text("{v(5,1)}")
    cli_text("{v(6,1)}")
    cli_text("{v(7,1)}")
    cli_text("{v(10,1)}")
  })
})

test_that_cli(config = c("plain", "ansi"), "both-ends with formatting", {
  v <- function(n, t = 5) {
    cli_vec(
      seq_len(n),
      style = list("vec-trunc-style" = "both-ends", "vec-trunc" = t)
    )
  }
  expect_snapshot({
    cli_text("{.val {v(0,1)}}")
    cli_text("{.val {v(1,1)}}")
    cli_text("{.val {v(2,1)}}")
    cli_text("{.val {v(3,1)}}")
    cli_text("{.val {v(4,1)}}")
    cli_text("{.val {v(5,1)}}")
    cli_text("{.val {v(6,1)}}")
    cli_text("{.val {v(7,1)}}")
    cli_text("{.val {v(10,1)}}")

    cli_text("{.val {v(10,6)}}")
    cli_text("{.val {v(10,10)}}")
    cli_text("{.val {v(11,10)}}")
  })
})

test_that("cli_collapse", {
  l10 <- letters[1:10]
  expect_snapshot({
    cli_collapse(l10)
    cli_collapse(l10, trunc = 6)
    cli_collapse(l10, trunc = 5)
    cli_collapse(l10, trunc = 4)
    cli_collapse(l10, trunc = 1)
    cli_collapse(l10, sep = "; ")
    cli_collapse(l10, sep = "; ", last = "; or ")
    cli_collapse(l10, sep = "; ")
    cli_collapse(l10, sep = "; ", last = "; or ", trunc = 6)

    cli_collapse(l10, style = "head")
    cli_collapse(l10, trunc = 6, style = "head")
    cli_collapse(l10, trunc = 5, style = "head")
    cli_collapse(l10, trunc = 4, style = "head")
    cli_collapse(l10, trunc = 1, style = "head")
    cli_collapse(l10, sep = "; ", style = "head")
    cli_collapse(l10, sep = "; ", last = "; or ", style = "head")
    cli_collapse(l10, sep = "; ", last = "; or ", trunc = 6, style = "head")
  })
})
