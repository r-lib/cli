
# ------------------------------------------------------------------------

#' @title Progress bar variables
#'
#' @details These variables can be used in cli progress bar format strings.
#'
#' * `pb_bar` creates a visual progress bar. If the number of total units
#' is unknown, then it will return an empty string.
#'
#' * `pb_current` is the number of current progress units.
#'
#' * `pb_current_bytes` is the number of current progress utils formatted
#' as bytes. The output has a constant width of six characters.
#'
#' * `pb_elapsed` is the elapsed time since the start of the progress
#' bar. The time is measured since the progress bar is created with
#' [cli_progress_bar()] or similar.
#'
#' * `pb_elapsed_clock` is the elapsed time, in hh::mm::ss format.
#'
#' * `pb_elapsed_raw` is the number of seconds since the start of the
#' progress bar.
#'
#' * `pb_eta` is the estimated time until the end of the progress bar,
#' in human readable form.
#'
#' * `pb_eta_raw` is the estimated time until the end of the progress
#' bar, in seconds.
#'
#' * `pb_eta_str` is the estimated time until the end of the progress bar.
#' It includes the `"ETA:"` prefix. It is only shown if the time can be
#' estimated, otherwise it is the empty string.
#'
#' * `pb_id` is the id of the progress bar. The id has the format
#' `cli-<pid>-<counter>` where `<pid>` is the process id, and
#' `<counter>` is an integer counter that is incremented every time
#' cli needs a new unique id.
#'
#' * `pb_name` is the name of the progress bar. This is supplied by the
#' developer, and it is by default the empty string. A space character
#' is added to non-empty names.
#'
#' * `pb_percent` is the percentage of the progress bar, always formatted
#' in three characters plus the percentage sign. If the total number of
#' units is unknown, then it is `" NA%"`.
#'
#' * `pb_pid` is the integer process id of the progress bar.
#'
#' * `pb_rate` is the progress rate, in number of units per second,
#' formatted in a string.
#'
#' * `pb_rate_raw` is the raw progress rate, in number of units per second.
#'
#' * `pb_rate_bytes` is the progress rate, formatted as bytes per second,
#' in human readable form.
#'
#' * `pb_spin` is a spinner. The default spinner is selected via a
#' [get_spinner()] call.
#'
#' * `pb_status` is the status string of the progress bar. By default this
#' is an empty string, but it is possible to set it in [cli_progress_bar()]
#' and `cli_progress_update()].
#'
#' * `pb_timestamp` is a time stamp in ISO 8601 format.
#'
#' * `pb_total` is the total number of progress units, or `NA` if the number
#' of units is unknown.
#'
#' * `pb_total_bytes` is the total number of progress units, formatted as
#' bytes, in a human readable format.
#'
#' @export pb_bar pb_current pb_current_bytes pb_elapsed pb_elapsed_clock
#' @export pb_elapsed_raw pb_eta pb_eta_raw pb_eta_str pb_id pb_name
#' @export pb_percent pb_pid pb_rate pb_rate_raw pb_rate_bytes pb_spin
#' @export pb_status pb_timestamp pb_total pb_total_bytes
#'
#' @aliases pb_bar pb_current pb_current_bytes pb_elapsed pb_elapsed_clock
#' @aliases pb_elapsed_raw pb_eta pb_eta_raw pb_eta_str pb_id pb_name
#' @aliases pb_percent pb_pid pb_rate pb_rate_raw pb_rate_bytes pb_spin
#' @aliases pb_status pb_timestamp pb_total pb_total_bytes
#'
#' @name progress-variables
#' @examples
#' # pb_bar and pb_percent
#' cli_progress_demo(
#'   format = "Progress bar: {cli::pb_bar} {cli::pb_percent}",
#'   total = 100
#' )
#'
#' # pb_current and pb_total
#' cli_progress_demo(
#'   format = "[{cli::pb_current}/{cli::pb_total}]",
#'   total = 248
#' )
#'
#' # pb_current_bytes, pb_total_bytes
#' cli_progress_demo(
#'   format = "[{cli::pb_current_bytes}/{cli::pb_total_bytes}]",
#'   total = 102800,
#'   at = seq(0, 102800, by = 1024)
#' )
NULL

