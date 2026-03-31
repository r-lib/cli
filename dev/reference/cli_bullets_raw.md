# List of verbatim items

`cli_format_bullets_raw()` is similar to
[`cli_bullets()`](https://cli.r-lib.org/dev/reference/cli_bullets.md),
but it does not perform any inline styling or glue substitutions in the
input.

## Usage

``` r
cli_bullets_raw(text, id = NULL, class = NULL)

format_bullets_raw(text, id = NULL, class = NULL)
```

## Arguments

- text:

  Character vector of items. See details below on how names are
  interpreted.

- id:

  Optional id of the `div.bullets` element, can be used in themes.

- class:

  Optional additional class(es) for the `div.bullets` element.

## Details

`format_bullets_raw()` returns the output instead of printing it.

## See also

These functions support [inline
markup](https://cli.r-lib.org/dev/reference/inline-markup.md).

See
[`cli_bullets()`](https://cli.r-lib.org/dev/reference/cli_bullets.md)
for examples.

Other functions supporting inline markup:
[`cli_abort()`](https://cli.r-lib.org/dev/reference/cli_abort.md),
[`cli_alert()`](https://cli.r-lib.org/dev/reference/cli_alert.md),
[`cli_blockquote()`](https://cli.r-lib.org/dev/reference/cli_blockquote.md),
[`cli_bullets()`](https://cli.r-lib.org/dev/reference/cli_bullets.md),
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
[`cli_status_update()`](https://cli.r-lib.org/dev/reference/cli_status_update.md),
[`cli_text()`](https://cli.r-lib.org/dev/reference/cli_text.md),
[`cli_ul()`](https://cli.r-lib.org/dev/reference/cli_ul.md),
[`format_error()`](https://cli.r-lib.org/dev/reference/format_error.md),
[`format_inline()`](https://cli.r-lib.org/dev/reference/format_inline.md)
