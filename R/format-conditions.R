
#' Format an error, warning or diagnostic message
#'
#' You can then throw this message with [stop()] or `rlang::abort()`.
#'
#' The messages can use inline styling, pluralization and glue
#' substitutions.
#'
#' ```{asciicast format-error}
#' n <- "boo"
#' stop(format_error(c(
#'         "{.var n} must be a numeric vector",
#'   "x" = "You've supplied a {.cls {class(n)}} vector."
#' )))
#' ```
#'
#' ```{asciicast format-error-2}
#' len <- 26
#' idx <- 100
#' stop(format_error(c(
#'         "Must index an existing element:",
#'   "i" = "There {?is/are} {len} element{?s}.",
#'   "x" = "You've tried to subset element {idx}."
#' )))
#' ```
#'
#' @param message It is formatted via a call to [cli_bullets()].
#' @param .envir Environment to evaluate the glue expressions in.
#' @param prefix Prefix of the error, if it is known to be different
#' than the default.
#'
#' @export

format_error <- function(message, .envir = parent.frame(),
                         prefix = "Error: ") {
  if (is.null(names(message)) || names(message)[1] == "") {
    # The default theme will make this bold
    names(message)[1] <- "1"
  }

  rsconsole <- c("rstudio_console", "rstudio_console_starting")
  if (rstudio_detect()$type %in% rsconsole) {
    # leave some space for the traceback buttons in RStudio
    oldopt <- options(cli.width = console_width() - 15L)
  } else {
    oldopt <- options(
      cli.width = getOption("cli.condition_width") %||% getOption("cli.width")
    )
  }
  on.exit(options(oldopt), add =TRUE)

  # The prefix itself might be longer than the screen width, so let's
  # wrap that first. We use ansi_strwrap(), because it handles the width
  # of UTF-8 characters properly.
  prefix <- enc2utf8(ansi_strip(prefix))
  if (utf8_nchar(prefix, "width") > console_width()) {
    prefix <- last(ansi_strwrap(prefix))
  }
  message[1] <- paste0(prefix, message[1])

  # We need to create a frame here, so cli_div() is closed.
  # Cannot use local(), it does not work in snapshot tests, it potentially
  # has issues elsewhere as well.
  formatted1 <- fmt((function() {
    cli_div(class = "cli_rlang cli_abort")
    cli_bullets(message, .envir = .envir)
  })(), collapse = TRUE, strip_newline = TRUE)

  # remove "Error: " that was only needed for the wrapping

  formatted1[1] <- sub(prefix, "", formatted1[1])

  update_rstudio_color(formatted1)
}

#' @rdname format_error
#' @export

format_warning <- function(message, .envir = parent.frame()) {
  if (is.null(names(message)) || names(message)[1] == "") {
    # The default theme will make this bold
    names(message)[1] <- "1"
  }

  oldopt <- options(
    cli.width = getOption("cli.condition_width") %||% getOption("cli.width")
  )
  on.exit(options(oldopt), add = TRUE)

  formatted1 <- fmt((function() {
    cli_div(class = "cli_rlang cli_warn")
    cli_bullets(message, .envir = .envir)
  })(), collapse = TRUE, strip_newline = TRUE)

  update_rstudio_color(formatted1)
}

#' @rdname format_error
#' @export

format_message <- function(message, .envir = parent.frame()) {
  oldopt <- options(
    cli.width = getOption("cli.condition_width") %||% getOption("cli.width")
  )
  on.exit(options(oldopt), add = TRUE)
  formatted1 <- fmt((function() {
    cli_div(class = "cli_rlang cli_inform")
    cli_bullets(message, .envir = .envir)
  })(), collapse = TRUE, strip_newline = TRUE)
  update_rstudio_color(formatted1)
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
