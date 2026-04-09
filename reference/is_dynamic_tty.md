# Detect whether a stream supports `\\r` (Carriage return)

In a terminal, `\\r` moves the cursor to the first position of the same
line. It is also supported by most R IDEs. `\\r` is typically used to
achieve a more dynamic, less cluttered user interface, e.g. to create
progress bars.

## Usage

``` r
is_dynamic_tty(stream = "auto")
```

## Arguments

- stream:

  The stream to inspect or manipulate, an R connection object. It can
  also be a string, one of `"auto"`, `"message"`, `"stdout"`,
  `"stderr"`. `"auto"` will select
  [`stdout()`](https://rdrr.io/r/base/showConnections.html) if the
  session is interactive and there are no sinks, otherwise it will
  select [`stderr()`](https://rdrr.io/r/base/showConnections.html).

## Details

If the output is directed to a file, then `\\r` characters are typically
unwanted. This function detects if `\\r` can be used for the given
stream or not.

The detection mechanism is as follows:

1.  If the `cli.dynamic` option is set to `TRUE`, `TRUE` is returned.

2.  If the `cli.dynamic` option is set to anything else, `FALSE` is
    returned.

3.  If the `R_CLI_DYNAMIC` environment variable is not empty and set to
    the string `"true"`, `"TRUE"` or `"True"`, `TRUE` is returned.

4.  If `R_CLI_DYNAMIC` is not empty and set to anything else, `FALSE` is
    returned.

5.  If the stream is a terminal, then `TRUE` is returned.

6.  If the stream is the standard output or error within RStudio, the
    macOS R app, or RKWard IDE, `TRUE` is returned.

7.  Otherwise `FALSE` is returned.

## See also

Other terminal capabilities:
[`ansi_hide_cursor()`](https://cli.r-lib.org/reference/ansi_hide_cursor.md),
[`is_ansi_tty()`](https://cli.r-lib.org/reference/is_ansi_tty.md)

## Examples

``` r
is_dynamic_tty()
#> [1] FALSE
is_dynamic_tty(stdout())
#> [1] FALSE
```
