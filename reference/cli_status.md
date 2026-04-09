# Update the status bar (superseded)

**The `cli_status_*()` functions are superseded by the
[`cli_progress_message()`](https://cli.r-lib.org/reference/cli_progress_message.md)
and
[`cli_progress_step()`](https://cli.r-lib.org/reference/cli_progress_step.md)
functions, because they have a better default behavior.**

The status bar is the last line of the terminal. cli apps can use this
to show status information, progress bars, etc. The status bar is kept
intact by all semantic cli output.

## Usage

``` r
cli_status(
  msg,
  msg_done = paste(msg, "... done"),
  msg_failed = paste(msg, "... failed"),
  .keep = FALSE,
  .auto_close = TRUE,
  .envir = parent.frame(),
  .auto_result = c("clear", "done", "failed", "auto")
)
```

## Arguments

- msg:

  The text to show, a character vector. It will be collapsed into a
  single string, and the first line is kept and cut to
  [`console_width()`](https://cli.r-lib.org/reference/console_width.md).
  The message is often associated with the start of a calculation.

- msg_done:

  The message to use when the message is cleared, when the calculation
  finishes successfully. If `.auto_close` is `TRUE` and `.auto_result`
  is `"done"`, then this is printed automatically when the calling
  function (or `.envir`) finishes.

- msg_failed:

  The message to use when the message is cleared, when the calculation
  finishes unsuccessfully. If `.auto_close` is `TRUE` and `.auto_result`
  is `"failed"`, then this is printed automatically when the calling
  function (or `.envir`) finishes.

- .keep:

  What to do when this status bar is cleared. If `TRUE` then the content
  of this status bar is kept, as regular cli output (the screen is
  scrolled up if needed). If `FALSE`, then this status bar is deleted.

- .auto_close:

  Whether to clear the status bar when the calling function finishes (or
  `.envir` is removed from the stack, if specified).

- .envir:

  Environment to evaluate the glue expressions in. It is also used to
  auto-clear the status bar if `.auto_close` is `TRUE`.

- .auto_result:

  What to do when auto-closing the status bar.

## Value

The id of the new status bar container element, invisibly.

## Details

Use
[`cli_status_clear()`](https://cli.r-lib.org/reference/cli_status_clear.md)
to clear the status bar.

Often status messages are associated with processes. E.g. the app starts
downloading a large file, so it sets the status bar accordingly. Once
the download is done (or has failed), the app typically updates the
status bar again. cli automates much of this, via the `msg_done`,
`msg_failed`, and `.auto_result` arguments. See examples below.

## See also

Status bars support [inline
markup](https://cli.r-lib.org/reference/inline-markup.md).

The
[`cli_progress_message()`](https://cli.r-lib.org/reference/cli_progress_message.md)
and
[`cli_progress_step()`](https://cli.r-lib.org/reference/cli_progress_step.md)
functions, for a superior API.

Other status bar:
[`cli_process_start()`](https://cli.r-lib.org/reference/cli_process_start.md),
[`cli_status_clear()`](https://cli.r-lib.org/reference/cli_status_clear.md),
[`cli_status_update()`](https://cli.r-lib.org/reference/cli_status_update.md)

Other functions supporting inline markup:
[`cli_abort()`](https://cli.r-lib.org/reference/cli_abort.md),
[`cli_alert()`](https://cli.r-lib.org/reference/cli_alert.md),
[`cli_blockquote()`](https://cli.r-lib.org/reference/cli_blockquote.md),
[`cli_bullets()`](https://cli.r-lib.org/reference/cli_bullets.md),
[`cli_bullets_raw()`](https://cli.r-lib.org/reference/cli_bullets_raw.md),
[`cli_dl()`](https://cli.r-lib.org/reference/cli_dl.md),
[`cli_h1()`](https://cli.r-lib.org/reference/cli_h1.md),
[`cli_li()`](https://cli.r-lib.org/reference/cli_li.md),
[`cli_ol()`](https://cli.r-lib.org/reference/cli_ol.md),
[`cli_process_start()`](https://cli.r-lib.org/reference/cli_process_start.md),
[`cli_progress_along()`](https://cli.r-lib.org/reference/cli_progress_along.md),
[`cli_progress_bar()`](https://cli.r-lib.org/reference/cli_progress_bar.md),
[`cli_progress_message()`](https://cli.r-lib.org/reference/cli_progress_message.md),
[`cli_progress_output()`](https://cli.r-lib.org/reference/cli_progress_output.md),
[`cli_progress_step()`](https://cli.r-lib.org/reference/cli_progress_step.md),
[`cli_rule`](https://cli.r-lib.org/reference/cli_rule.md),
[`cli_status_update()`](https://cli.r-lib.org/reference/cli_status_update.md),
[`cli_text()`](https://cli.r-lib.org/reference/cli_text.md),
[`cli_ul()`](https://cli.r-lib.org/reference/cli_ul.md),
[`format_error()`](https://cli.r-lib.org/reference/format_error.md),
[`format_inline()`](https://cli.r-lib.org/reference/format_inline.md)
