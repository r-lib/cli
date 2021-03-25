
is_yes <- function(x) {
  tolower(x) %in% c("true", "yes", "y", "t", "1")
}
