library(testthat)
library(cli)

## Run the tests in fancy mode and non-fancy mode as well
## Also, run them in latin1 encoding as well, this is for Unix,
## because Windows encoding names are different.

withr::with_options(
  list(cli.unicode = FALSE),
  test_check("cli", reporter = "summary")
)

withr::with_options(
  list(cli.unicode = TRUE),
  test_check("cli", reporter = "summary")
)

has_locale <- function(l) {
  has <- TRUE
  tryCatch(
    withr::with_locale(c(LC_CTYPE = l), "foobar"),
    warning = function(w) has <<- FALSE,
    error = function(e) has <<- FALSE
  )
  has
}

if (l10n_info()$`UTF-8` && has_locale("en_US.ISO8859-1")) {
  withr::with_locale(
    c(LC_CTYPE = "en_US.ISO8859-1"),
    test_check("cli", reporter = "summary")
  )
}
