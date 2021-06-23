
is_yes <- function(x) {
  tolower(x) %in% c("true", "yes", "y", "t", "1")
}

format_iso_8601 <- function(p) {
  format(p, "%Y-%m-%dT%H:%M:%S+00:00")
}
