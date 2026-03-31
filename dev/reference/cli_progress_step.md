# Simplified cli progress messages, with styling

This is a simplified progress bar, a single (dynamic) message, without
progress units.

## Usage

``` r
cli_progress_step(
  msg,
  msg_done = msg,
  msg_failed = msg,
  spinner = FALSE,
  class = if (!spinner) ".alert-info",
  current = TRUE,
  .auto_close = TRUE,
  .envir = parent.frame(),
  ...
)
```

## Arguments

- msg:

  Message to show. It may contain glue substitution and cli styling. It
  can be updated via
  [`cli_progress_update()`](https://cli.r-lib.org/dev/reference/cli_progress_bar.md),
  as usual. It is style as a cli info alert (see
  [`cli_alert_info()`](https://cli.r-lib.org/dev/reference/cli_alert.md)).

- msg_done:

  Message to show on successful termination. By default this it is the
  same as `msg` and it is styled as a cli success alert (see
  [`cli_alert_success()`](https://cli.r-lib.org/dev/reference/cli_alert.md)).

- msg_failed:

  Message to show on unsuccessful termination. By default it is the same
  as `msg` and it is styled as a cli danger alert (see
  [`cli_alert_danger()`](https://cli.r-lib.org/dev/reference/cli_alert.md)).

- spinner:

  Whether to show a spinner at the beginning of the line. To make the
  spinner spin, you'll need to call
  [`cli_progress_update()`](https://cli.r-lib.org/dev/reference/cli_progress_bar.md)
  regularly.

- class:

  cli class to add to the message. By default there is no class for
  steps with a spinner.

- current:

  Passed to
  [`cli_progress_bar()`](https://cli.r-lib.org/dev/reference/cli_progress_bar.md).

- .auto_close:

  Passed to
  [`cli_progress_bar()`](https://cli.r-lib.org/dev/reference/cli_progress_bar.md).

- .envir:

  Passed to
  [`cli_progress_bar()`](https://cli.r-lib.org/dev/reference/cli_progress_bar.md).

- ...:

  Passed to
  [`cli_progress_bar()`](https://cli.r-lib.org/dev/reference/cli_progress_bar.md).

## Details

`cli_progress_step()` always shows the progress message, even if no
update is due.

### Basic use

    f <- function() {
      cli_progress_step("Downloading data")
      Sys.sleep(2)
      cli_progress_step("Importing data")
      Sys.sleep(1)
      cli_progress_step("Cleaning data")
      Sys.sleep(2)
      cli_progress_step("Fitting model")
      Sys.sleep(3)
    }
    f()

![](figures/progress-step.svg)

### Spinner

You can add a spinner to some or all steps with `spinner = TRUE`, but
note that this will only work if you call
[`cli_progress_update()`](https://cli.r-lib.org/dev/reference/cli_progress_bar.md)
regularly.

    f <- function() {
      cli_progress_step("Downloading data", spinner = TRUE)
      for (i in 1:100) { Sys.sleep(2/100); cli_progress_update() }
      cli_progress_step("Importing data")
      Sys.sleep(1)
      cli_progress_step("Cleaning data")
      Sys.sleep(2)
      cli_progress_step("Fitting model", spinner = TRUE)
      for (i in 1:100) { Sys.sleep(3/100); cli_progress_update() }
    }
    f()

![](figures/progress-step-spin.svg)

### Dynamic messages

You can make the step messages dynamic, using glue templates. Since
`cli_progress_step()` show that message immediately, we need to
initialize `msg` first.

    f <- function() {
      msg <- ""
      cli_progress_step("Downloading data{msg}", spinner = TRUE)
      for (i in 1:100) {
        Sys.sleep(2/100)
        msg <- glue::glue(", got file {i}/100")
        cli_progress_update()
      }
      cli_progress_step("Importing data")
      Sys.sleep(1)
      cli_progress_step("Cleaning data")
      Sys.sleep(2)
      cli_progress_step("Fitting model", spinner = TRUE)
      for (i in 1:100) { Sys.sleep(3/100); cli_progress_update() }
    }
    f()

![](figures/progress-step-dynamic.svg)

### Termination messages

You can specify a different message for successful and/or unsuccessful
termination:

    f <- function() {
      size <- 0L
      cli_progress_step(
        "Downloading data.",
        msg_done = "Downloaded {prettyunits::pretty_bytes(size)}.",
        spinner = TRUE
      )
      for (i in 1:100) {
        Sys.sleep(3/100)
        size <- size + 8192
        cli_progress_update()
      }
    }
    f()

![](figures/progress-step-msg.svg)

## See also

This function supports [inline
markup](https://cli.r-lib.org/dev/reference/inline-markup.md).

Other progress bar functions:
[`cli_progress_along()`](https://cli.r-lib.org/dev/reference/cli_progress_along.md),
[`cli_progress_bar()`](https://cli.r-lib.org/dev/reference/cli_progress_bar.md),
[`cli_progress_builtin_handlers()`](https://cli.r-lib.org/dev/reference/cli_progress_builtin_handlers.md),
[`cli_progress_message()`](https://cli.r-lib.org/dev/reference/cli_progress_message.md),
[`cli_progress_num()`](https://cli.r-lib.org/dev/reference/progress-utils.md),
[`cli_progress_output()`](https://cli.r-lib.org/dev/reference/cli_progress_output.md),
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
[`cli_progress_along()`](https://cli.r-lib.org/dev/reference/cli_progress_along.md),
[`cli_progress_bar()`](https://cli.r-lib.org/dev/reference/cli_progress_bar.md),
[`cli_progress_message()`](https://cli.r-lib.org/dev/reference/cli_progress_message.md),
[`cli_progress_output()`](https://cli.r-lib.org/dev/reference/cli_progress_output.md),
[`cli_rule`](https://cli.r-lib.org/dev/reference/cli_rule.md),
[`cli_status()`](https://cli.r-lib.org/dev/reference/cli_status.md),
[`cli_status_update()`](https://cli.r-lib.org/dev/reference/cli_status_update.md),
[`cli_text()`](https://cli.r-lib.org/dev/reference/cli_text.md),
[`cli_ul()`](https://cli.r-lib.org/dev/reference/cli_ul.md),
[`format_error()`](https://cli.r-lib.org/dev/reference/format_error.md),
[`format_inline()`](https://cli.r-lib.org/dev/reference/format_inline.md)
