
#' @export

cli_capabilities <- function() {
  c(
    unicode = is_utf8_output(),
    interactive = is_interactive(),
    dynamic_stdout = is_dynamic_tty(stdout()),
    dynamic_stderr = is_dynamic_tty(stderr()),
    dark_theme = detect_dark_theme("auto")
  )
}
