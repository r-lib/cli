# Signal an error, warning or message with a cli formatted message

These functions let you create error, warning or diagnostic messages
with cli formatting, including inline styling, pluralization and glue
substitutions.

## Usage

``` r
cli_abort(
  message,
  ...,
  call = .envir,
  .envir = parent.frame(),
  .frame = .envir
)

cli_warn(message, ..., .envir = parent.frame())

cli_inform(message, ..., .envir = parent.frame())
```

## Arguments

- message:

  It is formatted via a call to
  [`cli_bullets()`](https://cli.r-lib.org/reference/cli_bullets.md).

- ...:

  Passed to
  [`rlang::abort()`](https://rlang.r-lib.org/reference/abort.html),
  [`rlang::warn()`](https://rlang.r-lib.org/reference/abort.html) or
  [`rlang::inform()`](https://rlang.r-lib.org/reference/abort.html).

- call:

  The execution environment of a currently running function, e.g.
  `call = caller_env()`. The corresponding function call is retrieved
  and mentioned in error messages as the source of the error.

  You only need to supply `call` when throwing a condition from a helper
  function which wouldn't be relevant to mention in the message.

  Can also be `NULL` or a [defused function
  call](https://rlang.r-lib.org/reference/topic-defuse.html) to
  respectively not display any call or hard-code a code to display.

  For more information about error calls, see [Including function calls
  in error
  messages](https://rlang.r-lib.org/reference/topic-error-call.html).

- .envir:

  Environment to evaluate the glue expressions in.

- .frame:

  The throwing context. Used as default for `.trace_bottom`, and to
  determine the internal package to mention in internal errors when
  `.internal` is `TRUE`.

## Details

    n <- "boo"
    cli_abort(c(
            "{.var n} must be a numeric vector",
      "x" = "You've supplied a {.cls {class(n)}} vector."
    ))

    #> Error:
    #> ! `n` must be a numeric vector
    #> ✖ You've supplied a <character> vector.
    #> Run `rlang::last_trace()` to see where the error occurred.

    len <- 26
    idx <- 100
    cli_abort(c(
            "Must index an existing element:",
      "i" = "There {?is/are} {len} element{?s}.",
      "x" = "You've tried to subset element {idx}."
    ))

    #> Error:
    #> ! Must index an existing element:
    #> ℹ There are 26 elements.
    #> ✖ You've tried to subset element 100.
    #> Run `rlang::last_trace()` to see where the error occurred.

## See also

These functions support [inline
markup](https://cli.r-lib.org/reference/inline-markup.md).

Other functions supporting inline markup:
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
[`format_error()`](https://cli.r-lib.org/reference/format_error.md),
[`format_inline()`](https://cli.r-lib.org/reference/format_inline.md)
