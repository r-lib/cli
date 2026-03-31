# Detect if a stream support ANSI escape characters

We check that all of the following hold:

- The stream is a terminal.

- The platform is Unix.

- R is not running inside R.app (the macOS GUI).

- R is not running inside RStudio.

- R is not running inside Emacs.

- The terminal is not "dumb".

- `stream` is either the standard output or the standard error stream.

## Usage

``` r
is_ansi_tty(stream = "auto")
```

## Arguments

- stream:

  The stream to inspect or manipulate, an R connection object. It can
  also be a string, one of `"auto"`, `"message"`, `"stdout"`,
  `"stderr"`. `"auto"` will select
  [`stdout()`](https://rdrr.io/r/base/showConnections.html) if the
  session is interactive and there are no sinks, otherwise it will
  select [`stderr()`](https://rdrr.io/r/base/showConnections.html).

## Value

`TRUE` or `FALSE`.

## See also

Other terminal capabilities:
[`ansi_hide_cursor()`](https://cli.r-lib.org/dev/reference/ansi_hide_cursor.md),
[`is_dynamic_tty()`](https://cli.r-lib.org/dev/reference/is_dynamic_tty.md)

## Examples

``` r
is_ansi_tty()
#> [1] FALSE
```
