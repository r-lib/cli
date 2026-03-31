# Substring(s) of an ANSI colored string

This is a color-aware counterpart of
[`base::substr()`](https://rdrr.io/r/base/substr.html). It works exactly
like the original, but keeps the colors in the substrings. The ANSI
escape sequences are ignored when calculating the positions within the
string.

## Usage

``` r
ansi_substr(x, start, stop)
```

## Arguments

- x:

  Character vector, potentially ANSI styled, or a vector to coerced to
  character.

- start:

  Starting index or indices, recycled to match the length of `x`.

- stop:

  Ending index or indices, recycled to match the length of `x`.

## Value

Character vector of the same length as `x`, containing the requested
substrings. ANSI styles are retained.

## See also

Other ANSI string operations:
[`ansi_align()`](https://cli.r-lib.org/dev/reference/ansi_align.md),
[`ansi_columns()`](https://cli.r-lib.org/dev/reference/ansi_columns.md),
[`ansi_nchar()`](https://cli.r-lib.org/dev/reference/ansi_nchar.md),
[`ansi_strsplit()`](https://cli.r-lib.org/dev/reference/ansi_strsplit.md),
[`ansi_strtrim()`](https://cli.r-lib.org/dev/reference/ansi_strtrim.md),
[`ansi_strwrap()`](https://cli.r-lib.org/dev/reference/ansi_strwrap.md),
[`ansi_substring()`](https://cli.r-lib.org/dev/reference/ansi_substring.md),
[`ansi_toupper()`](https://cli.r-lib.org/dev/reference/ansi_toupper.md),
[`ansi_trimws()`](https://cli.r-lib.org/dev/reference/ansi_trimws.md)

## Examples

``` r
str <- paste(
  col_red("red"),
  "default",
  col_green("green")
)

cat(str, "\n")
#> red default green 
cat(ansi_substr(str, 1, 5), "\n")
#> red d 
cat(ansi_substr(str, 1, 15), "\n")
#> red default gre 
cat(ansi_substr(str, 3, 7), "\n")
#> d def 

substr(ansi_strip(str), 1, 5)
#> [1] "red d"
substr(ansi_strip(str), 1, 15)
#> [1] "red default gre"
substr(ansi_strip(str), 3, 7)
#> [1] "d def"

str2 <- paste(
  "another",
  col_red("multi-", style_underline("style")),
  "text"
)

cat(str2, "\n")
#> another multi-style text 
cat(ansi_substr(c(str, str2), c(3,5), c(7, 18)), sep = "\n")
#> d def
#> her multi-styl
substr(ansi_strip(c(str, str2)), c(3,5), c(7, 18))
#> [1] "d def"          "her multi-styl"
```
