
make_progress_bar <- function(percent, width = 30, style = list()) {
  complete_len <- round(width * percent)

  def <- default_progress_style()
  chr_complete <- style[["progress-complete"]] %||% def[["complete"]]
  chr_incomplete <- style[["progress-incomplete"]] %||% def[["incomplete"]]
  chr_current <- style[["progress-current"]] %||% def[["current"]]

  complete <- paste(rep(chr_complete, complete_len), collapse = "")
  current <- if (percent == 100) chr_complete else chr_current
  incomplete <- paste(rep(chr_incomplete, width - complete_len), collapse = "")
  paste0(complete, current, incomplete)
}
