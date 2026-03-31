# Format an error, warning or diagnostic message

You can then throw this message with
[`stop()`](https://rdrr.io/r/base/stop.html) or
[`rlang::abort()`](https://rlang.r-lib.org/reference/abort.html).

## Usage

``` r
format_error(message, .envir = parent.frame())

format_warning(message, .envir = parent.frame())

format_message(message, .envir = parent.frame())
```

## Arguments

- message:

  It is formatted via a call to
  [`cli_bullets()`](https://cli.r-lib.org/dev/reference/cli_bullets.md).

- .envir:

  Environment to evaluate the glue expressions in.

## Details

The messages can use inline styling, pluralization and glue
substitutions.

    n <- "boo"
    stop(format_error(c(
            "{.var n} must be a numeric vector",
      "x" = "You've supplied a {.cls {class(n)}} vector."
    )))

    #> Error: `n` must be a numeric vector
    #> ✖ You've supplied a <character> vector.

    len <- 26
    idx <- 100
    stop(format_error(c(
            "Must index an existing element:",
      "i" = "There {?is/are} {len} element{?s}.",
      "x" = "You've tried to subset element {idx}."
    )))

    #> Error: Must index an existing element:
    #> ℹ There are 26 elements.
    #> ✖ You've tried to subset element 100.

## See also

These functions support [inline
markup](https://cli.r-lib.org/dev/reference/inline-markup.md).

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
[`cli_status_update()`](https://cli.r-lib.org/dev/reference/cli_status_update.md),
[`cli_text()`](https://cli.r-lib.org/dev/reference/cli_text.md),
[`cli_ul()`](https://cli.r-lib.org/dev/reference/cli_ul.md),
[`format_inline()`](https://cli.r-lib.org/dev/reference/format_inline.md)
