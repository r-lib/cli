
start_app()
on.exit(stop_app(), add = TRUE)

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

test_that_cli(config = c("ansi"), "~/ files are not weird", {
  nb <- function(x) gsub("\u00a0", " ", x, fixed = TRUE)
  expect_snapshot(local({
    cat_line(nb(quote_weird_name("~/good")))
    cat_line(nb(quote_weird_name("~~bad")))
    cat_line(nb(quote_weird_name("bad~  ")))
    cat_line(nb(quote_weird_name(" ~ bad ~ ")))
  }))
})

test_that_cli("custom truncation", {
  expect_snapshot({
    x <- cli_vec(1:100, list(vec_trunc = 5))
    cli_text("Some numbers: {x}.")
    cli_text("Some numbers: {.val {x}}.")
  })
})

test_that_cli(configs = c("plain", "ansi"), "collapsing class names", {
  expect_snapshot(local({
    cc <- c("one", "two")
    cli_text("this is a class: {.cls myclass}")
    cli_text("multiple classes: {.cls {cc}}")
  }))
})

test_that_cli(configs = c("plain", "ansi"), "transform", {
  expect_snapshot(local({
    cli_text("This is a {.field field} (before)")
    foo <- function(x) toupper(x)
    cli_div(theme = list(span.field = list(transform = foo)))
    cli_text("This is a {.field field} (during)")
    cli_end()
    cli_text("This is a {.field field} (after)")
  }))
})

test_that("cli_format", {
  expect_snapshot(
    cli_format(1:4/7, list(digits = 2))
  )
})

test_that("cli_format() is used for .val", {
  withr::local_options(cli.width = 60)
  local_rng_version("3.5.0")
  set.seed(42)
  expect_snapshot({
    cli_div(theme = list(.val = list(digits = 2)))
    cli_text("Some random numbers: {.val {runif(4)}}.")
  })
})
