
# ------------------------------------------------------------------------

#' @export pb_bar pb_current pb_current_bytes pb_elapsed pb_elapsed_clock
#' @export pb_elapsed_raw pb_eta pb_eta_raw pb_id pb_name pb_percent
#' @export pb_pid pb_rate pb_rate_raw pb_rate_bytes pb_spin pb_status
#' @export pb_timestamp pb_total pb_total_bytes
NULL

# ------------------------------------------------------------------------

cli__pb_bar <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) stop("No progress bar")
  if (is.na(pb$total)) return("")
  structure(
    list(current = pb$current, total = pb$total),
    class = "cli-progress-bar"
  )
}

cli__pb_current <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) stop("No progress bar")
  pb$current
}

cli__pb_current_bytes <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) stop("No progress bar")
  format_bytes$pretty_bytes(pb$current, style = "6")
}

cli__pb_elapsed <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) stop("No progress bar")
  secs <- .Call(clic_get_time) * speed_time - pb$start
  format_time$pretty_sec(secs)
}

cli__pb_elapsed_clock <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) stop("No progress bar")
  s <- .Call(clic_get_time) * speed_time - pb$start
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
  if (is.null(pb)) stop("No progress bar")
  .Call(clic_get_time) * speed_time - pb$start
}

cli__pb_eta <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) stop("No progress bar")
  eta <- cli__pb_eta_raw(pb)
  if (is.na(eta)) {
    "?"
  } else {
    format_time_ago$vague_dt(eta, format = "terse")
  }
}

cli__pb_eta_raw <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) stop("No progress bar")
  if (is.na(pb$total)) return(NA_real_)
  if (pb$current == pb$total) return(as.difftime(0, units = "secs"))
  if (pb$current == 0L) return(NA_real_)
  elapsed <- .Call(clic_get_time) * speed_time - pb$start
  as.difftime(elapsed * (pb$total / pb$current - 1.0), units = "secs")
}

cli__pb_id <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) stop("No progress bar")
  pb$id
}

cli__pb_name <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) stop("No progress bar")
  if (!is.null(pb$name)) {
    paste0(pb$name, " ")
  } else {
    ""
  }
}

cli__pb_percent <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) stop("No progress bar")
  paste0(format(pb$current / pb$total * 100, digits = 0, width = 3), "%")
}

cli__pb_pid <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) stop("No progress bar")
  pb$pid
}

cli__pb_rate <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) stop("No progress bar")
  rate <- cli__pb_rate_raw(pb)
  paste0(format(rate, digits = 2), "/s")
}

cli__pb_rate_raw <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) stop("No progress bar")
  eta <- cli__pb_elapsed_raw(pb)
  pb$current / eta
}

cli__pb_rate_bytes <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) stop("No progress bar")
  rate <- cli__pb_rate_raw(pb)
  paste0(
    format_bytes$pretty_bytes(rate, style = "6"),
    "/s"
  )
}

cli__pb_spin <- function(pb = NULL) {
  set <- is.null(pb)
  if (set) pb <- getOption("cli__pb")
  if (is.null(pb)) stop("No progress bar")

  sp <- pb$spinner %||% get_spinner()
  nx <- sp$state %||% 1L
  out <- sp$frames[[nx]]
  sp$state <- (nx + 1L) %% length(sp$frames) + 1L

  pb$spinner <- sp
  if (set) options(cli__pb = pb)

  out
}

cli__pb_status <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) stop("No progress bar")
  if (!is.null(pb$status)) {
    paste0(pb$name, " ")
  } else {
    ""
  }
}

cli__pb_timestamp <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) stop("No progress bar")
  st <- Sys.time()
  if (speed_time != 1.0) st <- load_time + (st - load_time) * speed_time
  format_iso_8601(st)
}

cli__pb_total <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) stop("No progress bar")
  pb$total
}

cli__pb_total_bytes <- function(pb = getOption("cli__pb")) {
  if (is.null(pb)) stop("No progress bar")
  format_bytes$pretty_bytes(pb$total, style = "6")
}
