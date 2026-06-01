# Detect if a stream support ANSI escape characters

The detection mechanism is as follows:

1.  If the `cli.ansi` option is set to `TRUE`, `TRUE` is returned.

2.  If the `cli.ansi` option is set to `FALSE`, `FALSE` is returned.

3.  If the `R_CLI_ANSI` environment variable is set to `true` (case
    insensitive), then `TRUE` is returned.

4.  If `R_CLI_ANSI` is not empty and set to `false` (case insensitive),
    `FALSE` is returned.

5.  If R is running in the Positron console, then `TRUE` is returned,
    with 'positron' added as a name. Positron does not currently support
    hide/show cursor, scrolling regions, inserting and deleting lines
    and the alternate screen buffer.

6.  Otherwise we autodetect, by checking that all of the following hold:

    - The stream is a terminal, see
      [`base::isatty()`](https://rdrr.io/r/base/showConnections.html).

    - R is not running inside R.app (the macOS GUI).

    - R is not running inside Emacs.

    - The terminal is not "dumb".

    - `stream` is either the standard output or the standard error
      stream.

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
