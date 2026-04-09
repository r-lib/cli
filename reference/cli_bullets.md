# List of items

It is often useful to print out a list of items, tasks a function or
package performs, or a list of notes.

## Usage

``` r
cli_bullets(text, id = NULL, class = NULL, .envir = parent.frame())
```

## Arguments

- text:

  Character vector of items. See details below on how names are
  interpreted.

- id:

  Optional id of the `div.bullets` element, can be used in themes.

- class:

  Optional additional class(es) for the `div.bullets` element.

- .envir:

  Environment to evaluate the glue expressions in.

## Details

Items may be formatted differently, e.g. they can have a prefix symbol.
Formatting is specified by the names of `text`, and can be themed. cli
creates a `div` element of class `bullets` for the whole bullet list.
Each item is another `div` element of class `bullet-<name>`, where
`<name>` is the name of the entry in `text`. Entries in `text` without a
name create a `div` element of class `bullet-empty`, and if the name is
a single space character, the class is `bullet-space`.

The built-in theme defines the following item types:

- No name: Item without a prefix.

- ` `: Indented item.

- `*`: Item with a bullet.

- `>`: Item with an arrow or pointer.

- `v`: Item with a green "tick" symbol, like
  [`cli_alert_success()`](https://cli.r-lib.org/reference/cli_alert.md).

- `x`: Item with a ref cross, like
  [`cli_alert_danger()`](https://cli.r-lib.org/reference/cli_alert.md).

- `!`: Item with a yellow exclamation mark, like
  [`cli_alert_warning()`](https://cli.r-lib.org/reference/cli_alert.md).

- `i`: Info item, like
  [`cli_alert_info()`](https://cli.r-lib.org/reference/cli_alert.md).

You can define new item type by simply defining theming for the
corresponding `bullet-<name>` classes.

    cli_bullets(c(
            "noindent",
      " " = "indent",
      "*" = "bullet",
      ">" = "arrow",
      "v" = "success",
      "x" = "danger",
      "!" = "warning",
      "i" = "info"
    ))

    #> noindent
    #>   indent
    #> • bullet
    #> → arrow
    #> ✔ success
    #> ✖ danger
    #> ! warning
    #> ℹ info

## See also

This function supports [inline
markup](https://cli.r-lib.org/reference/inline-markup.md).

Other functions supporting inline markup:
[`cli_abort()`](https://cli.r-lib.org/reference/cli_abort.md),
[`cli_alert()`](https://cli.r-lib.org/reference/cli_alert.md),
[`cli_blockquote()`](https://cli.r-lib.org/reference/cli_blockquote.md),
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
