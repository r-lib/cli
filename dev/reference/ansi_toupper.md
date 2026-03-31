# ANSI character translation and case folding

There functions are similar to
[`toupper()`](https://rdrr.io/r/base/chartr.html),
[`tolower()`](https://rdrr.io/r/base/chartr.html) and
[`chartr()`](https://rdrr.io/r/base/chartr.html), but they keep the ANSI
colors of the string.

## Usage

``` r
ansi_toupper(x)

ansi_tolower(x)

ansi_chartr(old, new, x)
```

## Arguments

- x:

  Input string. May have ANSI colors and styles.

- old:

  a character string specifying the characters to be translated. If a
  character vector of length 2 or more is supplied, the first element is
  used with a warning.

- new:

  a character string specifying the translations. If a character vector
  of length 2 or more is supplied, the first element is used with a
  warning.

## Value

Character vector of the same length as `x`, containing the translated
strings. ANSI styles are retained.

## See also

Other ANSI string operations:
[`ansi_align()`](https://cli.r-lib.org/dev/reference/ansi_align.md),
[`ansi_columns()`](https://cli.r-lib.org/dev/reference/ansi_columns.md),
[`ansi_nchar()`](https://cli.r-lib.org/dev/reference/ansi_nchar.md),
[`ansi_strsplit()`](https://cli.r-lib.org/dev/reference/ansi_strsplit.md),
[`ansi_strtrim()`](https://cli.r-lib.org/dev/reference/ansi_strtrim.md),
[`ansi_strwrap()`](https://cli.r-lib.org/dev/reference/ansi_strwrap.md),
[`ansi_substr()`](https://cli.r-lib.org/dev/reference/ansi_substr.md),
[`ansi_substring()`](https://cli.r-lib.org/dev/reference/ansi_substring.md),
[`ansi_trimws()`](https://cli.r-lib.org/dev/reference/ansi_trimws.md)

Other ANSI string operations:
[`ansi_align()`](https://cli.r-lib.org/dev/reference/ansi_align.md),
[`ansi_columns()`](https://cli.r-lib.org/dev/reference/ansi_columns.md),
[`ansi_nchar()`](https://cli.r-lib.org/dev/reference/ansi_nchar.md),
[`ansi_strsplit()`](https://cli.r-lib.org/dev/reference/ansi_strsplit.md),
[`ansi_strtrim()`](https://cli.r-lib.org/dev/reference/ansi_strtrim.md),
[`ansi_strwrap()`](https://cli.r-lib.org/dev/reference/ansi_strwrap.md),
[`ansi_substr()`](https://cli.r-lib.org/dev/reference/ansi_substr.md),
[`ansi_substring()`](https://cli.r-lib.org/dev/reference/ansi_substring.md),
[`ansi_trimws()`](https://cli.r-lib.org/dev/reference/ansi_trimws.md)

Other ANSI string operations:
[`ansi_align()`](https://cli.r-lib.org/dev/reference/ansi_align.md),
[`ansi_columns()`](https://cli.r-lib.org/dev/reference/ansi_columns.md),
[`ansi_nchar()`](https://cli.r-lib.org/dev/reference/ansi_nchar.md),
[`ansi_strsplit()`](https://cli.r-lib.org/dev/reference/ansi_strsplit.md),
[`ansi_strtrim()`](https://cli.r-lib.org/dev/reference/ansi_strtrim.md),
[`ansi_strwrap()`](https://cli.r-lib.org/dev/reference/ansi_strwrap.md),
[`ansi_substr()`](https://cli.r-lib.org/dev/reference/ansi_substr.md),
[`ansi_substring()`](https://cli.r-lib.org/dev/reference/ansi_substring.md),
[`ansi_trimws()`](https://cli.r-lib.org/dev/reference/ansi_trimws.md)

## Examples

``` r
ansi_toupper(col_red("Uppercase"))
#> <cli_ansi_string>
#> [1] UPPERCASE

ansi_tolower(col_red("LowerCase"))
#> <cli_ansi_string>
#> [1] lowercase

x <- paste0(col_green("MiXeD"), col_red(" cAsE 123"))
ansi_chartr("iXs", "why", x)
#> <cli_ansi_string>
#> [1] MwheD cAyE 123
```
