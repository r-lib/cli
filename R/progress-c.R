
progress_c_update <- function(bar) {
  caller <- sys.frame(sys.nframe() - 1L)
  cat(".")
}
