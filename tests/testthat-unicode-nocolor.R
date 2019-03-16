library(testthat)
library(cli)

withr::with_envvar(
  c(NO_COLOR = "true"),
  withr::with_options(
    list(cli.unicode = TRUE),
    test_check("cli")
  )
)
