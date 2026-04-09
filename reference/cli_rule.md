# CLI horizontal rule

It can be used to separate parts of the output.

## Usage

``` r
cli_rule(
  left = "",
  center = "",
  right = "",
  id = NULL,
  .envir = parent.frame()
)
```

## Arguments

- left:

  Label to show on the left. It interferes with the `center` label, only
  at most one of them can be present.

- center:

  Label to show at the center. It interferes with the `left` and `right`
  labels.

- right:

  Label to show on the right. It interferes with the `center` label,
  only at most one of them can be present.

- id:

  Element id, a string. If `NULL`, then a new id is generated and
  returned.

- .envir:

  Environment to evaluate the glue expressions in.

## Details

### Inline styling and interpolation

    pkg <- "mypackage"
    cli_rule(left = "{.pkg {pkg}} results")

    #> ── mypackage results ─────────────────────────────────────────────────

### Theming

The line style of the rule can be changed via the the `line-type`
property. Possible values are:

- `"single"`: (same as `1`), a single line,

- `"double"`: (same as `2`), a double line,

- `"bar1"`, `"bar2"`, `"bar3"`, etc., `"bar8"` uses varying height bars.

Colors and background colors can similarly changed via a theme.

    d <- cli_div(theme = list(rule = list(
      color = "cyan",
      "line-type" = "double")))
    cli_rule("Summary", right = "{.pkg mypackage}")
    cli_end(d)

    #> ══ Summary ══════════════════════════════════════════════ mypackage ══

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
[`cli_status()`](https://cli.r-lib.org/reference/cli_status.md),
[`cli_status_update()`](https://cli.r-lib.org/reference/cli_status_update.md),
[`cli_text()`](https://cli.r-lib.org/reference/cli_text.md),
[`cli_ul()`](https://cli.r-lib.org/reference/cli_ul.md),
[`format_error()`](https://cli.r-lib.org/reference/format_error.md),
[`format_inline()`](https://cli.r-lib.org/reference/format_inline.md)
