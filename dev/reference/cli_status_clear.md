# Clear the status bar (superseded)

**The `cli_status_*()` functions are superseded by the
[`cli_progress_message()`](https://cli.r-lib.org/dev/reference/cli_progress_message.md)
and
[`cli_progress_step()`](https://cli.r-lib.org/dev/reference/cli_progress_step.md)
functions, because they have a better default behavior.**

Clear the status bar

## Usage

``` r
cli_status_clear(
  id = NULL,
  result = c("clear", "done", "failed"),
  msg_done = NULL,
  msg_failed = NULL,
  .envir = parent.frame()
)
```

## Arguments

- id:

  Id of the status bar container to clear. If `id` is not the id of the
  current status bar (because it was overwritten by another status bar
  container), then the status bar is not cleared. If `NULL` (the
  default) then the status bar is always cleared.

- result:

  Whether to show a message for success or failure or just clear the
  status bar.

- msg_done:

  If not `NULL`, then the message to use for successful process
  termination. This overrides the message given when the status bar was
  created.

- msg_failed:

  If not `NULL`, then the message to use for failed process termination.
  This overrides the message give when the status bar was created.

- .envir:

  Environment to evaluate the glue expressions in. It is also used to
  auto-clear the status bar if `.auto_close` is `TRUE`.

## See also

The
[`cli_progress_message()`](https://cli.r-lib.org/dev/reference/cli_progress_message.md)
and
[`cli_progress_step()`](https://cli.r-lib.org/dev/reference/cli_progress_step.md)
functions, for a superior API.

Other status bar:
[`cli_process_start()`](https://cli.r-lib.org/dev/reference/cli_process_start.md),
[`cli_status()`](https://cli.r-lib.org/dev/reference/cli_status.md),
[`cli_status_update()`](https://cli.r-lib.org/dev/reference/cli_status_update.md)
