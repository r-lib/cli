# Check if a string has some ANSI styling

Check if a string has some ANSI styling

## Usage

``` r
ansi_has_any(string, sgr = TRUE, csi = TRUE, link = TRUE)
```

## Arguments

- string:

  The string to check. It can also be a character vector.

- sgr:

  Whether to look for SGR (styling) control sequences.

- csi:

  Whether to look for non-SGR control sequences.

- link:

  Whether to look for ANSI hyperlinks.

## Value

Logical vector, `TRUE` for the strings that have some ANSI styling.

## See also

Other low level ANSI functions:
[`ansi_hide_cursor()`](https://cli.r-lib.org/dev/reference/ansi_hide_cursor.md),
[`ansi_regex()`](https://cli.r-lib.org/dev/reference/ansi_regex.md),
[`ansi_string()`](https://cli.r-lib.org/dev/reference/ansi_string.md),
[`ansi_strip()`](https://cli.r-lib.org/dev/reference/ansi_strip.md)

## Examples

``` r
## The second one has style if ANSI colors are supported
ansi_has_any("foobar")
#> [1] FALSE
ansi_has_any(col_red("foobar"))
#> [1] TRUE
```
