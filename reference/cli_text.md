# CLI text

Write some text to the screen. This function is most appropriate for
longer paragraphs. See
[`cli_alert()`](https://cli.r-lib.org/reference/cli_alert.md) for
shorter status messages.

## Usage

``` r
cli_text(..., .envir = parent.frame())
```

## Arguments

- ...:

  The text to show, in character vectors. They will be concatenated into
  a single string. Newlines are *not* preserved.

- .envir:

  Environment to evaluate the glue expressions in.

## Details

### Text wrapping

Text is wrapped to the console width, see
[`console_width()`](https://cli.r-lib.org/reference/console_width.md).

    cli_text(cli:::lorem_ipsum())

    #> Lorem ad ipsum veniam esse nisi deserunt duis. Qui incididunt elit
    #> elit mollit sint nulla consectetur aute commodo do elit laboris minim
    #> et. Laboris ipsum mollit voluptate et non do incididunt eiusmod. Anim
    #> consectetur mollit laborum occaecat eiusmod excepteur. Ullamco non
    #> tempor esse anim tempor magna non.

### New lines

A `cli_text()` call always appends a newline character to the end.

    cli_text("First line.")
    cli_text("Second line.")

    #> First line.
    #> Second line.

### Styling

You can use [inline
markup](https://cli.r-lib.org/reference/inline-markup.md), as usual.

    cli_text("The {.fn cli_text} function in the {.pkg cli} package.")

    #> The `cli_text()` function in the cli package.

### Interpolation

String interpolation via glue works as usual. Interpolated vectors are
collapsed.

    pos <- c(5, 14, 25, 26)
    cli_text("We have {length(pos)} missing measurements: {pos}.")

    #> We have 4 missing measurements: 5, 14, 25, and 26.

### Styling and interpolation

Use double braces to combine styling and string interpolation.

    fun <- "cli-text"
    pkg <- "cli"
    cli_text("The {.fn {fun}} function in the {.pkg {pkg}} package.")

    #> The `cli-text()` function in the cli package.

### Multiple arguments

Arguments are concatenated.

    cli_text(c("This ", "will ", "all "), "be ", "one ", "sentence.")

    #> This will all be one sentence.

### Containers

You can use `cli_text()` within cli
[containers](https://cli.r-lib.org/reference/containers.md).

    ul <- cli_ul()
    cli_li("First item.")
    cli_text("Still the {.emph first} item")
    cli_li("Second item.")
    cli_text("Still the {.emph second} item")
    cli_end(ul)

    #> • First item.
    #> Still the first item
    #> • Second item.
    #> Still the second item

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
[`cli_ul()`](https://cli.r-lib.org/reference/cli_ul.md),
[`format_error()`](https://cli.r-lib.org/reference/format_error.md),
[`format_inline()`](https://cli.r-lib.org/reference/format_inline.md)
