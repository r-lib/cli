
# ------------------------------------------------------------------------

#' @export pb_bar pb_current pb_current_bytes pb_elapsed pb_elapsed_clock
#' @export pb_elapsed_time pb_eta pb_eta_raw pb_id pb_name pb_percent
#' @export pb_pid pb_rate pb_rate_raw pb_rate_bytes pb_spin pb_status
#' @export pb_timestamp pb_total pb_total_bytes
NULL

# ------------------------------------------------------------------------

cli__pb_bar <- function(pb = getOption("cli__pb")) {
  # TODO
  "========--------"
}

cli__pb_current <- function(pb = getOption("cli__pb")) {
  pb$current
}

cli__pb_current_bytes <- function(pb = getOption("cli__pb")) {
  format_bytes$pretty_bytes(pb$current, style = "6")
}

cli__pb_elapsed <- function(pb = getOption("cli__pb")) {
  secs <- as.double(Sys.time() - pb$start, units = "secs")
  format_time$pretty_sec(secs)
}

cli__pb_elapsed_clock <- function(pb = getOption("cli__pb")) {
  s <- as.double(Sys.time() - pb$start, units = "secs")
  hours <- floor(s / 3600)
  minutes <- floor((s / 60) %% 60),
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
  as.double(Sys.time() - pb$start, units = "secs")
}

cli__pb_eta <- function(pb = getOption("cli__pb")) {
  # TODO
  "eta"
}

cli__pb_eta_raw <- function(pb = getOption("cli__pb")) {
  # TODO
  "eta_raw"
}

cli__pb_id <- function(pb = getOption("cli__pb")) {
  pb$id
}

cli__pb_name <- function(pb = getOption("cli__pb")) {
  if (!is.null(pb$name)) {
    paste0(pb$name, " ")
  } else {
    ""
  }
}

cli__pb_percent <- function(pb = getOption("cli__pb")) {
  paste0(format(pb$current / pb$total * 100, digits = 2), "%")
}

cli__pb_pid <- function(pb = getOption("cli__pb")) {
  pb$pid
}

cli__pb_rate <- function(pb = getOption("cli__pb")) {
  # TODO
  "rate"
}

cli__pb_rate_raw <- function(pb = getOption("cli__pb")) {
  # TODO
  "rate_raw"
}

cli__pb_rate_bytes <- function(pb = getOption("cli__pb")) {
  # TODO
  "rate_bytes"
}

cli__pb_spin <- function(pb = getOption("cli__pb")) {
  # TODO
  "spin"
}

cli__pb_status <- function(pb = getOption("cli__pb")) {
  if (!is.null(pb$status)) {
    paste0(pb$name, " ")
  } else {
    ""
  }
}

cli__pb_timestamp <- function(pb = getOption("cli__pb")) {
  format_iso_8601(Sys.time())
}

cli__pb_total <- function(pb = getOption("cli__pb")) {
  pb$total
}

cli__pb_total_bytes <- function(pb = getOption("cli__pb")) {
  format_bytes$pretty_bytes(pb$total, style = "6")
}
