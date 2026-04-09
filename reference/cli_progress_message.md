# Simplified cli progress messages

This is a simplified progress bar, a single (dynamic) message, without
progress units.

## Usage

``` r
cli_progress_message(
  msg,
  current = TRUE,
  .auto_close = TRUE,
  .envir = parent.frame(),
  ...
)
```

## Arguments

- msg:

  Message to show. It may contain glue substitution and cli styling. It
  can be updated via
  [`cli_progress_update()`](https://cli.r-lib.org/reference/cli_progress_bar.md),
  as usual.

- current:

  Passed to
  [`cli_progress_bar()`](https://cli.r-lib.org/reference/cli_progress_bar.md).

- .auto_close:

  Passed to
  [`cli_progress_bar()`](https://cli.r-lib.org/reference/cli_progress_bar.md).

- .envir:

  Passed to
  [`cli_progress_bar()`](https://cli.r-lib.org/reference/cli_progress_bar.md).

- ...:

  Passed to
  [`cli_progress_bar()`](https://cli.r-lib.org/reference/cli_progress_bar.md).

## Value

The id of the new progress bar.

## Details

`cli_progress_message()` always shows the message, even if no update is
due. When the progress message is terminated, it is removed from the
screen by default.

Note that the message can be dynamic: if you update it with
[`cli_progress_update()`](https://cli.r-lib.org/reference/cli_progress_bar.md),
then cli uses the current values in the string substitutions.

    fun <- function() {
      cli_progress_message("Task one is running...")
      Sys.sleep(2)

      cli_progress_message("Task two is running...")
      Sys.sleep(2)

      step <- 1L
      cli_progress_message("Task three is underway: step {step}")
      for (step in 1:5) {
        Sys.sleep(0.5)
        cli_progress_update()
      }
    }
    fun()

![](figures/progress-message.svg)

## See also

This function supports [inline
markup](https://cli.r-lib.org/reference/inline-markup.md).

[`cli_progress_bar()`](https://cli.r-lib.org/reference/cli_progress_bar.md)
for the complete progress bar API.
[`cli_progress_step()`](https://cli.r-lib.org/reference/cli_progress_step.md)
for a similar display that is styled by default.

Other progress bar functions:
[`cli_progress_along()`](https://cli.r-lib.org/reference/cli_progress_along.md),
[`cli_progress_bar()`](https://cli.r-lib.org/reference/cli_progress_bar.md),
[`cli_progress_builtin_handlers()`](https://cli.r-lib.org/reference/cli_progress_builtin_handlers.md),
[`cli_progress_num()`](https://cli.r-lib.org/reference/progress-utils.md),
[`cli_progress_output()`](https://cli.r-lib.org/reference/cli_progress_output.md),
[`cli_progress_step()`](https://cli.r-lib.org/reference/cli_progress_step.md),
[`cli_progress_styles()`](https://cli.r-lib.org/reference/cli_progress_styles.md),
[`progress-variables`](https://cli.r-lib.org/reference/progress-variables.md)

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
[`cli_progress_output()`](https://cli.r-lib.org/reference/cli_progress_output.md),
[`cli_progress_step()`](https://cli.r-lib.org/reference/cli_progress_step.md),
[`cli_rule`](https://cli.r-lib.org/reference/cli_rule.md),
[`cli_status()`](https://cli.r-lib.org/reference/cli_status.md),
[`cli_status_update()`](https://cli.r-lib.org/reference/cli_status_update.md),
[`cli_text()`](https://cli.r-lib.org/reference/cli_text.md),
[`cli_ul()`](https://cli.r-lib.org/reference/cli_ul.md),
[`format_error()`](https://cli.r-lib.org/reference/format_error.md),
[`format_inline()`](https://cli.r-lib.org/reference/format_inline.md)
