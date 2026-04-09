# Definition list

A definition list is a container, see
[containers](https://cli.r-lib.org/reference/containers.md).

## Usage

``` r
cli_dl(
  items = NULL,
  labels = names(items),
  id = NULL,
  class = NULL,
  .close = TRUE,
  .auto_close = TRUE,
  .envir = parent.frame()
)
```

## Arguments

- items:

  Named character vector, or `NULL`. If not `NULL`, they are used as
  list items.

- labels:

  Item labels. Defaults the names in `items`.

- id:

  Id of the list container. Can be used for closing it with
  [`cli_end()`](https://cli.r-lib.org/reference/cli_end.md) or in
  themes. If `NULL`, then an id is generated and returned invisibly.

- class:

  Class of the list container. Can be used in themes.

- .close:

  Whether to close the list container if the `items` were specified. If
  `FALSE` then new items can be added to the list.

- .auto_close:

  Whether to close the container, when the calling function finishes (or
  `.envir` is removed, if specified).

- .envir:

  Environment to evaluate the glue expressions in. It is also used to
  auto-close the container if `.auto_close` is `TRUE`.

## Value

The id of the new container element, invisibly.

## Details

### All items at once

    fun <- function() {
      cli_dl(c(foo = "one", bar = "two", baz = "three"))
    }
    fun()

    #> foo: one
    #> bar: two
    #> baz: three

### Items one by one

    fun <- function() {
      cli_dl()
      cli_li(c(foo = "{.emph one}"))
      cli_li(c(bar = "two"))
      cli_li(c(baz = "three"))
    }
    fun()

    #> foo: one
    #> bar: two
    #> baz: three

## See also

This function supports [inline
markup](https://cli.r-lib.org/reference/inline-markup.md).

Other functions supporting inline markup:
[`cli_abort()`](https://cli.r-lib.org/reference/cli_abort.md),
[`cli_alert()`](https://cli.r-lib.org/reference/cli_alert.md),
[`cli_blockquote()`](https://cli.r-lib.org/reference/cli_blockquote.md),
[`cli_bullets()`](https://cli.r-lib.org/reference/cli_bullets.md),
[`cli_bullets_raw()`](https://cli.r-lib.org/reference/cli_bullets_raw.md),
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
