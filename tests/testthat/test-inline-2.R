
test_that_cli(
  config = c("plain", "ansi"),
  "quoting phrases that don't start or end with letter or number", {

    expect_snapshot(local({
      x0 <- "good-name"
      cli_text("The name is {.file {x0}}.")

      x <- "weird-name "
      cli_text("The name is {.file {x}}.")
      cli_text("The name is {.path {x}}.")
      cli_text("The name is {.email {x}}.")
    }))
  }
)
