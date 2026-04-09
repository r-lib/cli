# Detect the number of ANSI colors to use

Certain Unix and Windows terminals, and also certain R GUIs, e.g.
RStudio, support styling terminal output using special control sequences
(ANSI sequences).

`num_ansi_colors()` detects if the current R session supports ANSI
sequences, and if it does how many colors are supported.

## Usage

``` r
num_ansi_colors(stream = "auto")

detect_tty_colors()
```

## Arguments

- stream:

  The stream that will be used for output, an R connection object. It
  can also be a string, one of `"auto"`, `"message"`, `"stdout"`,
  `"stderr"`. `"auto"` will select
  [`stdout()`](https://rdrr.io/r/base/showConnections.html) if the
  session is interactive and there are no sinks, otherwise it will
  select [`stderr()`](https://rdrr.io/r/base/showConnections.html).

## Value

Integer, the number of ANSI colors the current R session supports for
`stream`.

## Details

The detection mechanism is quite involved and it is designed to work out
of the box on most systems. If it does not work on your system, please
report a bug. Setting options and environment variables to turn on ANSI
support is error prone, because they are inherited in other
environments, e.g. knitr, that might not have ANSI support.

If you want to *turn off* ANSI colors, set the `NO_COLOR` environment
variable to a non-empty value.

The exact detection mechanism is as follows:

1.  If the `cli.num_colors` options is set, that is returned.

2.  If the `R_CLI_NUM_COLORS` environment variable is set to a non-empty
    value, then it is used.

3.  If the `crayon.enabled` option is set to `FALSE`, 1L is returned.
    (This is for compatibility with code that uses the crayon package.)

4.  If the `crayon.enabled` option is set to `TRUE` and the
    `crayon.colors` option is not set, then the value of the
    `cli.default_num_colors` option, or if it is unset, then 8L is
    returned.

5.  If the `crayon.enabled` option is set to `TRUE` and the
    `crayon.colors` option is also set, then the latter is returned.
    (This is for compatibility with code that uses the crayon package.)

6.  If the `NO_COLOR` environment variable is set, then 1L is returned.

7.  If we are in knitr, then 1L is returned, to turn off colors in
    `.Rmd` chunks.

8.  If `stream` is `"auto"` (the default) and there is an active sink
    (either for `"output"` or `"message"`), then we return 1L. (In
    theory we would only need to check the stream that will be be
    actually used, but there is no easy way to tell that.)

9.  If `stream` is not `"auto"`, but it is
    [`stderr()`](https://rdrr.io/r/base/showConnections.html) and there
    is an active sink for it, then 1L is returned. (If a sink is active
    for "output", then R changes the
    [`stdout()`](https://rdrr.io/r/base/showConnections.html) stream, so
    this check is not needed.)

10. If the `cli.default_num_colors` option is set, then we use that.

11. If R is running inside RGui on Windows, or R.app on macOS, then we
    return 1L.

12. If R is running inside RStudio, with color support, then the
    appropriate number of colors is returned, usually 256L.

13. If R is running on Windows, inside an Emacs version that is recent
    enough to support ANSI colors, then the value of the
    `cli.default_num_colors` option, or if unset 8L is returned. (On
    Windows, Emacs has `isatty(stdout()) == FALSE`, so we need to check
    for this here before dealing with terminals.)

14. If `stream` is not the standard output or standard error in a
    terminal, then 1L is returned.

15. Otherwise we use and cache the result of the terminal color
    detection (see below).

The terminal color detection algorithm:

1.  If the `COLORTERM` environment variable is set to `truecolor` or
    `24bit`, then we return 16 million colors.

2.  If the `COLORTERM` environment variable is set to anything else,
    then we return the value of the `cli.num_default_colors` option, 8L
    if unset.

3.  If R is running on Unix, inside an Emacs version that is recent
    enough to support ANSI colors, then the value of the
    `cli.default_num_colors` option is returned, or 8L if unset.

4.  If we are on Windows in an RStudio terminal, then apparently we only
    have eight colors, but the `cli.default_num_colors` option can be
    used to override this.

5.  If we are in a recent enough Windows 10 terminal, then there is
    either true color (from build 14931) or 256 color (from build 10586)
    support. You can also use the `cli.default_num_colors` option to
    override these.

6.  If we are on Windows, under ConEmu or cmder, or ANSICON is loaded,
    then the value of `cli.default_num_colors`, or 8L if unset, is
    returned.

7.  Otherwise if we are on Windows, return 1L.

8.  Otherwise we are on Unix and try to run `tput colors` to determine
    the number of colors. If this succeeds, we return its return value.
    If the `TERM` environment variable is `xterm` and `tput` returned
    8L, we return 256L, because xterm compatible terminals tend to
    support 256 colors (<https://github.com/r-lib/crayon/issues/17>) You
    can override this with the `cli.default_num_colors` option.

9.  If `TERM` is set to `dumb`, we return 1L.

10. If `TERM` starts with `screen`, `xterm`, or `vt100`, we return 8L.

11. If `TERM` contains `color`, `ansi`, `cygwin` or `linux`, we return
    8L.

12. Otherwise we return 1L.

## See also

Other ANSI styling:
[`ansi-styles`](https://cli.r-lib.org/reference/ansi-styles.md),
[`combine_ansi_styles()`](https://cli.r-lib.org/reference/combine_ansi_styles.md),
[`make_ansi_style()`](https://cli.r-lib.org/reference/make_ansi_style.md)

## Examples

``` r
num_ansi_colors()
#> [1] 256
```
