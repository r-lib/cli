# Substring(s) of an ANSI colored string

This is the color-aware counterpart of
[`base::substring()`](https://rdrr.io/r/base/substr.html). It works
exactly like the original, but keeps the colors in the substrings. The
ANSI escape sequences are ignored when calculating the positions within
the string.

## Usage

``` r
ansi_substring(text, first, last = 1000000L)
```

## Arguments

- text:

  Character vector, potentially ANSI styled, or a vector to coerced to
  character. It is recycled to the longest of `first` and `last`.

- first:

  Starting index or indices, recycled to match the length of `x`.

- last:

  Ending index or indices, recycled to match the length of `x`.

## Value

Character vector of the same length as `x`, containing the requested
substrings. ANSI styles are retained.

## See also

Other ANSI string operations:
[`ansi_align()`](https://cli.r-lib.org/reference/ansi_align.md),
[`ansi_columns()`](https://cli.r-lib.org/reference/ansi_columns.md),
[`ansi_nchar()`](https://cli.r-lib.org/reference/ansi_nchar.md),
[`ansi_strsplit()`](https://cli.r-lib.org/reference/ansi_strsplit.md),
[`ansi_strtrim()`](https://cli.r-lib.org/reference/ansi_strtrim.md),
[`ansi_strwrap()`](https://cli.r-lib.org/reference/ansi_strwrap.md),
[`ansi_substr()`](https://cli.r-lib.org/reference/ansi_substr.md),
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
cat(ansi_substring(str, 1, 5), "\n")
#> red d 
cat(ansi_substring(str, 1, 15), "\n")
#> red default gre 
cat(ansi_substring(str, 3, 7), "\n")
#> d def 

substring(ansi_strip(str), 1, 5)
#> [1] "red d"
substring(ansi_strip(str), 1, 15)
#> [1] "red default gre"
substring(ansi_strip(str), 3, 7)
#> [1] "d def"

str2 <- paste(
  "another",
  col_red("multi-", style_underline("style")),
  "text"
)

cat(str2, "\n")
#> another multi-style text 
cat(ansi_substring(str2, c(3,5), c(7, 18)), sep = "\n")
#> other
#> her multi-styl
substring(ansi_strip(str2), c(3,5), c(7, 18))
#> [1] "other"          "her multi-styl"
```
