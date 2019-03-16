
## This is how the RDS file is created:

'
json <- "https://raw.githubusercontent.com/sindresorhus/cli-spinners/dac4fc6571059bb9e9bc204711e9dfe8f72e5c6f/spinners.json"
parsed <- jsonlite::fromJSON(json, simplifyVector = TRUE)
pasis <- lapply(parsed, function(x) { x$frames <- I(x$frames); x })
pdt <- as.data.frame(do.call(rbind, pasis))
pdt$name <- rownames(pdt)
rownames(pdt) <- NULL
spinners <- pdt[, c("name", "interval", "frames")]
usethis::use_data(spinners, internal = TRUE)
'

#' Character vector to put a spinner on the screen
#'
#' `cli` contains many different spinners, you choose one according to your
#' taste.
#'
#' @param which The name of the chosen spinner. The default depends on
#'   whether the platform supports Unicode.
#' @return A list with entries: `name`, `interval`: the suggested update
#'   interval in milliseconds and `frames`: the character vector of the
#'   spinner's frames.
#'
#' @family spinners
#' @export
#' @examples
#' get_spinner()
#' get_spinner("shark")

get_spinner <- function(which = NULL) {
  assert_that(is.null(which) || is_string(which))

  if (is.null(which)) {
    which <- if (is_utf8_output()) "dots" else "line"
  }

  row <- match(which, spinners$name)
  list(
    name = which,
    interval = spinners$interval[[row]],
    frames = spinners$frames[[row]])
}

#' List all available spinners
#'
#' @return Character vector of all available spinner names.
#'
#' @family spinners
#' @export
#' @examples
#' list_spinners()
#' get_spinner(list_spinners()[1])

list_spinners <- function() {
  spinners$name
}

#' Create a spinner
#'
#' @param template A template string, that will contain the spinner. The
#'   spinner itself will be substituted for `{spin}`. See example below.
#' @param stream The stream to use for the spinner. Typically this is
#'   standard error, or maybe the standard output stream.
#' @param static What to do if the terminal does not support dynamic
#'   displays:
#'   * `"dots"`: show a dot for each `$spin()` call.
#'   * `"print"`: just print the frames of the spinner, one after another.
#'   * `"print_line"`: print the frames of the spinner, each on its own line.
#'   * `"silent"` do not print anything, just the `template`.
#' @inheritParams get_spinner
#' @return A `cli_spinner` object, which is a list of functions. See
#'   its methods below.
#'
#' `cli_spinner` methods:
#' * `$spin()`: output the next frame of the spinner.
#' * `$finish()`: terminate the spinner. Depending on terminal capabilities
#'   this removes the spinner from the screen. Spinners can be reused,
#'   you can start calling the `$spin()` method again.
#'
#' All methods return the spinner object itself, invisibly.
#'
#' The spinner is automatically throttled to its ideal update frequency.
#'
#' @family spinners
#' @export
#' @examples
#' ## Default spinner
#' sp1 <- make_spinner()
#' fun_with_spinner <- function() {
#'   lapply(1:100, function(x) { sp1$spin(); Sys.sleep(0.05) })
#'   sp1$finish()
#' }
#' ansi_with_hidden_cursor(fun_with_spinner())
#'
#' ## Spinner with a template
#' sp2 <- make_spinner(template = "Computing {spin}")
#' fun_with_spinner2 <- function() {
#'   lapply(1:100, function(x) { sp2$spin(); Sys.sleep(0.05) })
#'   sp2$finish()
#' }
#' ansi_with_hidden_cursor(fun_with_spinner2())
#'
#' ## Custom spinner
#' sp3 <- make_spinner("simpleDotsScrolling", template = "Downloading {spin}")
#' fun_with_spinner3 <- function() {
#'   lapply(1:100, function(x) { sp3$spin(); Sys.sleep(0.05) })
#'   sp2$finish()
#' }
#' ansi_with_hidden_cursor(fun_with_spinner3())

