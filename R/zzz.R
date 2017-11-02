.onLoad <- function(lib, pkg) {
  if (is.null(getOption("cli.symbols"))) {
    options(cli.symbols = l10n_info()$`UTF-8`)
  }
}
