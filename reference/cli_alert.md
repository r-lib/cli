# CLI alerts

Alerts are typically short status messages.

## Usage

``` r
cli_alert(text, id = NULL, class = NULL, wrap = FALSE, .envir = parent.frame())

cli_alert_success(
  text,
  id = NULL,
  class = NULL,
  wrap = FALSE,
  .envir = parent.frame()
)

cli_alert_danger(
  text,
  id = NULL,
  class = NULL,
  wrap = FALSE,
  .envir = parent.frame()
)

cli_alert_warning(
  text,
  id = NULL,
  class = NULL,
  wrap = FALSE,
  .envir = parent.frame()
)

cli_alert_info(
  text,
  id = NULL,
  class = NULL,
  wrap = FALSE,
  .envir = parent.frame()
)
```

## Arguments

- text:

  Text of the alert.

- id:

  Id of the alert element. Can be used in themes.

- class:

  Class of the alert element. Can be used in themes.

- wrap:

  Whether to auto-wrap the text of the alert.

- .envir:

  Environment to evaluate the glue expressions in.

## Details

### Success

    nbld <- 11
    tbld <- prettyunits::pretty_sec(5.6)
    cli_alert_success("Built {.emph {nbld}} status report{?s} in {tbld}.")

    #> ✔ Built 11 status reports in 5.6s.

### Info

    cfl <- "~/.cache/files/latest.cache"
    cli_alert_info("Updating cache file {.path {cfl}}.")

    #> ℹ Updating cache file ~/.cache/files/latest.cache.

### Warning

    cfl <- "~/.cache/files/latest.cache"
    cli_alert_warning("Failed to update cache file {.path {cfl}}.")

    #> ! Failed to update cache file ~/.cache/files/latest.cache.

### Danger

    cfl <- "~/.config/report.yaml"
    cli_alert_danger("Cannot validate config file at {.path {cfl}}.")

    #> ✖ Cannot validate config file at ~/.config/report.yaml.

### Text wrapping

Alerts are printed without wrapping, unless you set `wrap = TRUE`:

    cli_alert_info("Data columns: {.val {names(mtcars)}}.")
    cli_alert_info("Data columns: {.val {names(mtcars)}}.", wrap = TRUE)

    #> ℹ Data columns: "mpg", "cyl", "disp", "hp", "drat", "wt", "qsec", "vs", "am", "g
    #> ear", and "carb".
    #> ℹ Data columns: "mpg", "cyl", "disp", "hp", "drat", "wt", "qsec",
    #> "vs", "am", "gear", and "carb".

## See also

These functions supports [inline
markup](https://cli.r-lib.org/reference/inline-markup.md).

Other functions supporting inline markup:
[`cli_abort()`](https://cli.r-lib.org/reference/cli_abort.md),
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
