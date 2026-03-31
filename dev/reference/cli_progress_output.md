# Add text output to a progress bar

The text is calculated via
[`cli_text()`](https://cli.r-lib.org/dev/reference/cli_text.md), so all
cli features can be used here, including progress variables.

## Usage

``` r
cli_progress_output(text, id = NULL, .envir = parent.frame())
```

## Arguments

- text:

  Text to output. It is formatted via
  [`cli_text()`](https://cli.r-lib.org/dev/reference/cli_text.md).

- id:

  Progress bar id. The default is the current progress bar.

- .envir:

  Environment to use for glue interpolation of `text`.

## Value

`TRUE`, always.

## Details

The text is passed to the progress handler(s), that may or may not be
able to print it.

    fun <- function() {
      cli_alert_info("Before the progress bar")
      cli_progress_bar("Calculating", total = 100)
      for (i in 1:50) {
        Sys.sleep(4/100)
        cli_progress_update()
      }
      cli_progress_output("Already half way!")
      for (i in 1:50) {
        Sys.sleep(4/100)
        cli_progress_update()
      }
      cli_alert_info("All done")
    }
    fun()

![](figures/progress-output2.svg)

## See also

This function supports [inline
markup](https://cli.r-lib.org/dev/reference/inline-markup.md).

Other progress bar functions:
[`cli_progress_along()`](https://cli.r-lib.org/dev/reference/cli_progress_along.md),
[`cli_progress_bar()`](https://cli.r-lib.org/dev/reference/cli_progress_bar.md),
[`cli_progress_builtin_handlers()`](https://cli.r-lib.org/dev/reference/cli_progress_builtin_handlers.md),
[`cli_progress_message()`](https://cli.r-lib.org/dev/reference/cli_progress_message.md),
[`cli_progress_num()`](https://cli.r-lib.org/dev/reference/progress-utils.md),
[`cli_progress_step()`](https://cli.r-lib.org/dev/reference/cli_progress_step.md),
[`cli_progress_styles()`](https://cli.r-lib.org/dev/reference/cli_progress_styles.md),
[`progress-variables`](https://cli.r-lib.org/dev/reference/progress-variables.md)

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
[`cli_progress_step()`](https://cli.r-lib.org/dev/reference/cli_progress_step.md),
[`cli_rule`](https://cli.r-lib.org/dev/reference/cli_rule.md),
[`cli_status()`](https://cli.r-lib.org/dev/reference/cli_status.md),
[`cli_status_update()`](https://cli.r-lib.org/dev/reference/cli_status_update.md),
[`cli_text()`](https://cli.r-lib.org/dev/reference/cli_text.md),
[`cli_ul()`](https://cli.r-lib.org/dev/reference/cli_ul.md),
[`format_error()`](https://cli.r-lib.org/dev/reference/format_error.md),
[`format_inline()`](https://cli.r-lib.org/dev/reference/format_inline.md)
