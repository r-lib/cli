# cli progress bar demo

Useful for experimenting with format strings and for documentation. It
creates a progress bar, iterates it until it terminates and saves the
progress updates.

## Usage

``` r
cli_progress_demo(
  name = NULL,
  status = NULL,
  type = c("iterator", "tasks", "download", "custom"),
  total = NA,
  .envir = parent.frame(),
  ...,
  at = if (is_interactive()) NULL else 50,
  show_after = 0,
  live = NULL,
  delay = 0,
  start = as.difftime(5, units = "secs")
)
```

## Arguments

- name:

  Passed to
  [`cli_progress_bar()`](https://cli.r-lib.org/dev/reference/cli_progress_bar.md).

- status:

  Passed to
  [`cli_progress_bar()`](https://cli.r-lib.org/dev/reference/cli_progress_bar.md).

- type:

  Passed to
  [`cli_progress_bar()`](https://cli.r-lib.org/dev/reference/cli_progress_bar.md).

- total:

  Passed to
  [`cli_progress_bar()`](https://cli.r-lib.org/dev/reference/cli_progress_bar.md).

- .envir:

  Passed to
  [`cli_progress_bar()`](https://cli.r-lib.org/dev/reference/cli_progress_bar.md).

- ...:

  Passed to
  [`cli_progress_bar()`](https://cli.r-lib.org/dev/reference/cli_progress_bar.md).

- at:

  The number of progress units to show and capture the progress bar at.
  If `NULL`, then a sequence of states is generated to show the progress
  from beginning to end.

- show_after:

  Delay to show the progress bar. Overrides the
  `cli.progress_show_after` option.

- live:

  Whether to show the progress bat on the screen, or just return the
  recorded updates. Defaults to the value of the
  `cli.progress_demo_live` options. If unset, then it is `TRUE` in
  interactive sessions.

- delay:

  Delay between progress bar updates.

- start:

  Time to subtract from the start time, to simulate a progress bar that
  takes longer to run.

## Value

List with class `cli_progress_demo`, which has a print and a format
method for pretty printing. The `lines` entry contains the output lines,
each corresponding to one update.
