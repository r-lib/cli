# Determine the width of the console

It uses the `cli.width` option, if set. Otherwise it tries to determine
the size of the terminal or console window.

## Usage

``` r
console_width()
```

## Value

Integer scalar, the console with, in number of characters.

## Details

These are the exact rules:

- If the `cli.width` option is set to a positive integer, it is used.

- If the `cli.width` option is set, but it is not a positive integer,
  and error is thrown.

Then we try to determine the size of the terminal or console window:

- If we are not in RStudio, or we are in an RStudio terminal, then we
  try to use the `tty_size()` function to query the terminal size. This
  might fail if R is not running in a terminal, but failures are
  ignored.

- If we are in the RStudio build pane, then the `RSTUDIO_CONSOLE_WIDTH`
  environment variable is used. If the build pane is resized, then this
  environment variable is not accurate any more, and the output might
  get garbled.

- We are *not* using the `RSTUDIO_CONSOLE_WIDTH` environment variable if
  we are in the RStudio console.

If we cannot determine the size of the terminal or console window, then
we use the `width` option. If the `width` option is not set, then we
return 80L.

## Examples

``` r
console_width()
#> [1] 71
```
