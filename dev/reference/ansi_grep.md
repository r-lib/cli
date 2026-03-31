# Like [`base::grep()`](https://rdrr.io/r/base/grep.html) and [`base::grepl()`](https://rdrr.io/r/base/grep.html), but for ANSI strings

First ANSI sequences will be stripped with
[`ansi_strip()`](https://cli.r-lib.org/dev/reference/ansi_strip.md),
both

## Usage

``` r
ansi_grep(pattern, x, ignore.case = FALSE, perl = FALSE, value = FALSE, ...)

ansi_grepl(pattern, x, ...)
```

## Arguments

- pattern:

  Character scalar, regular expression or fixed string (if
  `fixed = TRUE`), the pattern to search for. Other objects will be
  coerced using
  [`as.character()`](https://rdrr.io/r/base/character.html).

- x:

  Character vector to search in. Other objects will be coerced using
  [`as.character()`](https://rdrr.io/r/base/character.html).

- ignore.case, perl, value:

  Passed to [`base::grep()`](https://rdrr.io/r/base/grep.html).

- ...:

  Extra arguments are passed to
  [`base::grep()`](https://rdrr.io/r/base/grep.html) or
  [`base::grepl()`](https://rdrr.io/r/base/grep.html).

## Value

The same as [`base::grep()`](https://rdrr.io/r/base/grep.html) and
[`base::grepl()`](https://rdrr.io/r/base/grep.html), respectively.

## Details

Note that these functions work on code points (or bytes if
`useBytes = TRUE`), and not graphemes.

Unlike [`base::grep()`](https://rdrr.io/r/base/grep.html) and
[`base::grepl()`](https://rdrr.io/r/base/grep.html) these functions do
not special case factors.

Both `pattern` and `x` are converted to UTF-8.

## Examples

``` r
red_needle <- col_red("needle")
haystack <- c("foo", "needle", "foo")
green_haystack <- col_green(haystack)
ansi_grepl(red_needle, haystack)
#> [1] FALSE  TRUE FALSE
ansi_grepl(red_needle, green_haystack)
#> [1] FALSE  TRUE FALSE
```
