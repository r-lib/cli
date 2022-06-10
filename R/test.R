
#' Test cli output with testthat
#'
#' Use this function in your testthat test files, to test cli output.
#' It requires testthat edition 3, and works best with snapshot tests.
#'
#' `test_that_cli()` calls [testthat::test_that()] multiple times, with
#' different cli configurations. This makes it simple to test cli output
#' with and without ANSI colors, with and without Unicode characters.
#'
#' Currently available configurations:
#' * `plain`: no ANSI colors, ASCII characters only.
#' * `ansi`: ANSI colors, ASCII characters only.
#' * `unicode`: no ANSI colors, Unicode characters.
#' * `fancy`; ANSI colors, Unicode characters.
#'
#' See examples below and in cli's own tests, e.g. in
#' <https://github.com/cran/cli/tree/main/tests/testthat>
#' and the corresponding snapshots at
#' <https://github.com/cran/cli/tree/main/tests/testthat/_snaps>
#'
#' ## Important note regarding Windows
#'
#' Because of base R's limitation to record Unicode characters on Windows,
#' we suggest that you record your snapshots on Unix, or you restrict
#' your tests to ASCII configurations.
#'
#' Unicode tests on Windows are automatically skipped by testthat
#' currently.
#'
#' @param desc Test description, passed to [testthat::test_that()], after
#' appending the name of the cli configuration to it.
#' @param code Test code, it is modified to set up the cli config, and
#' then passed to [testthat::test_that()]
#' @param configs cli configurations to test `code` with. The default is
#' `NULL`, which includes all possible configurations. It can also be a
#' character vector, to restrict the tests to some configurations only.
#' See available configurations below.
#'
#' @export
#' @examples
#' # testthat cannot record or compare snapshots when you run these
#' # examples interactively, so you might want to copy them into a test
#' # file
#'
#' # Default configurations
#' cli::test_that_cli("success", {
#'   testthat::local_edition(3)
#'   testthat::expect_snapshot({
#'     cli::cli_alert_success("wow")
#'   })
#' })
#'
#' # Only use two configurations, because this output does not have colors
#' cli::test_that_cli(configs = c("plain", "unicode"), "cat_bullet", {
#'   testthat::local_edition(3)
#'   testthat::expect_snapshot({
#'     cli::cat_bullet(letters[1:5])
#'   })
#' })
#'
#' # You often need to evaluate all cli calls of a test case in the same
#' # environment. Use `local()` to do that:
#' cli::test_that_cli("theming", {
#'   testthat::local_edition(3)
#'   testthat::expect_snapshot(local({
#'     cli::cli_div(theme = list(".alert" = list(before = "!!! ")))
#'     cli::cli_alert("wow")
#'   }))
#' })

 test_that_cli <- function(desc, code, configs = NULL) {
  code <- substitute(code)

  doconfigs <- list(
    list(id = "plain",   unicode = FALSE, num_colors =   1, locale = NULL),
    list(id = "ansi",    unicode = FALSE, num_colors = 256, locale = NULL),
    list(id = "unicode", unicode = TRUE,  num_colors =   1, locale = NULL),
    list(id = "fancy",   unicode = TRUE,  num_colors = 256, locale = NULL)
  )

  parent <- parent.frame()
  lapply(doconfigs, function(conf) {
    if (!is.null(configs) && ! conf$id %in% configs) return()
    code2 <- substitute({
      testthat::local_reproducible_output(
        crayon = num_colors > 1,
        unicode = unicode
      )
      code_
    }, c(conf, list(code_ = code)))
    desc2 <- paste0(desc, " [", conf$id, "]")
    test <- substitute(
      testthat::test_that(desc, code),
      list(desc = desc2, code = code2)
    )
    eval(test, envir = parent)
  })
}