# ------------------------------------------------------------------------

#' cli progress bar demo
#'
#' Useful for experimenting with format strings and for documentation.
#' It creates a progress bar, iterates it until it terminates and saves the
#' progress updates.
#'
#' @param name Passed to [cli_progress_bar()].
#' @param status Passed to [cli_progress_bar()].
#' @param type Passed to [cli_progress_bar()].
#' @param total Passed to [cli_progress_bar()].
#' @param .envir Passed to [cli_progress_bar()].
#' @param ... Passed to [cli_progress_bar()].
#' @param at The number of progress units to show and capture the progress
#'   bar at. If `NULL`, then a sequence of states is generated to show the
#'   progress from beginning to end.
#' @param show_after Delay to show the progress bar. Overrides the
#'   `cli.progress_show_after` option.
#' @param live Whether to show the progress bat on the screen, or just
#'   return the recorded updates. Defaults to the value of the
#'   `cli.progress_demo_live` options. If unset, then it is `TRUE` in
#'   interactive sessions.
#' @param delay Delay between progress bar updates.
#' @param start Time to subtract from the start time, to simulate a
#'   progress bar that takes longer to run.
#'
#' @return List with class `cli_progress_demo`, which has a print and a
#' format method for prretty printing. The `lines` entry contains the
#' output lines, each correcponding to one update.
#'
#' @export

cli_progress_demo <- function(name = NULL, status = NULL,
                              type = c("iterator", "tasks",
                                       "download", "custom"),
                              total = NA,
                              .envir = parent.frame(),
                              ...,
                              at = if (is_interactive()) NULL else 50,
                              show_after = 0,
                              live = NULL,
                              delay = 0,
                              start = as.difftime(5, units = "secs")) {

  opt <- options(cli.progress_show_after = show_after)
  on.exit(options(opt), add = TRUE)

  live <- live %||%
    getOption("cli.progress_demo_live") %||%
    is_interactive()
  
  id <- cli_progress_bar(
    name = name,
    status = status,
    type = type,
    total = total,
    ...,
    .envir = .envir,
    current = FALSE
  )
  bar <- clienv$progress[[id]]
  bar$start <- bar$start - as.double(start, units = "secs")

  last <- is.null(at)
  if (is.null(at)) {
    if (is.na(total)) {
      at <- 1:50
    } else {
      at <- seq_len(total)
    }
  }

  output <- file(open = "w+b")
  on.exit(close(output), add = TRUE)
  size <- 0L

  withCallingHandlers({
    for (crnt in at) {
      cli_progress_update(set = crnt, id = id, force = TRUE, .envir = .envir)
      if (delay > 0) Sys.sleep(delay)
    }
    if (last) {
      cli_progress_done(id = id, .envir = .envir)
    } else {
      suppressMessages(cli_progress_done(id = id, .envir = .envir))
    }
  }, cliMessage = function(msg) {
    cat(file = output, msg$message)
    size <<- size + nchar(msg$message, type = "bytes")
    if (!live) invokeRestart("muffleMessage")
  })

  lines <- readChar(output, size, useBytes = TRUE)
  lines <- sub("^\r\r*", "", lines, useBytes = TRUE)
  lines <- sub("\r\r*$", "", lines, useBytes = TRUE)
  lines <- gsub("\r\r*", "\r", lines, useBytes = TRUE)
  lines <- strsplit(lines, "[\r\n]", useBytes = TRUE)[[1]]
  
  res <- structure(
    list(lines = lines),
    class = "cli_progress_demo"
  )

  if (live) invisible(res) else res
}

