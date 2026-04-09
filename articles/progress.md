# Introduction to progress bars in cli

## Introduction

``` r
library(cli)
options(cli.progress_show_after = 0)
options(cli.progress_clear = FALSE)
```

This document discusses the structure and simplest uses of the cli
progress bar API. For more advanced usage and the C progress bar API,
see the ‘Advanced cli progress bars’ article and the manual pages.

From version 3.0.0 cli provides a set of functions to create progress
bars. The main goals of the progress bar API are:

- Reduce clutter. Try to avoid verbose syntax, unless necessary.
- Flexibility from R and C/C++ code. Support all cli features in
  progress bars: glue interpolation, theming, pluralization, etc.
- Predictably small performance penalty. A very small constant penalty
  per iteration, and a reasonable penalty per second.

## The traditional progress bar API

Add a progress bar in three steps:

1.  Call
    [`cli_progress_bar()`](https://cli.r-lib.org/reference/cli_progress_bar.md)
    to add create a progress bar.
2.  Call
    [`cli_progress_update()`](https://cli.r-lib.org/reference/cli_progress_bar.md)
    to update it.
3.  Call
    [`cli_progress_done()`](https://cli.r-lib.org/reference/cli_progress_bar.md)
    to terminate it.

For example:

``` r
clean <- function() {
  cli_progress_bar("Cleaning data", total = 100)
  for (i in 1:100) {
    Sys.sleep(5/100)
    cli_progress_update()
  }
  cli_progress_done()
}
clean()
```

![Progress bar, that contains, from left to right, the specified label,
the bar with green squares, the progress percentage, and the
ETA.](progress_files/figure-html/classic-example.svg)

The traditional API provides full control w.r.t when to create, update
and terminate a progress bar.

## The current progress bar

For conciseness, the progress bar functions refer to the *current
progress bar* by default. Every function has at most one current
progress bar at any time. The current progress bar of a function is
terminated when the function creates another progress bar or when the
function returns, errors or is interrupted.

The current progress bar lets us omit the
[`cli_progress_done()`](https://cli.r-lib.org/reference/cli_progress_bar.md)
call:

``` r
clean <- function() {
  cli_progress_bar("Cleaning data #1", total = 100)
  for (i in 1:100) {
    Sys.sleep(3/100)
    cli_progress_update()
  }

  cli_progress_bar("Cleaning data #2", total = 100)
  for (i in 1:100) {
    Sys.sleep(3/100)
    cli_progress_update()
  }
}
clean()
```

![Two progress bars, after the first finishes, the second starts and
then finishes as well.](progress_files/figure-html/current.svg)

## Unknown total number of units

In some cases the total number of progress units is unknown, so simply
omit them from
[`cli_progress_bar()`](https://cli.r-lib.org/reference/cli_progress_bar.md)
(or set them to `NA`). cli uses a different display when `total` is
unknown:

``` r
walk_dirs <- function() {
  cli_progress_bar("Walking directories")
  while (TRUE) {
    if (runif(1) < 0.01) break
    Sys.sleep(0.01)
    cli_progress_update()
  }
  cli_progress_update(force = TRUE)
}
walk_dirs()
```

![Example progress bar where the total number of units is unknown. It
has a spinner, the specified label, shows how many units are done, how
many units are completed per second and the elapsed
time.](progress_files/figure-html/unknown-total.svg)

## Quick loops

By default, cli does not show progress bars that are terminated within
two seconds after their creation. The end user can configure this limit
with the `cli.progress_show_after` global option.

For example, in this document we set the limit to zero seconds, so
progress bars are shown at their first update.

## Progress bars for mapping functions: `cli_progress_along()`

[`cli_progress_along()`](https://cli.r-lib.org/reference/cli_progress_along.md)
is currently experimental.

To add a progress bar to a call to
[`lapply()`](https://rdrr.io/r/base/lapply.html) or another mapping
function, wrap the input sequence into
[`cli_progress_along()`](https://cli.r-lib.org/reference/cli_progress_along.md):

``` r
lapply(cli_progress_along(X), fun)
```

[`cli_progress_along()`](https://cli.r-lib.org/reference/cli_progress_along.md)
works similarly to [`seq_along()`](https://rdrr.io/r/base/seq.html), it
returns an index vector. If you use
[`cli_progress_along()`](https://cli.r-lib.org/reference/cli_progress_along.md),
then [`lapply()`](https://rdrr.io/r/base/lapply.html) will pass the
*indices* of the elements in `X` to `fun`, instead of the elements
themselves.

[`cli_progress_along()`](https://cli.r-lib.org/reference/cli_progress_along.md)
expects that the index vector will be used only once, from beginning to
end. It is best to never assign the return value of
[`cli_progress_along()`](https://cli.r-lib.org/reference/cli_progress_along.md)
to a variable.

An example:

``` r
f <- function() {
  rawabc <- lapply(
    cli_progress_along(letters),
    function(i) {
      charToRaw(letters[i])
      Sys.sleep(0.5)
    }
  )
}
f()
```

![Progress bar with green squares, that also shows the progress
percentage and the ETA.](progress_files/figure-html/tickalong.svg)

[`cli_progress_along()`](https://cli.r-lib.org/reference/cli_progress_along.md)
uses ALTREP, so it only works from R 3.5.0 and later. On older R
versions it is equivalent to
[`seq_along()`](https://rdrr.io/r/base/seq.html) and it does not create
a progress bar.

### `for` loops

You can also use
[`cli_progress_along()`](https://cli.r-lib.org/reference/cli_progress_along.md)
in `for` loops, with the additional complication that if you use
[`break`](https://rdrr.io/r/base/Control.html), then you might need to
terminate the progress bar explicitly:

``` r
for (i in cli_progress_along(seq)) {
  ...
  if (cond) cli_progress_done() && break
  ...
}
```

[`cli_progress_done()`](https://cli.r-lib.org/reference/cli_progress_bar.md)
always returns `TRUE` to allow this form.

Alternatively, you can terminate the progress bar right after loop:

``` r
for (i in cli_progress_along(seq)) {
  ...
  if (cond) break
  ...
}
cli_progress_done()
```

If the function containing the `for` loop returns after the loop, or you
create another progress bar with
[`cli_progress_along()`](https://cli.r-lib.org/reference/cli_progress_along.md)
or
[`cli_progress_bar()`](https://cli.r-lib.org/reference/cli_progress_bar.md),
then no explicit
[`cli_progress_done()`](https://cli.r-lib.org/reference/cli_progress_bar.md)
is needed.

## Simplified API

Often you don’t need the full power of the progress bar API, and only
want to show a status message. The
[`cli_progress_message()`](https://cli.r-lib.org/reference/cli_progress_message.md)
and
[`cli_progress_step()`](https://cli.r-lib.org/reference/cli_progress_step.md)
functions are tailored for this.

[`cli_progress_message()`](https://cli.r-lib.org/reference/cli_progress_message.md)
shows a (potentially templated) message in the status bar. For
convenience, the progress bar rules still apply here by default:

- Status messages are removed when their calling function exits.
- A status message removes the previous status message or progress bar
  of the same caller function.

``` r
f <- function() {
  cli_progress_message("Task one is running...")
  Sys.sleep(2)

  cli_progress_message("Task two is running...")
  Sys.sleep(2)

  step <- 1L
  cli_progress_message("Task three is underway: step {step}")
  for (step in 1:5) {
    Sys.sleep(0.5)
    cli_progress_update()
  }
}
f()
```

![The three messages are shown, each on its own line, the third one is
iterated over 5
steps.](progress_files/figure-html/cli_progress_message.svg)

Status messages may use glue interpolation, cli styling and
pluralization, as usual. You can call
[`cli_progress_update()`](https://cli.r-lib.org/reference/cli_progress_bar.md)
to update a status message.

[`cli_progress_step()`](https://cli.r-lib.org/reference/cli_progress_step.md)
is slightly different from
[`cli_progress_message()`](https://cli.r-lib.org/reference/cli_progress_message.md):

- it adds cli’s alert themes to the status messages (info, success or
  danger),
- prints the duration of each step (by default), and
- it keeps the messages on the screen after they are terminated.

``` r
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
```

![Four progress steps are shown, each on its own line. Each steps show
up as an 'i' (info) step first, and stays like that while it is running.
When it is done, the 'i' is turned into a tick mark, and the running
time of the step is added to the line at the end, in
grey.](progress_files/figure-html/cli_progress_step_simple.svg)

As usual, you can use
[`cli_progress_step()`](https://cli.r-lib.org/reference/cli_progress_step.md)
to update an existing status message.

``` r
f <- function(n = 10) {
  cli_alert_info("About to start downloads of {n} file{?s}")
  i <- 0
  cli_progress_step("Got {i}/{n} {qty(i)}file{?s}.")
  for (i in seq_len(n)) {
    Sys.sleep(0.5)
    if (i == 5) cli_alert_info("Already half way!")
    cli_progress_update()
  }
}
f()
```

![First the 'About to start..'. message is shown in its own line. Then a
progress bar starts on the next line. The progress bar takes 10 steps.
After the fifth step, the progress bar is overwritten with the 'Already
half way!' message and the progress bar is moved down to the third
line.](progress_files/figure-html/cli_progress_step.svg)

If you can update the status message frequently enough, then you can
also add a spinner to it:

``` r
f <- function() {
  cli_progress_step("Downloading data", spinner = TRUE)
  for (i in 1:100) { cli_progress_update(); Sys.sleep(2/100) }
  cli_progress_step("Importing data", spinner = TRUE)
  for (i in 1:100) { cli_progress_update(); Sys.sleep(1/100) }
  cli_progress_step("Cleaning data", spinner = TRUE)
  for (i in 1:100) { cli_progress_update(); Sys.sleep(2/100) }
  cli_progress_step("Fitting model", spinner = TRUE)
  for (i in 1:100) { cli_progress_update(); Sys.sleep(3/100) }
}
f()
```

![Four steps are shown, each on its own line. While each step is
running, its line has a spinner. Once it is done, the spinner turns into
a tick mark and the running time of the step is added to its line at the
end.](progress_files/figure-html/cli_progress_step_spinner.svg)

[`cli_progress_step()`](https://cli.r-lib.org/reference/cli_progress_step.md)
automatically handles errors, and styles the status message accordingly:

``` r
f <- function() {
  cli_progress_step("First step, this will succeed")
  Sys.sleep(1)
  cli_progress_step("Second step, this will fail")
  Sys.sleep(1)
  stop("Something is wrong here")
}
f()
```

![Two steps are shown, each in its own line. While a step is running its
line is an 'i' (info) line. The first step finishes successfully and its
'i' mark is turned into a tick mark. The second step fails with an error
and its line is overwritten with the error message, and moved down to
the third line, and marked with an 'x' (error)
mark.](progress_files/figure-html/step-error.svg)
