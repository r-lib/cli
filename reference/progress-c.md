# The cli progress C API

The cli progress C API

## The cli progress C API

### `CLI_SHOULD_TICK`

A macro that evaluates to (int) 1 if a cli progress bar update is due,
and to (int) 0 otherwise. If the timer hasn't been initialized in this
compilation unit yet, then it is always 0. To initialize the timer, call
`cli_progress_init_timer()` or create a progress bar with
[`cli_progress_bar()`](https://cli.r-lib.org/reference/cli_progress_bar.md).

### `cli_progress_add()`

    void cli_progress_add(SEXP bar, double inc);

Add a number of progress units to the progress bar. It will also trigger
an update if an update is due.

- `bar`: progress bar object.

- `inc`: progress increment.

### [`cli_progress_bar()`](https://cli.r-lib.org/reference/cli_progress_bar.md)

    SEXP cli_progress_bar(double total, SEXP config);

Create a new progress bar object. The returned progress bar object must
be `PROTECT()`-ed.

- `total`: Total number of progress units. Use `NA_REAL` if it is not
  known.

- `config`: R named list object of additional parameters. May be `NULL`
  (the C `NULL~) or `R_NilValue`(the R`NULL\`) for the defaults.

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

#### Example

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

### [`cli_progress_done()`](https://cli.r-lib.org/reference/cli_progress_bar.md)

    void cli_progress_done(SEXP bar);

Terminate the progress bar.

- `bar`: progress bar object.

### `cli_progress_init_timer()`

    void cli_progress_init_timer();

Initialize the cli timer without creating a progress bar.

### [`cli_progress_num()`](https://cli.r-lib.org/reference/progress-utils.md)

    int cli_progress_num();

Returns the number of currently active progress bars.

### `cli_progress_set()`

    void cli_progress_set(SEXP bar, double set);

Set the progress bar to the specified number of progress units.

- `bar`: progress bar object.

- `set`: number of current progress progress units.

### `cli_progress_set_clear()`

    void cli_progress_set_clear(SEXP bar, int clear);

Set whether to remove the progress bar from the screen. You can call
this any time before
[`cli_progress_done()`](https://cli.r-lib.org/reference/cli_progress_bar.md)
is called.

- `bar`: progress bar object.

- `clear`: whether to remove the progress bar from the screen, zero or
  one.

### `cli_progress_set_format()`

    void cli_progress_set_format(SEXP bar, const char *format, ...);

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

### `cli_progress_set_name()`

    void cli_progress_set_name(SEXP bar, const char *name);

Set the name of the progress bar.

- `bar`; progress bar object.

- `name`: progress bar name.

### `cli_progress_set_status()`

    void cli_progress_set_status(SEXP bar, const char *status);

Set the status of the progress bar.

- `bar`: progress bar object.

- `status `: progress bar status.

### `cli_progress_set_type()`

    void cli_progress_set_type(SEXP bar, const char *type);

Set the progress bar type. Call this function right after creating the
progress bar with
[`cli_progress_bar()`](https://cli.r-lib.org/reference/cli_progress_bar.md).
Otherwise the behavior is undefined.

- `bar`: progress bar object.

- `type`: progress bar type. Possible progress bar types: `iterator`,
  `tasks`, `download` and `custom`.

### [`cli_progress_update()`](https://cli.r-lib.org/reference/cli_progress_bar.md)

    void cli_progress_update(SEXP bar, double set, double inc, int force);

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
