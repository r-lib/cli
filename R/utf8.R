
#' Whether cli is emitting UTF-8 characters
#'
#' UTF-8 cli characters can be turned on by setting the `cli.unicode`
#' option to `TRUE`. They can be turned off by setting if to `FALSE`.
#' If this option is not set, then [base::l10n_info()] is used to detect
#' UTF-8 support.
#'
#' @return Flag, whether cli uses UTF-8 characters.
#'
#' @export

is_utf8_output <- function() {
  opt <- getOption("cli.unicode", NULL)
  if (! is.null(opt)) {
    isTRUE(opt)
  } else {
    l10n_info()$`UTF-8` && !is_latex_output()
  }
}
