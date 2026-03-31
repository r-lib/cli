# Perl compatible regular expression that matches ANSI escape sequences

Don't forget to use `perl = TRUE` when using this with
[`grepl()`](https://rdrr.io/r/base/grep.html) and friends.

## Usage

``` r
ansi_regex()
```

## Value

String scalar, the regular expression.

## See also

Other low level ANSI functions:
[`ansi_has_any()`](https://cli.r-lib.org/dev/reference/ansi_has_any.md),
[`ansi_hide_cursor()`](https://cli.r-lib.org/dev/reference/ansi_hide_cursor.md),
[`ansi_string()`](https://cli.r-lib.org/dev/reference/ansi_string.md),
[`ansi_strip()`](https://cli.r-lib.org/dev/reference/ansi_strip.md)
