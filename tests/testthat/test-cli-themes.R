
context("cli themes")

test_that("add/remove/list themes", {
  id <- clix$add_theme(list(".green" = list(color = "green")))
  on.exit(clix$remove_theme(id), add = TRUE)
  expect_true(id %in% names(clix$list_themes()))

  withr::with_options(list(crayon.enabled = TRUE, crayon.colors = 256), {
    capt(clix$par(class = "green"))
    out <- capt(clix$text(lorem_ipsum()), print_it = FALSE)
    capt(clix$end())
    expect_true(grepl(start(crayon::make_style("green")), out, fixed = TRUE))
  })

  clix$remove_theme(id)
  expect_false(id %in% names(clix$list_themes()))
})

test_that("default theme is valid", {
  expect_error({
    id <- clix$add_theme(cli_builtin_theme())
    clix$remove_theme(id)
  }, NA)
})

test_that("explicit formatter is used, and combined", {
  id <- clix$add_theme(list(
    "span.emph" = list(fmt = function(x) paste0("(((", x, ")))")),
    "span.emph::before" = list(content = "<<"),
    "span.emph::after" = list(content = ">>")
  ))
  on.exit(clix$remove_theme(id), add = TRUE)
  out <- capt(clix$text("this is {emph it}, really"), print_it = FALSE)
  expect_match(crayon::strip_style(out), "(((<<it>>)))", fixed = TRUE)
})
