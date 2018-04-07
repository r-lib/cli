
is_rstudio <- function() {
  Sys.getenv("RSTUDIO", "") == "1"
}

is_emacs <- function() {
  Sys.getenv("EMACS", "") != ""
}

is_rgui <- function() {
  .Platform$GUI == "Rgui"
}

is_rapp <- function() {
  Sys.getenv("R_GUI_APP_VERSION", "") != ""
}

#' @export
#' @importFrom utils capture.output

get_screen_size <- function() {

  width_opts <- function() {
    getOption(
      "cli.width",
      Sys.getenv(
        "RSTUDIO_CONSOLE_WIDTH",
        getOption("width", 80)
      )
    )
  }

  res <- if (is_rstudio()) {
    c(width_opts(), getOption("cli.height", 25))

  } else if (is_emacs()) {
    c(width_opts(), getOption("cli.height", 50))

  } else if (is_rgui()) {
    c(width_opts(), getOption("cli.height", 50))

  } else if (is_rapp()) {
    c(width_opts(), getOption("cli.height", 50))

  } else {
    tres <- tryCatch({
      out <- capture.output(.Call(c_get_screen_size))
      c(gsub("[^0-9]", "", grep("^COLUMNS=[0-9]+;$", out, value = TRUE)[1]),
        gsub("[^0-9]", "", grep("^LINES=[0-9]+;$", out, value = TRUE)[1]))
    }, error = function(e) c(80, 50))

    c(getOption("cli.width", tres[1]), getOption("cli.height", tres[2]))
  }

  res <- tryCatch(
    suppressWarnings(as.integer(res)),
    error = function(e) c(80, 50)
  )

  ifelse(is.na(res), c(80, 50), res)
}

#' Determine the width of the console
#'
#' It uses the `RSTUDIO_CONSOLE_WIDTH` environment variable, if set.
#' Otherwise it uses the `width` option. If this is not set either,
#' then 80 is used.
#'
#' @return Integer scalar, the console with, in number of characters.
#' 
#' @export

console_width <- function() {
  get_screen_size()[1]
}
