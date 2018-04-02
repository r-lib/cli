
context("cli themes")

test_that("add/remove/list themes", {
  id <- clix$add_theme(list(".green" = list(color = "green")))
  on.exit(clix$remove_theme(id), add = TRUE)
  expect_true(id %in% names(clix$list_themes()))

  withr::with_options(list(crayon.enabled = TRUE, crayon.colors = 256), {
    capt0(clix$par(class = "green"))
    out <- capt0(clix$text(lorem_ipsum()))
    capt0(clix$end())
    expect_true(grepl(start(crayon::make_style("green")), out, fixed = TRUE))
  })

  clix$remove_theme(id)
  expect_false(id %in% names(clix$list_themes()))
})

test_that("auto-remove themes", {
  f <- function() {
    id <- clix$add_theme(
      list(".green" = list(color = "green")),
      .auto_remove = TRUE)
    on.exit(clix$remove_theme(id), add = TRUE)
    expect_true(id %in% names(clix$list_themes()))
    id
  }

  id <- f()
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
  out <- capt0(clix$text("this is {emph it}, really"))
  expect_match(crayon::strip_style(out), "(((<<it>>)))", fixed = TRUE)
})

test_that("default theme", {
  def <- default_theme()
  expect_true(is.list(def))
  expect_false(is.null(names(def)))
  expect_true(all(names(def) != ""))
  expect_true(all(vlapply(def, is.list)))
})
