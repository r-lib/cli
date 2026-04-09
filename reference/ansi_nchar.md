# Count number of characters in an ANSI colored string

This is a color-aware counterpart of
[`utf8_nchar()`](https://cli.r-lib.org/reference/utf8_nchar.md). By
default it counts Unicode grapheme clusters, instead of code points.

## Usage

``` r
ansi_nchar(x, type = c("chars", "bytes", "width", "graphemes", "codepoints"))
```

## Arguments

- x:

  Character vector, potentially ANSI styled, or a vector to be coerced
  to character. If it converted to UTF-8.

- type:

  Whether to count graphemes (characters), code points, bytes, or
  calculate the display width of the string.

## Value

Numeric vector, the length of the strings in the character vector.

## See also

Other ANSI string operations:
[`ansi_align()`](https://cli.r-lib.org/reference/ansi_align.md),
[`ansi_columns()`](https://cli.r-lib.org/reference/ansi_columns.md),
[`ansi_strsplit()`](https://cli.r-lib.org/reference/ansi_strsplit.md),
[`ansi_strtrim()`](https://cli.r-lib.org/reference/ansi_strtrim.md),
[`ansi_strwrap()`](https://cli.r-lib.org/reference/ansi_strwrap.md),
[`ansi_substr()`](https://cli.r-lib.org/reference/ansi_substr.md),
[`ansi_substring()`](https://cli.r-lib.org/reference/ansi_substring.md),
[`ansi_toupper()`](https://cli.r-lib.org/reference/ansi_toupper.md),
[`ansi_trimws()`](https://cli.r-lib.org/reference/ansi_trimws.md)

## Examples

``` r
str <- paste(
  col_red("red"),
  "default",
  col_green("green")
)

cat(str, "\n")
#> red default green 
nchar(str)
#> [1] 37
ansi_nchar(str)
#> [1] 17
nchar(ansi_strip(str))
#> [1] 17
```
