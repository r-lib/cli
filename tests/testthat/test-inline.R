
start_app()
on.exit(stop_app(), add = TRUE)

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
    local_cli_config(num_colors = 256L)
    txt <- glue::glue("This is {.<class> it} really",
                      .open = "<", .close = ">")
    cli_text(txt)
  }

  expect_snapshot(
    invisible(lapply(classes, do))
  )
})

test_that("{{ and }} can be used for comments", {
  expect_snapshot(local({
    cli_text("Escaping {{ works")
    cli_text("Escaping }} works")
    cli_text("Escaping {{ and }} works")
    cli_text("Escaping {{{{ works")
    cli_text("Escaping }}}} works")
    cli_text("Escaping {{{{ and }} works")
    cli_text("Escaping {{{{ and }}}} works")
    cli_text("Escaping {{ and }}}} works")
  }))
})

test_that("no glue substitution in expressions that evaluate to a string", {
  expect_snapshot(local({
    msg <- "Message with special characters like } { }} {{"
    cli_text("{msg}")
    cli_text("{.emph {msg}}")
  }))
})

test_that("S3 class is used for styling", {
  expect_snapshot(local({
    cli_div(
      theme = list(
        body = list("class-map" = list("foo" = "bar")),
        ".bar" = list(before = "::"))
    )
    obj <- structure("yep", class = "foo")
    cli_text("This is {obj}.")
  }))
})

test_that("quoting phrases that don't start or end with letter or number", {
  expect_snapshot(local({
    x0 <- "good-name"
    cli_text("The name is {.file {x0}}.")

    x <- "weird-name "
    cli_text("The name is {.file {x}}.")
    cli_text("The name is {.path {x}}.")
    cli_text("The name is {.email {x}}.")
  }))
})
