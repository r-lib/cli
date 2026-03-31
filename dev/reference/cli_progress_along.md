# Add a progress bar to a mapping function or for loop

Note that this function is currently experimental!

Use `cli_progress_along()` in a mapping function or in a for loop, to
add a progress bar. It uses
[`cli_progress_bar()`](https://cli.r-lib.org/dev/reference/cli_progress_bar.md)
internally.

## Usage

``` r
cli_progress_along(
  x,
  name = NULL,
  total = length(x),
  ...,
  .envir = parent.frame()
)
```

## Arguments

- x:

  Sequence to add the progress bar to.

- name:

  Name of the progress bar, a label, passed to
  [`cli_progress_bar()`](https://cli.r-lib.org/dev/reference/cli_progress_bar.md).

- total:

  Passed to
  [`cli_progress_bar()`](https://cli.r-lib.org/dev/reference/cli_progress_bar.md).

- ...:

  Passed to
  [`cli_progress_bar()`](https://cli.r-lib.org/dev/reference/cli_progress_bar.md).

- .envir:

  Passed to
  [`cli_progress_bar()`](https://cli.r-lib.org/dev/reference/cli_progress_bar.md).

## Value

An index vector from 1 to `length(x)` that triggers progress updates as
you iterate over it.

## Details

### `for` loop

A `for` loop with `cli_progress_along()` looks like this:

    for (i in cli_progress_along(seq)) {
      ...
    }

A complete example:

    clifun <- function() {
      for (i in cli_progress_along(1:100, "Downloading")) {
         Sys.sleep(4/100)
      }
    }
    clifun()

![](figures/progress-along-1.svg)

### [`lapply()`](https://rdrr.io/r/base/lapply.html) and other mapping functions

They will look like this:

    lapply(cli_progress_along(X), function(i) ...)

A complete example:

    res <- lapply(cli_progress_along(1:100, "Downloading"), function(i) {
      Sys.sleep(4/100)
    })

![](figures/progress-along-2.svg)

### Custom format string

    clifun <- function() {
      for (i in cli_progress_along(1:100,
          format = "Downloading data file {cli::pb_current}")) {
         Sys.sleep(4/100)
      }
    }
    clifun()

![](figures/progress-along-3.svg)

### Breaking out of loops

Note that if you use [`break`](https://rdrr.io/r/base/Control.html) in
the `for` loop, you probably want to terminate the progress bar
explicitly when breaking out of the loop, or right after the loop:

    for (i in cli_progress_along(seq)) {
      ...
      if (cond) cli_progress_done() && break
      ...
    }

## See also

This function supports [inline
markup](https://cli.r-lib.org/dev/reference/inline-markup.md).

[`cli_progress_bar()`](https://cli.r-lib.org/dev/reference/cli_progress_bar.md)
and the traditional progress bar API.

Other progress bar functions:
[`cli_progress_bar()`](https://cli.r-lib.org/dev/reference/cli_progress_bar.md),
[`cli_progress_builtin_handlers()`](https://cli.r-lib.org/dev/reference/cli_progress_builtin_handlers.md),
[`cli_progress_message()`](https://cli.r-lib.org/dev/reference/cli_progress_message.md),
[`cli_progress_num()`](https://cli.r-lib.org/dev/reference/progress-utils.md),
[`cli_progress_output()`](https://cli.r-lib.org/dev/reference/cli_progress_output.md),
[`cli_progress_step()`](https://cli.r-lib.org/dev/reference/cli_progress_step.md),
[`cli_progress_styles()`](https://cli.r-lib.org/dev/reference/cli_progress_styles.md),
[`progress-variables`](https://cli.r-lib.org/dev/reference/progress-variables.md)

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
