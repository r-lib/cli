
context("cli inline")

setup(start_app())
teardown(stop_app())

test_that("inline classes", {
  classes <- c(
    "emph", "strong", "code", "pkg", "fun", "arg", "key", "file", "path",
    "email", "url", "var", "envvar")

  do <- function(class) {

    special_style <- structure(
      list(
        list(color = "cyan"),
        list(before = "<<<"),
        list(after =">>>")),
      names = c(
        paste0("span.", class),
        paste0("span.", class),
        paste0("span.", class)
      )
    )

    cli_div(theme = special_style)
    withr::with_options(list(crayon.enabled = TRUE, crayon.colors = 256), {
      txt <- glue::glue("This is {.<class> it} really",
                        .open = "<", .close = ">")
      out <- capt0(cli_text(txt))
      expect_true(ansi_has_any(out))
      expect_match(ansi_strip(out), "<<<it>>>", info = class)
      expect_match(
        out,
        attr(make_ansi_style("cyan"), "_styles")[[1]]$open,
        fixed = TRUE,
        info = class
      )
    })
  }

  lapply(classes, do)
})

test_that("{{ and }} can be used for comments", {
  out <- capt0(cli_text("Escaping {{ works"))
  expect_equal(out, "Escaping { works\n")

  out <- capt0(cli_text("Escaping }} works"))
  expect_equal(out, "Escaping } works\n")

  out <- capt0(cli_text("Escaping {{ and }} works"))
  expect_equal(out, "Escaping { and } works\n")

  out <- capt0(cli_text("Escaping {{{{ works"))
  expect_equal(out, "Escaping {{ works\n")

  out <- capt0(cli_text("Escaping }}}} works"))
  expect_equal(out, "Escaping }} works\n")

  out <- capt0(cli_text("Escaping {{{{ and }} works"))
  expect_equal(out, "Escaping {{ and } works\n")

  out <- capt0(cli_text("Escaping {{{{ and }}}} works"))
  expect_equal(out, "Escaping {{ and }} works\n")

  out <- capt0(cli_text("Escaping {{ and }}}} works"))
  expect_equal(out, "Escaping { and }} works\n")
})

test_that("no glue substitution in expressions that evaluate to a string", {
  msg <- "Message with special characters like } { }} {{"
  out <- capt0(cli_text("{msg}"))
  expect_equal(out, paste0(msg, "\n"))

  out <- capt0(cli_text("{.emph {msg}}"), strip_style = TRUE)
  expect_equal(out, paste0(msg, "\n"))
})

test_that("S3 class is used for styling", {
  cli_div(theme = list(
    body = list("class-map" = list("foo" = "bar")),
    ".bar" = list(before = "::"))
  )

  obj <- structure("yep", class = "foo")
  out <- capt0(cli_text("This is {obj}."))
  expect_match(out, "::yep")
})

test_that("quoting phrases that don't start or end with letter or number", {
  x0 <- "good-name"
  out <- capt0(cli_text("The name is {.file {x0}}."))
  expect_equal(
    ansi_strip(out),
    "The name is good-name.\n"
  )

  x <- "weird-name "
  out <- capt0(cli_text("The name is {.file {x}}."))
  expect_equal(
    ansi_strip(out),
    "The name is 'weird-name '.\n"
  )

  out <- capt0(cli_text("The name is {.path {x}}."))
  expect_equal(
    ansi_strip(out),
    "The name is 'weird-name '.\n"
  )

  out <- capt0(cli_text("The name is {.email {x}}."))
  expect_equal(
    ansi_strip(out),
    "The name is 'weird-name '.\n"
  )
})
