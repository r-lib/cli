
# https://github.com/r-lib/cli/issues/370

test_that("glue quotes and comments", {
  expect_snapshot({
    cli_dl(
      c(
        "test_1" = "all good",
        "test_2" = "not #good"
      )
    )
    cli::cli_dl(c("test_3" = "no' good either"))
    cli::cli_dl(c("test_4" = "no\" good also"))
    cli::cli_text("{.url https://example.com/#section}")
    cli::cli_alert_success("Qapla'")
  })
})

test_that("quotes, etc. within expressions are still OK", {
  expect_snapshot({
    cli::cli_text("{.url URL} {x <- 'foo'; nchar(x)}")
    cli::cli_text("{.url URL} {x <- \"foo\"; nchar(x)}")
    cli::cli_text("{.url URL} {1 + 1 # + 1} {1 + 1}")
  })
})
