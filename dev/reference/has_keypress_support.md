# Check if the current platform/terminal supports reading single keys.

Check if the current platform/terminal supports reading single keys.

## Usage

``` r
has_keypress_support()
```

## Value

Whether there is support for waiting for individual keypressses.

## Details

Supported platforms:

- Terminals in Windows and Unix.

- RStudio terminal.

Not supported:

- RStudio (if not in the RStudio terminal).

- R.app on macOS.

- Rgui on Windows.

- Emacs ESS.

- Others.

## See also

Other keypress function:
[`keypress()`](https://cli.r-lib.org/dev/reference/keypress.md)

## Examples

``` r
has_keypress_support()
#> [1] FALSE
```
