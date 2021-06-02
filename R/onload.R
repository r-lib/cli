
#' @useDynLib cli, .registration=TRUE
NULL

## nocov start

dummy <- function() { }

cli_timer_interactive <- 200L
cli_timer_non_interactive <- 3000L

clienv <- new.env(parent = emptyenv())
clienv$pid <- Sys.getpid()
clienv$globalenv <- format(.GlobalEnv)
clienv$status <- list()
clienv$progress <- list()
clienv$progress_ids <- list()

clienv$load_time <- NULL
clienv$speed_time <- 1.0
clienv$tick_time <- 200L

.onLoad <- function(libname, pkgname) {

  # Try to restore cursor as much as we can
  if (isatty(stdout())) {
    reg.finalizer(clienv, function(e) cli::ansi_show_cursor(), TRUE)
    addTaskCallback(
      function(...) { cli::ansi_show_cursor(); TRUE },
      "cli-show-cursor"
    )
  }

  pkgenv <- environment(dummy)

  clienv$load_time <- Sys.time()

  clienv$speed_time <- as.double(Sys.getenv("CLI_SPEED_TIME", "1.0"))

  tt <- as.integer(Sys.getenv("CLI_TICK_TIME", NA_character_))
  if (is.na(tt)) {
    tt <- if (interactive()) {
      cli_timer_interactive
    } else {
      cli_timer_non_interactive
    }
  }

  clienv$tick_time <- as.integer(tt)
  .Call(
    clic_start_thread,
    pkgenv,
    clienv$tick_time,
    clienv$speed_time
  )

  should_tick <<- .Call(clic_make_timer);

  ccli_tick_reset <<- clic_tick_reset

  makeActiveBinding(
    "symbol",
    function() {
      ## If `cli.unicode` is set we use that
      opt <- getOption("cli.unicode",  NULL)
      if (!is.null(opt)) {
        if (isTRUE(opt)) {
          if (rstudio$is_rstudio()) {
            return(symbol_rstudio)
          } else {
            return(symbol_utf8)
          }
        } else {
          return(symbol_ascii)
        }
      }

      ## Otherwise we try to auto-detect
      rst <- rstudio$detect()$type
      rok <- c("rstudio_console", "rstudio_console_starting")
      if (is_utf8_output() && rstudio$is_rstudio()) {
        symbol_rstudio
      } else if (is_utf8_output()) {
        symbol_utf8
      } else if (is_latex_output()) {
        symbol_ascii
      } else if (is_windows() && .Platform$GUI == "Rgui") {
        symbol_win
      } else if (is_windows() && rst %in% rok) {
        symbol_win
      } else {
        symbol_ascii
      }
    },
    pkgenv
  )

  makeActiveBinding("pb_bar",            cli__pb_bar,           pkgenv)
  makeActiveBinding("pb_current",        cli__pb_current,       pkgenv)
  makeActiveBinding("pb_current_bytes",  cli__pb_current_bytes, pkgenv)
  makeActiveBinding("pb_elapsed",        cli__pb_elapsed,       pkgenv)
  makeActiveBinding("pb_elapsed_clock",  cli__pb_elapsed_clock, pkgenv)
  makeActiveBinding("pb_elapsed_raw",    cli__pb_elapsed_raw,   pkgenv)
  makeActiveBinding("pb_eta",            cli__pb_eta,           pkgenv)
  makeActiveBinding("pb_eta_raw",        cli__pb_eta_raw,       pkgenv)
  makeActiveBinding("pb_id",             cli__pb_id,            pkgenv)
  makeActiveBinding("pb_name",           cli__pb_name,          pkgenv)
  makeActiveBinding("pb_percent",        cli__pb_percent,       pkgenv)
  makeActiveBinding("pb_pid",            cli__pb_pid,           pkgenv)
  makeActiveBinding("pb_rate",           cli__pb_rate,          pkgenv)
  makeActiveBinding("pb_rate_raw",       cli__pb_rate_raw,      pkgenv)
  makeActiveBinding("pb_rate_bytes",     cli__pb_rate_bytes,    pkgenv)
  makeActiveBinding("pb_spin",           cli__pb_spin,          pkgenv)
  makeActiveBinding("pb_status",         cli__pb_status,        pkgenv)
  makeActiveBinding("pb_timestamp",      cli__pb_timestamp,     pkgenv)
  makeActiveBinding("pb_total",          cli__pb_total,         pkgenv)
  makeActiveBinding("pb_total_bytes",    cli__pb_total_bytes,   pkgenv)

  if (is.null(getOption("callr.condition_handler_cli_message"))) {
    options(callr.condition_handler_cli_message = cli__default_handler)
  }
}

.onUnload <- function(libpath) {
  .Call(clic_unload)
}

## nocov end
