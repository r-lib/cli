
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

test_that_cli(config = c("plain", "ansi"), "quoting weird names, still", {
  nb <- function(x) gsub("\u00a0", " ", x, fixed = TRUE)
  expect_snapshot(local({
    cat_line(nb(quote_weird_name("good")))
    cat_line(nb(quote_weird_name("  bad")))
    cat_line(nb(quote_weird_name("bad  ")))
    cat_line(nb(quote_weird_name("  bad  ")))
  }))
})
