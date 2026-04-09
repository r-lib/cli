# Format and returns a line of text

You can use this function to format a line of cli text, without emitting
it to the screen. It uses
[`cli_text()`](https://cli.r-lib.org/reference/cli_text.md) internally.

## Usage

``` r
format_inline(
  ...,
  .envir = parent.frame(),
  collapse = TRUE,
  keep_whitespace = TRUE
)
```

## Arguments

- ...:

  Passed to [`cli_text()`](https://cli.r-lib.org/reference/cli_text.md).

- .envir:

  Environment to evaluate the expressions in.

- collapse:

  Whether to collapse the result if it has multiple lines, e.g. because
  of `\f` characters.

- keep_whitespace:

  Whether to keep all whitepace (spaces, newlines and form feeds) as is
  in the input.

## Value

Character scalar, the formatted string.

## Details

`format_inline()` performs no width-wrapping.

## See also

This function supports [inline
markup](https://cli.r-lib.org/reference/inline-markup.md).

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
[`cli_status()`](https://cli.r-lib.org/reference/cli_status.md),
[`cli_status_update()`](https://cli.r-lib.org/reference/cli_status_update.md),
[`cli_text()`](https://cli.r-lib.org/reference/cli_text.md),
[`cli_ul()`](https://cli.r-lib.org/reference/cli_ul.md),
[`format_error()`](https://cli.r-lib.org/reference/format_error.md)

## Examples

``` r
format_inline("A message for {.emph later}, thanks {.fn format_inline}.")
#> [1] "A message for \033[3mlater\033[23m, thanks `format_inline()`."
```
