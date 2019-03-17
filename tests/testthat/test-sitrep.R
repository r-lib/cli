
context("sitrep")

test_that("sitrep runs", {
  expect_true(is.list(cli_sitrep()))
  expect_true(is.character(format(cli_sitrep())))
  out <- capture_output(print(cli_sitrep()))
  expect_true(all(grepl("^- ", out)))
})

test_that("get_active_symbol_set", {
  withr::with_options(list(cli.unicode = TRUE), {
    expect_equal(get_active_symbol_set(), "UTF-8")
  })
  withr::with_options(list(cli.unicode = FALSE), {
    set <- get_active_symbol_set()
    expect_equal(set, "ASCII (non UTF-8)")
  })
})
