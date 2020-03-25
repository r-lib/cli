context("verbatim text")

setup(start_app())
teardown(stop_app())

test_that("verbatim text is correctly styled", {
  theme <- list(.padded = list("margin-left" = 4))
  cli_div(class = "padded", theme = theme)

  lines <- c("first", "second", "third")

  out0 <- capt0(cli_verbatim(lines))
  out1 <- capt0(cli_verbatim(paste0(lines, collapse = "\n")))

  # expect the margin being applied to all lines
  expected <- paste0(paste0("    ", lines, collapse = "\n"), "\n")

  expect_equal(out0, expected)
  expect_equal(out1, expected)
})
