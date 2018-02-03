
context("cli inline")

special_style <- list(before = "<<<", after = ">>>", color = "cyan")

test_that("inline classes", {
  classes <- c(
    "emph", "strong", "code", "pkg", "fun", "arg", "key", "file", "path",
    "email", "url", "var", "envvar")

  do <- function(class) {
    clix$div(
      theme = structure(list(special_style), names = paste0("span.", class)))
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
