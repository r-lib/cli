# Remove ANSI escape sequences from a string

The input may be of class `cli_ansi_string` class, this is also dropped
from the result.

## Usage

``` r
ansi_strip(string, sgr = TRUE, csi = TRUE, link = TRUE)
```

## Arguments

- string:

  The input string.

- sgr:

  Whether to remove for SGR (styling) control sequences.

- csi:

  Whether to remove for non-SGR control sequences.

- link:

  Whether to remove ANSI hyperlinks.

## Value

The cleaned up string. Note that `ansi_strip()` always drops the
`cli_ansi_string` class, even if `sgr` and sci`are`FALSE\`.

## See also

Other low level ANSI functions:
[`ansi_has_any()`](https://cli.r-lib.org/dev/reference/ansi_has_any.md),
[`ansi_hide_cursor()`](https://cli.r-lib.org/dev/reference/ansi_hide_cursor.md),
[`ansi_regex()`](https://cli.r-lib.org/dev/reference/ansi_regex.md),
[`ansi_string()`](https://cli.r-lib.org/dev/reference/ansi_string.md)

## Examples

``` r
ansi_strip(col_red("foobar")) == "foobar"
#> [1] TRUE
```
