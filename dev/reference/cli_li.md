# CLI list item(s)

A list item is a container, see
[containers](https://cli.r-lib.org/dev/reference/containers.md).

## Usage

``` r
cli_li(
  items = NULL,
  labels = names(items),
  id = NULL,
  class = NULL,
  .auto_close = TRUE,
  .envir = parent.frame()
)
```

## Arguments

- items:

  Character vector of items, or `NULL`.

- labels:

  For definition lists the item labels.

- id:

  Id of the new container. Can be used for closing it with
  [`cli_end()`](https://cli.r-lib.org/dev/reference/cli_end.md) or in
  themes. If `NULL`, then an id is generated and returned invisibly.

- class:

  Class of the item container. Can be used in themes.

- .auto_close:

  Whether to close the container, when the calling function finishes (or
  `.envir` is removed, if specified).

- .envir:

  Environment to evaluate the glue expressions in. It is also used to
  auto-close the container if `.auto_close` is `TRUE`.

## Value

The id of the new container element, invisibly.

## Details

### Nested lists

    fun <- function() {
      ul <- cli_ul()
      cli_li("one:")
      cli_ol(letters[1:3])
      cli_li("two:")
      cli_li("three")
      cli_end(ul)
    }
    fun()

    #> • one:
    #>   1. a
    #>   2. b
    #>   3. c
    #> • two:
    #> • three

## See also

This function supports [inline
markup](https://cli.r-lib.org/dev/reference/inline-markup.md).

Other functions supporting inline markup:
[`cli_abort()`](https://cli.r-lib.org/dev/reference/cli_abort.md),
[`cli_alert()`](https://cli.r-lib.org/dev/reference/cli_alert.md),
[`cli_blockquote()`](https://cli.r-lib.org/dev/reference/cli_blockquote.md),
[`cli_bullets()`](https://cli.r-lib.org/dev/reference/cli_bullets.md),
[`cli_bullets_raw()`](https://cli.r-lib.org/dev/reference/cli_bullets_raw.md),
[`cli_dl()`](https://cli.r-lib.org/dev/reference/cli_dl.md),
[`cli_h1()`](https://cli.r-lib.org/dev/reference/cli_h1.md),
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
