
context("cli inline")

special_style <- list(before = "<<<", after = ">>>", color = "cyan")

test_that("emph", {
  clix$div(style = list(emph = special_style))
  withr::with_options(list(crayon.enabled = TRUE, crayon.colors = 256), {
    out <- capt(clix$text("This is {emph it} really."), print_it = FALSE)
    expect_true(crayon::has_style(out))
    expect_match(crayon::strip_style(out), "<<<it>>>")
    expect_match(out, start(crayon::make_style("cyan")), fixed = TRUE)
  })
})

test_that("strong", {
  clix$div(style = list(strong = special_style))
  withr::with_options(list(crayon.enabled = TRUE, crayon.colors = 256), {
    out <- capt(clix$text("This is {strong it} really."), print_it = FALSE)
    expect_true(crayon::has_style(out))
    expect_match(crayon::strip_style(out), "<<<it>>>")
    expect_match(out, start(crayon::make_style("cyan")), fixed = TRUE)
  })
})

test_that("code", {
  clix$div(style = list(code = special_style))
  withr::with_options(list(crayon.enabled = TRUE, crayon.colors = 256), {
    out <- capt(clix$text("This is {code !!it} really."), print_it = FALSE)
    expect_true(crayon::has_style(out))
    expect_match(crayon::strip_style(out), "<<<!!it>>>")
    expect_match(out, start(crayon::make_style("cyan")), fixed = TRUE)
  })
})

test_that("inline classes", {
  classes <- c(
    "pkg", "fun", "arg", "key", "file", "path", "email",
    "url", "var", "envvar")

  do <- function(class) {
    clix$div(
      style = structure(list(special_style), names = paste0(".", class)))
    withr::with_options(list(crayon.enabled = TRUE, crayon.colors = 256), {
      txt <- glue::glue("This is {<class> it} really",
                        .open = "<", .close = ">")
      out <- capt(clix$text(txt), print_it = FALSE)
      expect_true(crayon::has_style(out))
      expect_match(crayon::strip_style(out), "<<<it>>>", info = class)
      expect_match(out, start(crayon::make_style("cyan")), fixed = TRUE, info = class)
    })
  }

  lapply(classes, do)
})
