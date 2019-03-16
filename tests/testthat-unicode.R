library(testthat)
library(cli)

## Run the tests in fancy mode and non-fancy mode as well

withr::with_envvar(
  c(NO_COLOR = NA),
  withr::with_options(
    list(cli.unicode = TRUE),
    test_check("cli")
  )
)
