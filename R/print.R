
#' Create a format method for an object using cli tools
#'
#' This method can be typically used in `format()` S3 methods. Then the
#' `print()` method of the class can be easily defined in terms of such a
#' `format()` method. See examples below.
#'
#' @param expr Expression that calls `cli_*` methods, [base::cat()] or
#' [base::print()] to format an object's printout.
#' @param theme Theme to use for the formatting.
#' @return Character vector, one element for each line of the printout.
#'
#' @export
#' @examples
#'
#' # Let's create format and print methods for a new S3 class that
#' # represents the an installed R package: `r_package`
#'
#' # An `r_package` will contain the DESCRIPTION metadata of the package
#' # and also its installation path.
#' new_r_package <- function(pkg) {
#'   tryCatch(
#'     desc <- packageDescription(pkg),
#'     warning = function(e) stop("Cannot find R package `", pkg, "`")
#'   )
#'   file <- dirname(attr(desc, "file"))
#'   if (basename(file) != pkg) file <- dirname(file)
#'   structure(
#'     list(desc = unclass(desc), lib = dirname(file)),
#'     class = "r_package"
#'   )
#' }
#'
#' format.r_package <- function(x, ...) {
#'   cli_format_method({
#'     cli_h1("{.pkg {x$desc$Package}} {cli::symbol$line} {x$desc$Title}")
#'     cli_text("{x$desc$Description}")
#'     cli_ul(c(
#'       "Version: {x$desc$Version}",
#'       if (!is.null(x$desc$Maintainer)) "Maintainer: {x$desc$Maintainer}",
#'       "License: {x$desc$License}"
#'     ))
#'     if (!is.na(x$desc$URL)) cli_text("See more at {.url {x$desc$URL}}")
#'   })
#' }
#'
#' # Now the print method is easy:
#' print.r_package <- function(x, ...) {
#'   cat(format(x, ...), sep = "\n")
#' }
#'
#' # Try it out
#' new_r_package("cli")
#'
#' # The formatting of the output depends on the current theme:
#' opt <- options(cli.theme = simple_theme())
#' print(new_r_package("cli"))
#' options(opt)  # <- restore theme

cli_format_method <- function(expr, theme = getOption("cli.theme")) {

  # This is not needed for cli, but needed for sink() and crayon
  opts <- options(
    crayon.enabled = crayon::has_color(),
    crayon.colors = crayon::num_colors()
  )
  on.exit(options(opts), add = TRUE)

  # Redirect everything to the connection
  con <- textConnection(NULL, open = "w", local = TRUE, encoding = "bytes")
  sink(con)
  on.exit(sink(NULL), add = TRUE)
  on.exit(close(con), add = TRUE)
  start_app(theme = theme, output = con)


  # Run the code
  expr

  # Collect the output
  textConnectionValue(con)
}
