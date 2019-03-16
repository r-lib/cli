library(testthat)
library(cli)

withr::with_envvar(
  c(NO_COLOR = NA),
  withr::with_options(
    list(cli.unicode = FALSE),
    test_check("cli")
  )
)
