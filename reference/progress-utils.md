# Progress bar utility functions.

Progress bar utility functions.

## Usage

``` r
cli_progress_num()

cli_progress_cleanup()
```

## Value

`cli_progress_num()` returns an integer scalar.

\`cli_progress_cleanup() does not return anything.

## Details

`cli_progress_num()` returns the number of currently active progress
bars. (These do not currently include the progress bars created in C/C++
code.)

`cli_progress_cleanup()` terminates all active progress bars. (It
currently ignores progress bars created in the C/C++ code.)

## See also

Other progress bar functions:
[`cli_progress_along()`](https://cli.r-lib.org/reference/cli_progress_along.md),
[`cli_progress_bar()`](https://cli.r-lib.org/reference/cli_progress_bar.md),
[`cli_progress_builtin_handlers()`](https://cli.r-lib.org/reference/cli_progress_builtin_handlers.md),
[`cli_progress_message()`](https://cli.r-lib.org/reference/cli_progress_message.md),
[`cli_progress_output()`](https://cli.r-lib.org/reference/cli_progress_output.md),
[`cli_progress_step()`](https://cli.r-lib.org/reference/cli_progress_step.md),
[`cli_progress_styles()`](https://cli.r-lib.org/reference/cli_progress_styles.md),
[`progress-variables`](https://cli.r-lib.org/reference/progress-variables.md)
