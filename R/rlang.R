
#' Signal an error, warning or message with a cli formatted
#' message
#'
#' These functions let you create error, warning or diagnostic
#' messages with cli formatting, including inline styling,
#' pluralization andglue substitutions.
#'
#' @param message It is formatted via a call to [cli_bullets()].
#' @param ... Passed to [rlang::abort()], [rlang::warn()] or
#'   [rlang::inform()].
#' @param .envir Environment to evaluate the glue expressions in.
#'
#' @export
#' @examples
#' \dontrun{
#' n <- "boo"
#' cli_abort(c(
#'         "{.var n} must be a numeric vector",
#'   "x" = "You've supplied a {.cls {class(n)}} vector."
#' ))
#'
#' len <- 26
#' idx <- 100
#' cli_abort(c(
#'         "Must index an existing element:",
#'   "i" = "There {?is/are} {len} element{?s}.",
#'   "x" = "You've tried to subset element {idx}."
#' ))
#' }

cli_abort <- function(message, ..., .envir = parent.frame()) {
  # Add "Error: " for the wrapping, because R adds it unconditionally
  # TODO: I apparently can't translate this with
  # gettext("Error: ", domain = "R")
  message[1] <- paste0("Error: ", message[1])

  # The default theme will make this bold
  names(message)[1] <- "1"

  rsconsole <- c("rstudio_console", "rstudio_console_starting")
  if (rstudio_detect()$type %in% rsconsole) {
    # leave some space for the traceback buttons in RStudio
    oldopt <- options(cli.width = console_width() - 15L)
    on.exit(options(oldopt), add = TRUE)
  }

  formatted1 <- fmt({
    cli_div(class = "cli_rlang cli_abort")
    cli_bullets(message, .envir = .envir)
  }, collapse = TRUE)

  # remove "Error: " that was only needed for the wrapping
  formatted2 <- ansi_substr(formatted1, 8, nchar(formatted1))

  formatted3 <- update_rstudio_color(formatted2)
  rlang::abort(formatted3, ...)
}

#' @rdname cli_abort
#' @export

cli_warn <- function(message, ..., .envir = parent.frame()) {
  # The default theme will make this bold
  names(message)[1] <- "1"

  formatted1 <- fmt({
    cli_div(class = "cli_rlang cli_warn")
    cli_bullets(message, .envir = .envir)
  }, collapse = TRUE)

  formatted2 <- update_rstudio_color(formatted1)
  rlang::warn(formatted2, ...)
}

#' @rdname cli_abort
#' @export

cli_inform <- function(message, ..., .envir = parent.frame()) {
  formatted1 <- fmt({
    cli_div(class = "cli_rlang cli_inform")
    cli_bullets(message, .envir = .envir)
  }, collapse = TRUE)
  formatted2 <- update_rstudio_color(formatted1)
  rlang::inform(formatted2, ...)
}

update_rstudio_color <- function(message) {
  rscol <- get_rstudio_fg_color()
  if (!is.null(rscol)) {
    # in RStudio we only need to change the color
    message[] <- rscol(message)
  } else {
    # in a terminal we need to undo the bold
    message <- paste0(style_bold(""), message)
  }
  message
}

get_rstudio_fg_color <- function() {
  tryCatch(
    get_rstudio_fg_color0(),
    error = function(e) NULL
  )
}

get_rstudio_fg_color0 <- function() {
  rs <- rstudio_detect()
  oktypes <- c("rstudio_console", "rstudio_console_starting")
  if (! rs$type %in% oktypes) return(NULL)
  if (rs$num_colors == 1) return(NULL)
  colstr <- rstudioapi::getThemeInfo()$foreground
  if (is.null(colstr)) return(NULL)
  colstr0 <- substr(colstr, 5, nchar(colstr) - 1)
  rgbnum <- scan(text = colstr0, sep = ",", quiet = TRUE)
  rgb <- grDevices::rgb(rgbnum[1]/255, rgbnum[2]/255, rgbnum[3]/255)
  make_ansi_style(rgb)
}

rstudio_detect <- function() {
  rstudio$detect()
}
