# Truncate an ANSI string

This function is similar to
[`base::strtrim()`](https://rdrr.io/r/base/strtrim.html), but works
correctly with ANSI styled strings. It also adds `...` (or the
corresponding Unicode character if Unicode characters are allowed) to
the end of truncated strings.

## Usage

``` r
ansi_strtrim(x, width = console_width(), ellipsis = symbol$ellipsis)
```

## Arguments

- x:

  Character vector of ANSI strings.

- width:

  The width to truncate to.

- ellipsis:

  The string to append to truncated strings. Supply an empty string if
  you don't want a marker.

## Details

Note: `ansi_strtrim()` does not support NA values currently.

## See also

Other ANSI string operations:
[`ansi_align()`](https://cli.r-lib.org/dev/reference/ansi_align.md),
[`ansi_columns()`](https://cli.r-lib.org/dev/reference/ansi_columns.md),
[`ansi_nchar()`](https://cli.r-lib.org/dev/reference/ansi_nchar.md),
[`ansi_strsplit()`](https://cli.r-lib.org/dev/reference/ansi_strsplit.md),
[`ansi_strwrap()`](https://cli.r-lib.org/dev/reference/ansi_strwrap.md),
[`ansi_substr()`](https://cli.r-lib.org/dev/reference/ansi_substr.md),
[`ansi_substring()`](https://cli.r-lib.org/dev/reference/ansi_substring.md),
[`ansi_toupper()`](https://cli.r-lib.org/dev/reference/ansi_toupper.md),
[`ansi_trimws()`](https://cli.r-lib.org/dev/reference/ansi_trimws.md)

## Examples

``` r
text <- cli::col_red(cli:::lorem_ipsum())
ansi_strtrim(c(text, "foobar"), 40)
#> <cli_ansi_string>
#> [1] Culpa laboris laborum occaecat occaecat…
#> [2] foobar                                                  
```
