# Indicate the start and termination of some computation in the status bar (superseded)

**The `cli_process_*()` functions are superseded by the
[`cli_progress_message()`](https://cli.r-lib.org/dev/reference/cli_progress_message.md)
and
[`cli_progress_step()`](https://cli.r-lib.org/dev/reference/cli_progress_step.md)
functions, because they have a better default behavior.**

Typically you call `cli_process_start()` to start the process, and then
`cli_process_done()` when it is done. If an error happens before
`cli_process_done()` is called, then cli automatically shows the message
for unsuccessful termination.

## Usage

``` r
cli_process_start(
  msg,
  msg_done = paste(msg, "... done"),
  msg_failed = paste(msg, "... failed"),
  on_exit = c("auto", "failed", "done"),
  msg_class = "alert-info",
  done_class = "alert-success",
  failed_class = "alert-danger",
  .auto_close = TRUE,
  .envir = parent.frame()
)

cli_process_done(
  id = NULL,
  msg_done = NULL,
  .envir = parent.frame(),
  done_class = "alert-success"
)

cli_process_failed(
  id = NULL,
  msg = NULL,
  msg_failed = NULL,
  .envir = parent.frame(),
  failed_class = "alert-danger"
)
```

## Arguments

- msg:

  The message to show to indicate the start of the process or
  computation. It will be collapsed into a single string, and the first
  line is kept and cut to
  [`console_width()`](https://cli.r-lib.org/dev/reference/console_width.md).

- msg_done:

  The message to use for successful termination.

- msg_failed:

  The message to use for unsuccessful termination.

- on_exit:

  Whether this process should fail or terminate successfully when the
  calling function (or the environment in `.envir`) exits.

- msg_class:

  The style class to add to the message. Use an empty string to suppress
  styling.

- done_class:

  The style class to add to the successful termination message. Use an
  empty string to suppress styling.a

- failed_class:

  The style class to add to the unsuccessful termination message. Use an
  empty string to suppress styling.a

- .auto_close:

  Whether to clear the status bar when the calling function finishes (or
  `.envir` is removed from the stack, if specified).

- .envir:

  Environment to evaluate the glue expressions in. It is also used to
  auto-clear the status bar if `.auto_close` is `TRUE`.

- id:

  Id of the status bar container to clear. If `id` is not the id of the
  current status bar (because it was overwritten by another status bar
  container), then the status bar is not cleared. If `NULL` (the
  default) then the status bar is always cleared.

## Value

Id of the status bar container.

## Details

If you handle the errors of the process or computation, then you can do
the opposite: call `cli_process_start()` with `on_exit = "done"`, and in
the error handler call `cli_process_failed()`. cli will automatically
call `cli_process_done()` on successful termination, when the calling
function finishes.

See examples below.

## See also

This function supports [inline
markup](https://cli.r-lib.org/dev/reference/inline-markup.md).

The
[`cli_progress_message()`](https://cli.r-lib.org/dev/reference/cli_progress_message.md)
and
[`cli_progress_step()`](https://cli.r-lib.org/dev/reference/cli_progress_step.md)
functions, for a superior API.

Other status bar:
[`cli_status()`](https://cli.r-lib.org/dev/reference/cli_status.md),
[`cli_status_clear()`](https://cli.r-lib.org/dev/reference/cli_status_clear.md),
[`cli_status_update()`](https://cli.r-lib.org/dev/reference/cli_status_update.md)

Other functions supporting inline markup:
[`cli_abort()`](https://cli.r-lib.org/dev/reference/cli_abort.md),
[`cli_alert()`](https://cli.r-lib.org/dev/reference/cli_alert.md),
[`cli_blockquote()`](https://cli.r-lib.org/dev/reference/cli_blockquote.md),
[`cli_bullets()`](https://cli.r-lib.org/dev/reference/cli_bullets.md),
[`cli_bullets_raw()`](https://cli.r-lib.org/dev/reference/cli_bullets_raw.md),
[`cli_dl()`](https://cli.r-lib.org/dev/reference/cli_dl.md),
[`cli_h1()`](https://cli.r-lib.org/dev/reference/cli_h1.md),
[`cli_li()`](https://cli.r-lib.org/dev/reference/cli_li.md),
[`cli_ol()`](https://cli.r-lib.org/dev/reference/cli_ol.md),
[`cli_progress_along()`](https://cli.r-lib.org/dev/reference/cli_progress_along.md),
[`cli_progress_bar()`](https://cli.r-lib.org/dev/reference/cli_progress_bar.md),
[`cli_progress_message()`](https://cli.r-lib.org/dev/reference/cli_progress_message.md),
[`cli_progress_output()`](https://cli.r-lib.org/dev/reference/cli_progress_output.md),
[`cli_progress_step()`](https://cli.r-lib.org/dev/reference/cli_progress_step.md),
[`cli_rule`](https://cli.r-lib.org/dev/reference/cli_rule.md),
[`cli_status()`](https://cli.r-lib.org/dev/reference/cli_status.md),
[`cli_status_update()`](https://cli.r-lib.org/dev/reference/cli_status_update.md),
[`cli_text()`](https://cli.r-lib.org/dev/reference/cli_text.md),
[`cli_ul()`](https://cli.r-lib.org/dev/reference/cli_ul.md),
[`format_error()`](https://cli.r-lib.org/dev/reference/format_error.md),
[`format_inline()`](https://cli.r-lib.org/dev/reference/format_inline.md)

## Examples

``` r
## Failure by default
fun <- function() {
  cli_process_start("Calculating")
  if (interactive()) Sys.sleep(1)
  if (runif(1) < 0.5) stop("Failed")
  cli_process_done()
}
tryCatch(fun(), error = function(err) err)
#> ℹ Calculating
#> ✖ Calculating ... failed
#> 
#> <simpleError in fun(): Failed>

## Success by default
fun2 <- function() {
  cli_process_start("Calculating", on_exit = "done")
  tryCatch({
    if (interactive()) Sys.sleep(1)
    if (runif(1) < 0.5) stop("Failed")
  }, error = function(err) cli_process_failed())
}
fun2()
#> ℹ Calculating
#> ✔ Calculating ... done
#> 
```
