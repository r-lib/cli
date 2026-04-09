# Remove leading and/or trailing whitespace from an ANSI string

This function is similar to
[`base::trimws()`](https://rdrr.io/r/base/trimws.html) but works on ANSI
strings, and keeps color and other styling.

## Usage

``` r
ansi_trimws(x, which = c("both", "left", "right"))
```

## Arguments

- x:

  ANSI string vector.

- which:

  Whether to remove leading or trailing whitespace or both.

## Value

ANSI string, with the whitespace removed.

## See also

Other ANSI string operations:
[`ansi_align()`](https://cli.r-lib.org/reference/ansi_align.md),
[`ansi_columns()`](https://cli.r-lib.org/reference/ansi_columns.md),
[`ansi_nchar()`](https://cli.r-lib.org/reference/ansi_nchar.md),
[`ansi_strsplit()`](https://cli.r-lib.org/reference/ansi_strsplit.md),
[`ansi_strtrim()`](https://cli.r-lib.org/reference/ansi_strtrim.md),
[`ansi_strwrap()`](https://cli.r-lib.org/reference/ansi_strwrap.md),
[`ansi_substr()`](https://cli.r-lib.org/reference/ansi_substr.md),
[`ansi_substring()`](https://cli.r-lib.org/reference/ansi_substring.md),
[`ansi_toupper()`](https://cli.r-lib.org/reference/ansi_toupper.md)

## Examples

``` r
trimws(paste0("   ", col_red("I am red"), "   "))
#> [1] "\033[31mI am red\033[39m"
ansi_trimws(paste0("   ", col_red("I am red"), "   "))
#> <cli_ansi_string>
#> [1] I am red
trimws(col_red("   I am red   "))
#> <cli_ansi_string>
#> [1]    I am red   
ansi_trimws(col_red("   I am red   "))
#> <cli_ansi_string>
#> [1] I am red
```