make_spinner <- function(which = NULL, stream = stderr(), template = "{spin}",
                         static = c("dots", "print", "print_line",
                                    "silent")) {

  assert_that(
    inherits(stream, "connection"),
    is_string(template))

  c_stream <- stream
  c_spinner <- get_spinner(which)
  c_template <- template
  c_static <- match.arg(static)
  c_state <- 1L
  c_first <- TRUE
  c_col <- 1L
  c_width <- console_width()
  c_last <- Sys.time() - as.difftime(1, units = "secs")
  c_int <- as.difftime(c_spinner$interval / 1000, units = "secs")

  c_res <- list()

  throttle <- function() Sys.time() - c_last < c_int
  clear_line <- function() {
    str <- paste0(c("\r", rep(" ", c_width), "\r"), collapse = "")
    cat(str, file = c_stream)
  }
  inc <- function() {
    c_state <<- c_state + 1L
    c_first <<- FALSE
    if (c_state > length(c_spinner$frames)) c_state <<- 1L
    c_last <<- Sys.time()
    invisible(c_res)
  }

  c_res$finish <- function() {
    c_state <<- 1L
    c_first <<- TRUE
    c_col <<- 1L
    c_last <<- Sys.time()
    if (is_dynamic_tty()) clear_line() else cat("\n", file = c_stream)
    invisible(c_res)
  }

  if (is_dynamic_tty()) {
    c_res$spin <- function(template = NULL) {
      if (!is.null(template)) c_template <<- template
      if (throttle()) return()
      line <- sub("{spin}", c_spinner$frames[[c_state]], c_template,
                  fixed = TRUE)
      cat("\r", line, sep = "", file = stream)
      inc()
    }

  } else {
    if (c_static == "dots") {
      c_res$spin <- function(template = NULL) {
        if (!is.null(template)) c_template <<- template
        if (c_first) cat(template, "\n", sep = "", file = c_stream)
        if (throttle()) return()
        cat(".", file = c_stream)
        c_col <<- c_col + 1L
        if (c_col == c_width) {
          cat("\n", file = c_stream)
          c_col <<- 1L
        }
        inc()
      }
    } else if (c_static == "print") {
      c_res$spin <- function(template = NULL) {
        if (!is.null(template)) c_template <<- template
        if (throttle()) return()
        line <- sub("{spin}", c_spinner$frames[[c_state]], c_template,
                    fixed = TRUE)
        cat(line, file = stream)
        inc()
      }
    } else if (c_static == "print_line") {
      c_res$spin <- function(template = NULL) {
        if (!is.null(template)) c_template <<- template
        if (throttle()) return()
        line <- sub("{spin}", c_spinner$frames[[c_state]], c_template,
                    fixed = TRUE)
        cat(line, "\n", sep = "", file = stream)
        inc()
      }
    } else if (c_static == "silent") {
      c_res$spin <- function(template = NULL) {
        if (!is.null(template)) c_template <<- template
        if (throttle()) return()
        inc()
      }
    }
  }

  class(c_res) <- "cli_spinner"
  c_res
}

#' @export

print.cli_spinner <- function(x, ...) {
  cat("<cli_spinner>\n")
  invisible(x)
}

## nocov start

#' Show a demo of some (by default all) spinners
#'
#' Each spinner is shown for about 2-3 seconds.
#'
#' @param which Character vector, which spinners to demo.
#'
#' @family spinners
#' @export
#' @examples
#' \dontrun{
#'   demo_spinners(sample(list_spinners(), 10))
#' }

demo_spinners <- function(which = NULL) {
  assert_that(is.null(which) || is.character(which))

  all <- list_spinners()
  which <- which %||% all

  if (length(bad <- setdiff(which, all))) {
    stop("Unknown spinners: ", paste(bad, collapse = ", "))
  }

  for (w in which) {
    sp <- get_spinner(w)
    interval <- sp$interval / 1000
    frames <- sp$frames
    cycles <- max(round(2.5 / ((length(frames) - 1) * interval)), 1)
    for (i in 1:(length(frames) * cycles) - 1) {
      fr <- unclass(frames[i %% length(frames) + 1])
      cat("\r", rpad(fr, width = 10), w, sep = "")
      Sys.sleep(interval)
    }
    cat("\n")
  }
}

demo_spinners_terminal <- function() {
  up <- function(n) cat(paste0("\u001B[", n, "A"))
  show <- function() cat("\u001b[?25h")
  hide <- function() cat("\u001b[?25l")

  on.exit(show(), add = TRUE)

  names <- unlist(spinners$name)
  frames <- spinners$frames
  intervals <- unlist(spinners$interval)
  num_frames <- viapply(frames, length)
  spin_width <- viapply(frames, function(x) max(nchar(x, type = "width")))
  name_width <- nchar(names, type = "width")
  col_width <- spin_width + max(name_width) + 3
  col1_width <- max(col_width[1:(length(col_width)/2)])

  frames <- mapply(
    frames,
    names,
    FUN = function(f, n) {
      rpad(paste(lpad(n, max(name_width) + 2), f), col1_width)
    }
  )

  hide()

  for (tick in 0:1000000) {
    tic <- Sys.time()
    wframe <- trunc(tick / intervals) %% num_frames + 1
    sp <- mapply(frames, wframe, FUN = "[")

    sp2 <- paste(
      sep = "  ",
      sp[1:(length(sp) / 2)],
      sp[(length(sp) / 2 + 1):length(sp)]
    )

    cat(sp2, sep = "\n")
    up(length(sp2))
    took <- Sys.time() - tic
    togo <- as.difftime(1/1000, units = "secs") - took
    if (togo > 0) Sys.sleep(togo)
  }

}

## nocov end
