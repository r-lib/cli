# cli progress bars

This is the reference manual of the three functions that create, update
and terminate progress bars. For a tutorial see the [cli progress
bars](https://cli.r-lib.org/articles/progress.html).

`cli_progress_bar()` creates a new progress bar.

`cli_progress_update()` updates the state of a progress bar, and
potentially the display as well.

`cli_progress_done()` terminates a progress bar.

## Usage

``` r
cli_progress_bar(
  name = NULL,
  status = NULL,
  type = c("iterator", "tasks", "download", "custom"),
  total = NA,
  format = NULL,
  format_done = NULL,
  format_failed = NULL,
  clear = getOption("cli.progress_clear", TRUE),
  current = TRUE,
  auto_terminate = type != "download",
  extra = NULL,
  .auto_close = TRUE,
  .envir = parent.frame()
)

cli_progress_update(
  inc = NULL,
  set = NULL,
  total = NULL,
  status = NULL,
  extra = NULL,
  id = NULL,
  force = FALSE,
  .envir = parent.frame()
)

cli_progress_done(id = NULL, .envir = parent.frame(), result = "done")
```

## Arguments

- name:

  This is typically used as a label, and should be short, at most 20
  characters.

- status:

  New status string of the progress bar, if not `NULL`.

- type:

  Type of the progress bar. It is used to select a default display if
  `format` is not specified. Currently supported types:

  - `iterator`: e.g. a for loop or a mapping function,

  - `tasks`: a (typically small) number of tasks,

  - `download`: download of one file,

  - `custom`: custom type, `format` must not be `NULL` for this type.

- total:

  Total number of progress units, or `NA` if it is unknown.
  `cli_progress_update()` can update the total number of units. This is
  handy if you don't know the size of a download at the beginning, and
  also in some other cases. If `format` is set to `NULL`, `format` (plus
  `format_done` and `format_failed`) will be updated when you change
  `total` from `NA` to a number. I.e. default format strings will be
  updated, custom ones won't be.

- format:

  Format string. It has to be specified for custom progress bars,
  otherwise it is optional, and a default display is selected based on
  the progress bat type and whether the number of total units is known.
  Format strings may contain glue substitution, the support
  pluralization and cli styling. See
  [progress-variables](https://cli.r-lib.org/reference/progress-variables.md)
  for special variables that you can use in the custom format.

- format_done:

  Format string for successful termination. By default the same as
  `format`.

- format_failed:

  Format string for unsuccessful termination. By default the same as
  `format`.

- clear:

  Whether to remove the progress bar from the screen after it has
  terminated. Defaults to the `cli.progress_clear` option, or `TRUE` if
  unset.

- current:

  Whether to use this progress bar as the current progress bar of the
  calling function. See more at 'The current progress bar' below.

- auto_terminate:

  Whether to terminate the progress bar if the number of current units
  reaches the number of total units.

- extra:

  Extra data to add to the progress bar. This can be used in custom
  format strings for example. It should be a named list.
  `cli_progress_update()` can update the extra data. Often you can get
  away with referring to local variables in the format string, and then
  you don't need to use this argument. Explicitly including these
  constants or variables in `extra` can result in cleaner code. In the
  rare cases when you need to refer to the same progress bar from
  multiple functions, and you can them to `extra`.

- .auto_close:

  Whether to terminate the progress bar when the calling function (or
  the one with execution environment in `.envir` exits. (Auto
  termination does not work for progress bars created from the global
  environment, e.g. from a script.)

- .envir:

  The environment to use for auto-termination and for glue substitution.
  It is also used to find and set the current progress bar.

- inc:

  Increment in progress units. This is ignored if `set` is not `NULL`.

- set:

  Set the current number of progress units to this value. Ignored if
  `NULL`.

- id:

  Progress bar to update or terminate. If `NULL`, then the current
  progress bar of the calling function (or `.envir` if specified) is
  updated or terminated.

- force:

  Whether to force a display update, even if no update is due.

- result:

  String to select successful or unsuccessful termination. It is only
  used if the progress bar is not cleared from the screen. It can be one
  of `"done"`, `"failed"`, `"clear"`, and `"auto"`.

## Value

`cli_progress_bar()` returns the id of the new progress bar. The id is a
string constant.

`cli_progress_update()` returns the id of the progress bar, invisibly.

`cli_progress_done()` returns `TRUE`, invisibly, always.

## Details

### Basic usage

`cli_progress_bar()` creates a progress bar, `cli_progress_update()`
updates an existing progress bar, and `cli_progress_done()` terminates
it.

It is good practice to always set the `name` argument, to make the
progress bar more informative.

    clean <- function() {
      cli_progress_bar("Cleaning data", total = 100)
      for (i in 1:100) {
        Sys.sleep(5/100)
        cli_progress_update()
      }
      cli_progress_done()
    }
    clean()

![](figures/progress-1.svg)

### Progress bar types

There are three builtin types of progress bars, and a custom type.

    tasks <- function() {
      cli_progress_bar("Tasks", total = 3, type = "tasks")
      for (i in 1:3) {
        Sys.sleep(1)
        cli_progress_update()
      }
      cli_progress_done()
    }
    tasks()

![](figures/progress-tasks.svg)

### Unknown `total`

If `total` is not known, then cli shows a different progress bar. Note
that you can also set `total` in `cli_progress_update()`, if it not
known when the progress bar is created, but you learn it later.

    nototal <- function() {
      cli_progress_bar("Parameter tuning")
      for (i in 1:100) {
        Sys.sleep(3/100)
        cli_progress_update()
      }
      cli_progress_done()
    }
    nototal()

![](figures/progress-natotal.svg)

### Clearing the progress bar

By default cli removes terminated progress bars from the screen, if the
terminal supports this. If you want to change this, use the `clear`
argument of `cli_progress_bar()`, or the `cli.progress_clear` global
option (see [cli-config](https://cli.r-lib.org/reference/cli-config.md))
to change this.

(In the cli documentation we usually set `cli.progress_clear` to
`FALSE`, so users can see how finished progress bars look.)

In this example the first progress bar is cleared, the second is not.

    fun <- function() {
      cli_progress_bar("Data cleaning", total = 100, clear = TRUE)
      for (i in 1:100) {
        Sys.sleep(3/100)
        cli_progress_update()
      }
      cli_progress_bar("Parameter tuning", total = 100, clear = FALSE)
      for (i in 1:100) {
        Sys.sleep(3/100)
        cli_progress_update()
      }
    }
    fun()

![](figures/progress-clear.svg)

### Initial delay

Updating a progress bar on the screen is costly, so cli tries to avoid
it for quick loops. By default a progress bar is only shown after two
seconds, or after half of that if less than 50% of the iterations are
complete. You can change the two second default with the
`cli.progress_show_after` global option (see
[cli-config](https://cli.r-lib.org/reference/cli-config.md)).

(In the cli documentation we usually set `cli.progress_show_after` to
`0` (zero seconds), so progress bars are shown immediately.)

In this example we only show the progress bar after one second, because
more than 50% of the iterations remain after one second.

    fun <- function() {
      cli_alert("Starting now, at {Sys.time()}")
      cli_progress_bar(
        total = 100,
        format = "{cli::pb_bar} {pb_percent} @ {Sys.time()}"
      )
      for (i in 1:100) {
        Sys.sleep(4/100)
        cli_progress_update()
      }
    }
    options(cli.progress_show_after = 2)
    fun()

![](figures/progress-after.svg)

### The *current* progress bar

By default cli sets the new progress bar as the *current* progress bar
of the calling function. The current progress bar is the default one in
cli progress bar operations. E.g. if no progress bar id is supplied in
`cli_progress_update()`, then the current progress bar is updated.

Every function can only have a single *current* progress bar, and if a
new one is created, then the previous one (if any) is automatically
terminated. The current progress bar is also terminated when the
function that created it exits. Thanks to these rules, most often you
don't need to explicitly deal with progress bar ids, and you don't need
to explicitly call `cli_progress_done()`:

    fun <- function() {
      cli_progress_bar("First step ", total = 100)
      for (i in 1:100) {
        Sys.sleep(2/100)
        cli_progress_update()
      }
      cli_progress_bar("Second step", total = 100)
      for (i in 1:100) {
        Sys.sleep(2/100)
        cli_progress_update()
      }
    }
    fun()

![](figures/progress-current.svg)

### cli output while the progress bar is active

cli allows emitting regular cli output (alerts, headers, lists, etc.)
while a progress bar is active. On terminals that support this, cli will
remove the progress bar temporarily, emit the output, and then restores
the progress bar.

    fun <- function() {
      cli_alert_info("Before the progress bar")
      cli_progress_bar("Calculating", total = 100)
      for (i in 1:50) {
        Sys.sleep(4/100)
        cli_progress_update()
      }
      cli_alert_info("Already half way!")
      for (i in 1:50) {
        Sys.sleep(4/100)
        cli_progress_update()
      }
      cli_alert_info("All done")
    }
    fun()

![](figures/progress-output.svg)

See also
[`cli_progress_output()`](https://cli.r-lib.org/reference/cli_progress_output.md),
which sends text for the current progress handler. E.g. in a Shiny app
it will send the output to the Shiny progress bar, as opposed to the
[`cli_alert()`](https://cli.r-lib.org/reference/cli_alert.md) etc. cli
functions which will print the text to the console.

### Custom formats

In addition to the builtin types, you can also specify a custom format
string. In this case [progress
variables](https://cli.r-lib.org/reference/progress-variables.md) are
probably useful to avoid calculating some progress bar quantities like
the elapsed time, of the ETA manually. You can also use your own
variables in the calling function:

    fun <- function(urls) {
      cli_progress_bar(
        format = paste0(
          "{pb_spin} Downloading {.path {basename(url)}} ",
          "[{pb_current}/{pb_total}]   ETA:{pb_eta}"
        ),
        format_done = paste0(
          "{col_green(symbol$tick)} Downloaded {pb_total} files ",
          "in {pb_elapsed}."
        ),
        clear = FALSE,
        total = length(urls)
      )
      for (url in urls) {
        cli_progress_update()
        Sys.sleep(5/10)
      }
    }
    fun(paste0("https://acme.com/data-", 1:10, ".zip"))

![](figures/progress-format.svg)

## See also

These functions support [inline
markup](https://cli.r-lib.org/reference/inline-markup.md).

[`cli_progress_message()`](https://cli.r-lib.org/reference/cli_progress_message.md)
and
[`cli_progress_step()`](https://cli.r-lib.org/reference/cli_progress_step.md)
for simpler progress messages.

Other progress bar functions:
[`cli_progress_along()`](https://cli.r-lib.org/reference/cli_progress_along.md),
[`cli_progress_builtin_handlers()`](https://cli.r-lib.org/reference/cli_progress_builtin_handlers.md),
[`cli_progress_message()`](https://cli.r-lib.org/reference/cli_progress_message.md),
[`cli_progress_num()`](https://cli.r-lib.org/reference/progress-utils.md),
[`cli_progress_output()`](https://cli.r-lib.org/reference/cli_progress_output.md),
[`cli_progress_step()`](https://cli.r-lib.org/reference/cli_progress_step.md),
[`cli_progress_styles()`](https://cli.r-lib.org/reference/cli_progress_styles.md),
[`progress-variables`](https://cli.r-lib.org/reference/progress-variables.md)

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
