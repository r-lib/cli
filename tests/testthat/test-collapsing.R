
setup(start_app())
teardown(stop_app())

test_that("collapsing without formatting, n>3", {
  pkgs <- paste0("pkg", 1:5)
  out <- capt0(cli_text("Packages: {pkgs}."), strip_style = TRUE)
  expect_equal(out, "Packages: pkg1, pkg2, pkg3, pkg4, and pkg5.\n")
})

test_that("collapsing without formatting, n<3", {
  pkgs <- paste0("pkg", 1:2)
  out <- capt0(cli_text("Packages: {pkgs}."), strip_style = TRUE)
  expect_equal(out, "Packages: pkg1 and pkg2.\n")
})

test_that("collapsing with formatting", {
  cli_div(theme = list(".pkg" = list(fmt = function(x) paste0(x, " (P)"))))
  pkgs <- paste0("pkg", 1:5)
  out <- capt0(cli_text("Packages: {.pkg {pkgs}}."), strip_style = TRUE)
  expect_equal(
    out,
    "Packages: pkg1 (P), pkg2 (P), pkg3 (P), pkg4 (P), and pkg5 (P).\n"
  )
})
