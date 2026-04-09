# Advanced cli progress bars

``` r
library(cli)
```

## Overhead

cli progress bars do have an overhead that may or may not be significant
for your use case. In the R API, if you have a tight loop, then you
should not update the progress bar too often.

### Minimizing overhead

To minimize progress bar overhead,
[`cli_progress_update()`](https://cli.r-lib.org/reference/cli_progress_bar.md)
uses an internal timer and only update the progress bar on the screen if
the timer is due.

In C code, you can refer to the timer directly to avoid an update. The
`CLI_SHOULD_TICK` macro evaluates to one if the timer is due and an
update is needed, otherwise to zero. `CLI_SHOULD_TICK` only works if you
already created a cli progress bar from C, or you called
`cli_progress_init_timer()`. The latter initializes the cli timer
without creating a progress bar. (If the timer is not initialized, then
`CLI_SHOULD_TICK` evaluates to zero.)

``` c
  SEXP bar = PROTECT(cli_progress_bar(num_iters, NULL));
  for (i = 0; i < num_iters; i++) {
    if (CLI_SHOULD_TICK) cli_progress_set(bar, i);
    // ...
  }
  cli_progress_done(bar);
```

## Non-interactive R sessions

cli output is different if the terminal or platform is not *dynamic*,
i.e. if it does not support the `\r` character to move the cursor to the
beginning of the line without starting a new line. This often happens
when R is running non-interactively and the standard error is redirected
to a file. cli uses the
[`cli::is_dynamic_tty()`](https://cli.r-lib.org/reference/is_dynamic_tty.md)
function to determine if the output supports `\r`.

On a non-dynamic terminal, cli simply prints progress updates as new
lines to the screen. Frequently updating the progress in this fashion
would produce a lot of output, so on non-dynamic terminals cli falls
back to a slower timer update interval.

By default the cli timer signals every 3000 milliseconds in an R session
without a dynamic terminal, instead of 200 milliseconds.

## Progress bars in scripts

You can use progress bars in R scripts, just like you use them in R
packages.

In an R script you might create a progress bar from the global
environment, instead from within a function call. The global environment
also has a *current* progress bar, so when you create a progress bar
from the global environment, the previous one from the same environment
is terminated. However, there is not function to return from, so the
last progress bar of the script will be only terminated when the script
terminates, or when you explicitly terminate it using
[`cli_progress_done()`](https://cli.r-lib.org/reference/cli_progress_bar.md).

## Customization

cli progress bars can be customized by the developer and the end user,
by setting options, providing function arguments and regular cli themes.

Some aspects can only be customized by the developer, and some others
can only be customized by the end user. Others can be customized by
both, with the end user’s setting taking precedence.

### Developer customization

#### About progress bar types

Each progress bar type has a default display (format string), which can
be configured by the end user. The current progress bar types are, with
their default display, with known and unknown number of total progress
units.

#### `iterator`

Typically for loops and mapping functions. It shows a bar by default, if
the total number of iterations is known.

![Example of an \`iterator\` progress bar, from left to right it
contains a label (\`Data cleaning\`), a progress bar, the progress
percentage, and the
ETA.](progress-advanced_files/figure-html/iterator.svg)

![Example of an \`iterator\` progress var, where the total number of
iterations is unknown. From left to right it contains a spinner, the
label (\`Data cleaning\`), how many iterations are done (\`50 done\`),
how many seconds it takes to run an iteration, and the elapsed
time.](progress-advanced_files/figure-html/iterator2.svg)

#### `tasks`

For a list of tasks, by default it shows a `current/total` display.

![Example of a \`tasks\` progress bar, from left to right it contains a
spinner, the number of completed tasks per the total number of tasks,
the ETA, and the specified label: \`Finding data
files\`.](progress-advanced_files/figure-html/tasks.svg)

![Example of a \`tasks\` progress bar where the total number of tasks is
unknown. From left to right it contains a spinner, the specified label
('Finding data files\`), the number of tasks completed, how long it taks
to complete a task, and the elapsed
time.](progress-advanced_files/figure-html/tasks2.svg)

#### `download`

For downloads, progress units are shown as bytes by default here.

![Example of a \`download\` progress bar. From left to right it contains
a label ('Downloading\`), an actual progress bar, the completed and the
total download size and the
ETA.](progress-advanced_files/figure-html/download.svg)

![Example of a \`download\` progress bar, where the total download size
is unknown. From left to right it contains the specified label
(\`Downloading\`), a spinner, the number of downloaded bytes, the
download rate (\`kB/s\`), and the elapsed
time.](progress-advanced_files/figure-html/download2.svg)

#### `custom`

For custom displays, the developer has to specify an format string for
`custom` progress bars.

#### Custom format strings (by the developer)

The developer can specify a custom format string for a progress bar. For
`custom` progress bars, this is compulsory. Format strings may use glue
templating, cli pluralization and cli theming. They can also use a
number of built-in cli progress variables, see ‘Progress variables’
below.

``` r
f <- function() {
  cli_progress_bar(
    total = 20000,
    format = "Step {step} | {pb_bar} {pb_percent}"
  )
  step <- 1
  for (i in 1:10000) {
    Sys.sleep(2/10000)
    cli_progress_update(set = i)
  }
  step <- 2
  for (i in 10001:20000) {
    Sys.sleep(2/10000)
    cli_progress_update(set = i)
  }
}
f()
```

![Example of a \`custom\` progress bar. It contains a dynamic label,
\`Step 1\` that changed to \`Step 2\` later, a bar and the
percentage.](progress-advanced_files/figure-html/custom.svg)

For `custom` progress bars cli always uses the specified format string.
For other types, the end user might customize the format string, see
below.

### End user customization

#### Quick loops

The `cli.progress_show_after` (default is two seconds) option is the
number seconds to wait before showing a progress bar.

#### Custom bars

The end user can customize how a progress bar will look, by setting one
or more of the following options:

- `cli.progress_bar_style`
- `cli.progress_bar_style_unicode`
- `cli.progress_bar_style_ascii`

On UTF-8 displays `cli.progress_bar_style_unicode` is used, if set.
Otherwise `cli.progress_bar_style` is used. On non UTF-8 displays
`cli.progress_bar_style_ascii` is used, if set. Otherwise
`cli.progress_bar_style` is used.

These options can be set to a built-in progress bar style name:

``` r
names(cli_progress_styles())
#> [1] "classic"     "squares"     "dot"         "fillsquares"
#> [5] "bar"
```

``` r
options(cli.progress_bar_style = "fillsquares")
f <- function() lapply(cli_progress_along(letters), function(l) Sys.sleep(0.2))
x <- f()
```

![Example with the \`fillsquares\` progress bar style. It contains a
progress bar where empty squares are filled up, the progress percentage
and the ETA.](progress-advanced_files/figure-html/progress-styles.svg)

Alternatively, they can be set to a list with entries `complete`,
`incomplete` and `current`, to specify the characters (or strings) for
the parts of the progress bar:

``` r
options(cli.progress_bar_style = list(
  complete = cli::col_yellow("\u2605"),
  incomplete = cli::col_grey("\u00b7")
))
f <- function() lapply(cli_progress_along(letters), function(l) Sys.sleep(0.2))
x <- f()
```

![Example of a customized progress bar. Centered black dots are replaced
by yellow stars in the progress bar, that also has the progress
percentage and the
ETA.](progress-advanced_files/figure-html/progress-custom-style.svg)

#### Custom spinners

Options to customize cli spinners:

- `cli.spinner`
- `cli.spinner_unicode`
- `cli.spinner_ascii`

On UTF-8 displays `cli.spinner_unicode` is used, if set, otherwise
`cli.spinner`. On ASCII displays `cli.spinner_ascii` is used, if set,
otherwise `cli.spinner`.

Use
[`list_spinners()`](https://cli.r-lib.org/reference/list_spinners.md) to
list all spinners and
[`demo_spinners()`](https://cli.r-lib.org/reference/demo_spinners.md) to
take a peek at them.

``` r
options(cli.spinner = "moon")
f <- function() {
  cli_progress_bar(format = strrep("{cli::pb_spin} ", 20), clear = TRUE)
  for (i in 1:100) {
    Sys.sleep(5/100)
    cli_progress_update()
  }
}
f()
```

![A custom spinner that shows 20 spinners, each animating the moon
phases.](progress-advanced_files/figure-html/custom-spinner.svg)

#### Custom format strings

The end user may use a number of global options to customize how the
built-in progress bar types are displayed on the screen:

- `cli.progress_format_iterator` is used for `iterator` progress bars.
- `cli.progress_format_iterator_nototal` is used for `iterator` progress
  bars with an unknown number of total units.
- `cli.progress_format_tasks` is used for `tasks` progress bars.
- `cli.progress_format_tasks_nototal` is used for `tasks` progress bars
  with an unknown number of total units.
- `cli.progress_format_download` is used for `download` progress bars.
- `cli.progress_format_download_nototal` is used for `download` progress
  bars with an unknown number of total units.

### Progress variables

Custom format strings may use progress variables in glue interpolated
expressions, to refer to the state of the progress bar. See
[`?"progress-variables"`](https://cli.r-lib.org/reference/progress-variables.md)
in the manual for the list of supported variables.

If you refer to a progress variable from a package, you need need to
import it or qualify the reference with `cli::`. When you set a custom
format string as an end user option, we suggest that you always use the
qualified form, in case the cli package is not attached. For example, to
set a minimal display for downloads you might write

to get

![A custom download progress bar, it has a thick down arrow, a spinner,
a label (\`Downloading\`), the completed and the total number of
bytes.](progress-advanced_files/figure-html/download2-vars2.svg)

You can use your own expressions and functions on progress bar tokens.
E.g. to show the current number of steps with letters instead of
numbers, use `letters[pb_current]`:

``` r
f <- function() {
  cli_progress_bar(
    total = 26,
    format = "{pb_spin} This is step {.emph {letters[pb_current]}}. {pb_spin}"
  )
  for (i in 1:26) {
    Sys.sleep(3/26)
    cli_progress_update()
  }
}
f()
```

![A custom progress bar, it has two spinners, one on the left, the other
on the right. In the middle it has a dynamic label that iterates over
the letters of the English
alphabet.](progress-advanced_files/figure-html/function-of-token.svg)

### Clearing or keeping terminated progress bars

By default terminated progress bars are removed from the screen. The end
user can set the `cli.progress_clear` option to `FALSE` to override the
default. In addition, the developer can also change the default, using
the `clear` parameter of
[`cli_progress_bar()`](https://cli.r-lib.org/reference/cli_progress_bar.md).
If both the option and the parameter are set, the parameter is used.

## The C API

To use the C cli progress API in your package, you need to add cli to
`LinkingTo` and `Imports`:

    LinkingTo: cli
    Imports: cli

In the C files you want to use the API from include `cli/progress.h`:

``` c
#include <cli/progress.h>
```

Now you are ready to call cli functions. The C API is similar to the
traditional R API:

1.  [`cli_progress_bar()`](https://cli.r-lib.org/reference/cli_progress_bar.md)
    creates a progress bar.
2.  [`cli_progress_update()`](https://cli.r-lib.org/reference/cli_progress_bar.md)
    updates a progress bar.
3.  [`cli_progress_done()`](https://cli.r-lib.org/reference/cli_progress_bar.md)
    terminates it.

A complete example:

``` cpp
SEXP progress_test1() {
  int i;
  SEXP bar = PROTECT(cli_progress_bar(1000, NULL));
  for (i = 0; i < 1000; i++) {
    cli_progress_sleep(0, 4 * 1000 * 1000);
    if (CLI_SHOULD_TICK) cli_progress_set(bar, i);
  }
  cli_progress_done(bar);
  UNPROTECT(1);
  return Rf_ScalarInteger(i);
}
```

![A progress bar that also show the progress percentage and the
ETA.](progress-advanced_files/figure-html/progress-test-1.svg)

### C API reference

#### `CLI_SHOULD_TICK`

A macro that evaluates to (int) 1 if a cli progress bar update is due,
and to (int) 0 otherwise. If the timer hasn’t been initialized in this
compilation unit yet, then it is always 0. To initialize the timer, call
`cli_progress_init_timer()` or create a progress bar with
[`cli_progress_bar()`](https://cli.r-lib.org/reference/cli_progress_bar.md).

#### `cli_progress_add()`

``` c
void cli_progress_add(SEXP bar, double inc);
```

Add a number of progress units to the progress bar. It will also trigger
an update if an update is due.

- `bar`: progress bar object.
- `inc`: progress increment.

#### `cli_progress_bar()`

``` c
SEXP cli_progress_bar(double total, SEXP config);
```

Create a new progress bar object. The returned progress bar object must
be `PROTECT()`-ed.

- `total`: Total number of progress units. Use `NA_REAL` if it is not
  known.
- `config`: R named list object of additional parameters. May be `NULL`
  (the C `NULL~) or`R_NilValue`(the R`NULL\`) for the defaults.

`config` may contain the following entries:

- `name`: progress bar name.
- `status`: (initial) progress bar status.
- `type`: progress bar type.
- `total`: total number of progress units.
- `show_after`: show the progress bar after the specified number of
  seconds. This overrides the global `show_after` option.
- `format`: format string, must be specified for custom progress bars.
- `format_done`: format string for successful termination.
- `format_failed`: format string for unsuccessful termination.
- `clear`: whether to remove the progress bar from the screen after
  termination.
- `auto_terminate`: whether to terminate the progress bar when the
  number of current units equals the number of total progress units.

##### Example

``` c
#include <cli/progress.h>
SEXP progress_test1() {
  int i;
  SEXP bar = PROTECT(cli_progress_bar(1000, NULL));
  for (i = 0; i < 1000; i++) {
    cli_progress_sleep(0, 4 * 1000 * 1000);
    if (CLI_SHOULD_TICK) cli_progress_set(bar, i);
  }
  cli_progress_done(bar);
  UNPROTECT(1);
  return Rf_ScalarInteger(i);
}
```

#### `cli_progress_done()`

``` c
void cli_progress_done(SEXP bar);
```

Terminate the progress bar.

- `bar`: progress bar object.

#### `cli_progress_init_timer()`

``` c
void cli_progress_init_timer();
```

Initialize the cli timer without creating a progress bar.

#### `cli_progress_num()`

``` c
int cli_progress_num();
```

Returns the number of currently active progress bars.

#### `cli_progress_set()`

``` c
void cli_progress_set(SEXP bar, double set);
```

Set the progress bar to the specified number of progress units.

- `bar`: progress bar object.
- `set`: number of current progress progress units.

#### `cli_progress_set_clear()`

``` c
void cli_progress_set_clear(SEXP bar, int clear);
```

Set whether to remove the progress bar from the screen. You can call
this any time before
[`cli_progress_done()`](https://cli.r-lib.org/reference/cli_progress_bar.md)
is called.

- `bar`: progress bar object.
- `clear`: whether to remove the progress bar from the screen, zero or
  one.

#### `cli_progress_set_format()`

``` c
void cli_progress_set_format(SEXP bar, const char *format, ...);
```

Set a custom format string for the progress bar. This call does not try
to update the progress bar. If you want to request an update, call
`cli_progress_add()`, `cli_progress_set()` or
[`cli_progress_update()`](https://cli.r-lib.org/reference/cli_progress_bar.md).

- `bar`: progress bar object.
- `format`: format string.
- `...`: values to substitute into `format`.

`format` and `...` are passed to `vsnprintf()` to create a format
string.

Format strings may contain glue substitutions, referring to [progress
variables](https://cli.r-lib.org/dev/reference/progress-variables.html),
pluralization, and cli styling.

#### `cli_progress_set_name()`

``` c
void cli_progress_set_name(SEXP bar, const char *name);
```

Set the name of the progress bar.

- `bar`; progress bar object.
- `name`: progress bar name.

#### `cli_progress_set_status()`

``` c
void cli_progress_set_status(SEXP bar, const char *status);
```

Set the status of the progress bar.

- `bar`: progress bar object.
- `status`: progress bar status.

#### `cli_progress_set_type()`

``` c
void cli_progress_set_type(SEXP bar, const char *type);
```

Set the progress bar type. Call this function right after creating the
progress bar with
[`cli_progress_bar()`](https://cli.r-lib.org/reference/cli_progress_bar.md).
Otherwise the behavior is undefined.

- `bar`: progress bar object.
- `type`: progress bar type. Possible progress bar types: `iterator`,
  `tasks`, `download` and `custom`.

#### `cli_progress_update()`

``` c
void cli_progress_update(SEXP bar, double set, double inc, int force);
```

Update the progress bar. Unlike the simpler `cli_progress_add()` and
`cli_progress_set()` function, it can force an update if `force` is set
to 1.

- `bar`: progress bar object.
- `set`: the number of current progress units. It is ignored if
  negative.
- `inc`: increment to add to the current number of progress units. It is
  ignored if `set` is not negative.
- `force`: whether to force an update, even if no update is due.

To force an update without changing the current number of progress
units, supply `set = -1`, `inc = 0` and `force = 1`.