#' @export

format.cli_progress_demo <- function(x, ...) {
  x$lines
}

#' @export

print.cli_progress_demo <- function(x, ...) {
  cat(format(x, ...), sep = "\n")
}

# ------------------------------------------------------------------------

cli__pb_bar <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) return("")
  if (is.na(pb$total)) return("")
  structure(
    list(current = pb$current, total = pb$total),
    class = "cli-progress-bar"
  )
}

cli__pb_current <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) return("")
  pb$current
}

cli__pb_current_bytes <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) return("")
  format_bytes$pretty_bytes(pb$current, style = "6")
}

cli__pb_elapsed <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) return("")
  secs <- (.Call(clic_get_time) - pb$start) * clienv$speed_time
  format_time$pretty_sec(secs)
}

cli__pb_elapsed_clock <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) return("")
  s <- (.Call(clic_get_time) - pb$start) * clienv$speed_time
  hours <- floor(s / 3600)
  minutes <- floor((s / 60) %% 60)
  seconds <- round(s %% 60, 1)
  paste0(
    formatC(hours, width = 2, flag = "0"),
    ":",
    formatC(minutes, width = 2, flag = "0"),
    ":",
    formatC(seconds, width = 2, flag = "0")
  )
}

cli__pb_elapsed_raw <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) return("")
  (.Call(clic_get_time) - pb$start) * clienv$speed_time
}

cli__pb_eta <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) return("")
  eta <- cli__pb_eta_raw(pb)
  if (is.na(eta)) {
    "?"
  } else {
    format_time_ago$vague_dt(eta, format = "terse")
  }
}

cli__pb_eta_raw <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) return("")
  if (is.na(pb$total)) return(NA_real_)
  if (pb$current == pb$total) return(as.difftime(0, units = "secs"))
  if (pb$current == 0L) return(NA_real_)
  elapsed <- (.Call(clic_get_time) - pb$start) * clienv$speed_time
  as.difftime(elapsed * (pb$total / pb$current - 1.0), units = "secs")
}

cli__pb_eta_str <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) return("")
  eta <- cli__pb_eta(pb)
  if (eta != "?") paste0("ETA: ", eta) else ""
}

cli__pb_id <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) return("")
  pb$id
}

cli__pb_name <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) return("")
  if (!is.null(pb$name)) {
    paste0(pb$name, " ")
  } else {
    ""
  }
}

cli__pb_percent <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) return("")
  paste0(format(round(pb$current / pb$total * 100), width = 3), "%")
}

cli__pb_pid <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) return("")
  pb$pid %||% Sys.getpid()
}

cli__pb_rate <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) return("")
  rate <- cli__pb_rate_raw(pb)
  paste0(format(rate, digits = 2), "/s")
}

cli__pb_rate_raw <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) return("")
  elapsed <- cli__pb_elapsed_raw(pb)
  pb$current / elapsed
}

cli__pb_rate_bytes <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) return("")
  rate <- cli__pb_rate_raw(pb)
  paste0(
    format_bytes$pretty_bytes(rate, style = "6"),
    "/s"
  )
}

cli__pb_spin <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) return("")

  pb$spinner <- pb$spinner %||% get_spinner()
  nx <- pb$tick %% length(pb$spinner$frames) + 1L
  pb$spinner$frames[[nx]]
}

cli__pb_status <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) return("")
  if (!is.null(pb$status)) {
    paste0(pb$status, " ")
  } else {
    ""
  }
}

cli__pb_timestamp <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) return("")
  st <- Sys.time()
  if (clienv$speed_time != 1.0) {
    st <- clienv$load_time + (st - clienv$load_time) * clienv$speed_time
  }
  format_iso_8601(st)
}

cli__pb_total <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) return("")
  pb$total
}

cli__pb_total_bytes <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) return("")
  format_bytes$pretty_bytes(pb$total, style = "6")
}
