
#' @export

cli_progress_builtin_handlers <- function() {
  names(builtin_handlers)
}

cli_progress_select_handlers <- function() {
  list(builtin_handler_cli)
}

builtin_handler_cli <- list(
  # no create method
  add = function(bar, .envir) {
    opt <- options(cli__pb = bar)
    on.exit(options(opt), add = TRUE)
    bar$statusbar <- cli_status(
      bar$format,
      msg_done = bar$format_done %||% bar$format,
      msg_failed = bar$format_failed %||% bar$format,
      .auto_close = FALSE,
      .envir = .envir,
    )
  },

  set = function(bar, .envir) {
    opt <- options(cli__pb = bar)
    on.exit(options(opt), add = TRUE)
    cli_status_update(id = bar$statusbar, bar$format, .envir = .envir)
  },

  complete = function(bar, .envir, result) {
    opt <- options(cli__pb = bar)
    on.exit(options(opt), add = TRUE)
    if (isTRUE(bar$added)) {
      if (bar$clear) {
        cli_status_clear(bar$statusbar, result = "clear", .envir = .envir)
      } else {
        opt <- options(cli__pb = bar)
        on.exit(options(opt), add = TRUE)
        cli_status_clear(
          bar$statusbar,
          result = result,
          msg_done = bar$format_done,
          msg_failed = bar$format_failed,
          .envir = .envir
        )
      }
    }
    bar$statusbar <- TRUE
  }
)

builtin_handlers <- list(
  cli = builtin_handler_cli
)
