
make_space <- function(len) {
  strrep(" ", len)
}

strrep <- function(x, ...) {
  res <- base::strrep(x, ...)
  Encoding(res) <- Encoding(x)
  res
}
