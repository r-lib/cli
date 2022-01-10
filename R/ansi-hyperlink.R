
#' Terminal Hyperlinks
#'
#' `ansi_hyperlink()` creates an ANSI hyperlink.
#'
#' @details
#' This function is currently experimental. In particular, many of the
#' `ansi_*()` functions do not support it properly.
#'
#' `ansi_has_hyperlink_support()` checks if the current `stdout()`
#' supports hyperlinks.
#'
#' See also
#' <https://gist.github.com/egmontkob/eb114294efbcd5adb1944c9f3cb5feda>.
#'
#' @param text Text to show. `text` and `url` are recycled to match their
#'   length, via a `paste0()` call.
#' @param url URL to link to.
#' @param params A named character vector of additional parameters, or `NULL`.
#' @return Styled `ansi_string` for `style_hyperlink()`.
#'   Logical scalar for `ansi_has_hyperlink_support()`.
#'
#' @export
#' @examples
#' cat("This is an", style_hyperlink("R", "https://r-project.org"), "link.\n")

style_hyperlink <- function(text, url, params = NULL) {
  params <- glue::glue_collapse(sep = ":",
    glue::glue("{names(params)}={params}")
  )

  out <- if (ansi_has_hyperlink_support()) {
    paste0("\u001B]8;", params, ";", url, "\u0007", text, "\u001B]8;;\u0007")
  } else {
    text
  }

  class(out) <- c("ansi_string", "character")
  out
}

#' @export
#' @name style_hyperlink
#' @examples
#' ansi_has_hyperlink_support()

ansi_has_hyperlink_support <- function() {

  ## Hyperlinks forced?
  enabled <- getOption("cli.hyperlink", getOption("crayon.hyperlink"))
  if (!is.null(enabled)) { return(isTRUE(enabled)) }

  ## forced by environment variable
  enabled <- Sys.getenv("R_CLI_HYPERLINKS", "")
  if (isTRUE(as.logical(enabled))){ return(TRUE) }

  ## Are we in a terminal? No?
  if (!isatty(stdout())) { return(FALSE) }

  ## Are we in a windows terminal?
  if (os_type() == "windows")  { return(TRUE) }

  ## Better to avoid it in CIs
  if (nzchar(Sys.getenv("CI")) ||
      nzchar(Sys.getenv("TEAMCITY_VERSION"))) { return(FALSE) }

  ## iTerm
  if (nzchar(TERM_PROGRAM <- Sys.getenv("TERM_PROGRAM"))) {
    version <- package_version(
      Sys.getenv("TERM_PROGRAM_VERSION"),
      strict = FALSE)

    if (TERM_PROGRAM == "iTerm.app") {
      if (!is.na(version) && version >= "3.1") return(TRUE)
    }
  }

  if (nzchar(VTE_VERSION <- Sys.getenv("VTE_VERSION"))) {
    if (package_version(VTE_VERSION) >= "0.50.1")  return(TRUE)
  }

  FALSE
}
