# CLI block quote

A section that is quoted from another source. It is typically indented.

## Usage

``` r
cli_blockquote(
  quote,
  citation = NULL,
  id = NULL,
  class = NULL,
  .envir = parent.frame()
)
```

## Arguments

- quote:

  Text of the quotation.

- citation:

  Source of the quotation, typically a link or the name of a person.

- id:

  Element id, a string. If `NULL`, then a new id is generated and
  returned.

- class:

  Class name, sting. Can be used in themes.

- .envir:

  Environment to evaluate the glue expressions in. It is also used to
  auto-close the container if `.auto_close` is `TRUE`.

## Details

    evil <- paste(
      "The real problem is that programmers have spent far too much time",
      "worrying about efficiency in the wrong places and at the wrong",
      "times; premature optimization is the root of all evil (or at least",
      "most of it) in programming.")
    cli_blockquote(evil, citation = "Donald Ervin Knuth")

    #>
    #>     “The real problem is that programmers have spent far
    #>     too much time worrying about efficiency in the wrong
    #>     places and at the wrong times; premature optimization
    #>     is the root of all evil (or at least most of it) in
    #>     programming.”
    #>     — Donald Ervin Knuth
    #>

## See also

This function supports [inline
markup](https://cli.r-lib.org/dev/reference/inline-markup.md).

Other functions supporting inline markup:
[`cli_abort()`](https://cli.r-lib.org/dev/reference/cli_abort.md),
[`cli_alert()`](https://cli.r-lib.org/dev/reference/cli_alert.md),
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
[`format_error()`](https://cli.r-lib.org/dev/reference/format_error.md),
[`format_inline()`](https://cli.r-lib.org/dev/reference/format_inline.md)
