# cli progress handlers

The progress handler(s) to use can be selected with global options.

## Usage

``` r
cli_progress_builtin_handlers()
```

## Value

`cli_progress_builtin_handlers()` returns the names of the currently
supported progress handlers.

## Details

There are three options that specify which handlers will be selected,
but most of the time you only need to use one of them. You can set these
options to a character vector, the names of the built-in cli handlers
you want to use:

- If `cli.progress_handlers_only` is set, then these handlers are used,
  without considering others and without checking if they are able to
  handle a progress bar. This option is mainly intended for testing
  purposes.

- The handlers named in `cli.progress_handlers` are checked if they are
  able to handle the progress bar, and from the ones that are, the first
  one is selected. This is usually the option that the end use would
  want to set.

- The handlers named in `cli.progress_handlers_force` are always
  appended to the ones selected via `cli.progress_handlers`. This option
  is useful to add an additional handler, e.g. a logger that writes to a
  file.

## The built-in progress handlers

### `cli`

Use cli's internal status bar, the last line of the screen, to show the
progress bar. This handler is always able to handle all progress bars.

### `logger`

Log progress updates to the screen, with one line for each update and
with time stamps. This handler is always able to handle all progress
bars.

### `progressr`

Use the progressr package to create progress bars. This handler is
always able to handle all progress bars. (The progressr package needs to
be installed.)

### `rstudio`

Use [RStudio's job panel](https://posit.co/blog/rstudio-1-2-jobs/) to
show the progress bars. This handler is available at the RStudio
console, in recent versions of RStudio.

### `say`

Use the macOS `say` command to announce progress events in speech (type
`man say` on a terminal for more info). Set the
`cli.progress_say_frequency` option to set the minimum delay between
`say` invocations, the default is three seconds. This handler is
available on macOS, if the `say` command is on the path.

The external command and its arguments can be configured with options:

- `cli_progress_say_args`: command line arguments, e.g. you can use this
  to select a voice on macOS,

- `cli_progress_say_command`: external command to run,

- `cli_progress_say_frequency`: wait at least this many seconds between
  calling the external command.

### `shiny`

Use [shiny's progress
bars](https://shiny.rstudio.com/articles/progress.html). This handler is
available if a shiny app is running.

## See also

Other progress bar functions:
[`cli_progress_along()`](https://cli.r-lib.org/reference/cli_progress_along.md),
[`cli_progress_bar()`](https://cli.r-lib.org/reference/cli_progress_bar.md),
[`cli_progress_message()`](https://cli.r-lib.org/reference/cli_progress_message.md),
[`cli_progress_num()`](https://cli.r-lib.org/reference/progress-utils.md),
[`cli_progress_output()`](https://cli.r-lib.org/reference/cli_progress_output.md),
[`cli_progress_step()`](https://cli.r-lib.org/reference/cli_progress_step.md),
[`cli_progress_styles()`](https://cli.r-lib.org/reference/cli_progress_styles.md),
[`progress-variables`](https://cli.r-lib.org/reference/progress-variables.md)
