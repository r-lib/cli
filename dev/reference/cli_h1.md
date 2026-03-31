# CLI headings

cli has three levels of headings.

## Usage

``` r
cli_h1(text, id = NULL, class = NULL, .envir = parent.frame())

cli_h2(text, id = NULL, class = NULL, .envir = parent.frame())

cli_h3(text, id = NULL, class = NULL, .envir = parent.frame())
```

## Arguments

- text:

  Text of the heading. It can contain inline markup.

- id:

  Id of the heading element, string. It can be used in themes.

- class:

  Class of the heading element, string. It can be used in themes.

- .envir:

  Environment to evaluate the glue expressions in.

## Details

This is how the headings look with the default builtin theme.

    cli_h1("Header {.emph 1}")
    cli_h2("Header {.emph 2}")
    cli_h3("Header {.emph 3}")

    #>
    #> ── Header 1 ──────────────────────────────────────────────────────────
    #>
    #> ── Header 2 ──
    #>
    #> ── Header 3

## See also

These functions supports [inline
markup](https://cli.r-lib.org/dev/reference/inline-markup.md).

Other functions supporting inline markup:
[`cli_abort()`](https://cli.r-lib.org/dev/reference/cli_abort.md),
[`cli_alert()`](https://cli.r-lib.org/dev/reference/cli_alert.md),
[`cli_blockquote()`](https://cli.r-lib.org/dev/reference/cli_blockquote.md),
[`cli_bullets()`](https://cli.r-lib.org/dev/reference/cli_bullets.md),
[`cli_bullets_raw()`](https://cli.r-lib.org/dev/reference/cli_bullets_raw.md),
[`cli_dl()`](https://cli.r-lib.org/dev/reference/cli_dl.md),
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
