# Update the status bar (superseded)

**The `cli_status_*()` functions are superseded by the
[`cli_progress_message()`](https://cli.r-lib.org/dev/reference/cli_progress_message.md)
and
[`cli_progress_step()`](https://cli.r-lib.org/dev/reference/cli_progress_step.md)
functions, because they have a better default behavior.**

Update the status bar

## Usage

``` r
cli_status_update(
  id = NULL,
  msg = NULL,
  msg_done = NULL,
  msg_failed = NULL,
  .envir = parent.frame()
)
```

## Arguments

- id:

  Id of the status bar to update. Defaults to the current status bar
  container.

- msg:

  Text to update the status bar with. `NULL` if you don't want to change
  it.

- msg_done:

  Updated "done" message. `NULL` if you don't want to change it.

- msg_failed:

  Updated "failed" message. `NULL` if you don't want to change it.

- .envir:

  Environment to evaluate the glue expressions in.

## Value

Id of the status bar container.

## See also

This function supports [inline
markup](https://cli.r-lib.org/dev/reference/inline-markup.md).

The
[`cli_progress_message()`](https://cli.r-lib.org/dev/reference/cli_progress_message.md)
and
[`cli_progress_step()`](https://cli.r-lib.org/dev/reference/cli_progress_step.md)
functions, for a superior API.

Other status bar:
[`cli_process_start()`](https://cli.r-lib.org/dev/reference/cli_process_start.md),
[`cli_status()`](https://cli.r-lib.org/dev/reference/cli_status.md),
[`cli_status_clear()`](https://cli.r-lib.org/dev/reference/cli_status_clear.md)

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
[`cli_process_start()`](https://cli.r-lib.org/dev/reference/cli_process_start.md),
[`cli_progress_along()`](https://cli.r-lib.org/dev/reference/cli_progress_along.md),
[`cli_progress_bar()`](https://cli.r-lib.org/dev/reference/cli_progress_bar.md),
[`cli_progress_message()`](https://cli.r-lib.org/dev/reference/cli_progress_message.md),
[`cli_progress_output()`](https://cli.r-lib.org/dev/reference/cli_progress_output.md),
[`cli_progress_step()`](https://cli.r-lib.org/dev/reference/cli_progress_step.md),
[`cli_rule`](https://cli.r-lib.org/dev/reference/cli_rule.md),
[`cli_status()`](https://cli.r-lib.org/dev/reference/cli_status.md),
[`cli_text()`](https://cli.r-lib.org/dev/reference/cli_text.md),
[`cli_ul()`](https://cli.r-lib.org/dev/reference/cli_ul.md),
[`format_error()`](https://cli.r-lib.org/dev/reference/format_error.md),
[`format_inline()`](https://cli.r-lib.org/dev/reference/format_inline.md)
