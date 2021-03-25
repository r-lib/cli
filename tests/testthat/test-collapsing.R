
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
    cli_div(theme = list(div = list(vec_sep = " ... ")))
    pkgs <- paste0("pkg", 1:5)
    cli_text("Packages: {.pkg {pkgs}}.")
  }))
})

test_that("collapsing a cli_vec", {
  expect_snapshot({
    pkgs <- cli_vec(
      paste0("pkg", 1:5),
      style = list(vec_sep = " & ", vec_last = " & ")
    )
    cli_text("Packages: {pkgs}.")
  })
})

test_that_cli(configs = c("plain", "ansi"), "collapsing a cli_vec with styling", {
  expect_snapshot(local({
    cli_div(theme = list(body = list(vec_sep = " ... ")))
    pkgs <- cli_vec(
      paste0("pkg", 1:5),
      style = list(vec_sep = " & ", vec_last = " & ", color = "blue")
    )
    cli_text("Packages: {pkgs}.")
  }))
})
