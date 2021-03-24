
start_app()
on.exit(stop_app(), add = TRUE)

test_that("verbatim text is correctly styled", {
  expect_snapshot(local({
    theme <- list(.padded = list("margin-left" = 4))
    cli_div(class = "padded", theme = theme)

    lines <- c("first", "second", "third")

    cli_verbatim(lines)
    cli_verbatim(paste0(lines, collapse = "\n"))
  }))
})
