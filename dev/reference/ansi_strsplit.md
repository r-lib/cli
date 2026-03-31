# Split an ANSI colored string

This is the color-aware counterpart of
[`base::strsplit()`](https://rdrr.io/r/base/strsplit.html). It works
almost exactly like the original, but keeps the colors in the
substrings.

## Usage

``` r
ansi_strsplit(x, split, ...)
```

## Arguments

- x:

  Character vector, potentially ANSI styled, or a vector to coerced to
  character.

- split:

  Character vector of length 1 (or object which can be coerced to such)
  containing regular expression(s) (unless `fixed = TRUE`) to use for
  splitting. If empty matches occur, in particular if `split` has zero
  characters, `x` is split into single characters.

- ...:

  Extra arguments are passed to
  [`base::strsplit()`](https://rdrr.io/r/base/strsplit.html).

## Value

A list of the same length as `x`, the `i`-th element of which contains
the vector of splits of `x[i]`. ANSI styles are retained.

## See also

Other ANSI string operations:
[`ansi_align()`](https://cli.r-lib.org/dev/reference/ansi_align.md),
[`ansi_columns()`](https://cli.r-lib.org/dev/reference/ansi_columns.md),
[`ansi_nchar()`](https://cli.r-lib.org/dev/reference/ansi_nchar.md),
[`ansi_strtrim()`](https://cli.r-lib.org/dev/reference/ansi_strtrim.md),
[`ansi_strwrap()`](https://cli.r-lib.org/dev/reference/ansi_strwrap.md),
[`ansi_substr()`](https://cli.r-lib.org/dev/reference/ansi_substr.md),
[`ansi_substring()`](https://cli.r-lib.org/dev/reference/ansi_substring.md),
[`ansi_toupper()`](https://cli.r-lib.org/dev/reference/ansi_toupper.md),
[`ansi_trimws()`](https://cli.r-lib.org/dev/reference/ansi_trimws.md)

## Examples

``` r
str <- paste0(
  col_red("I am red---"),
  col_green("and I am green-"),
  style_underline("I underlined")
)

cat(str, "\n")
#> I am red---and I am green-I underlined 

# split at dashes, keep color
cat(ansi_strsplit(str, "[-]+")[[1]], sep = "\n")
#> I am red
#> and I am green
#> I underlined
strsplit(ansi_strip(str), "[-]+")
#> [[1]]
#> [1] "I am red"       "and I am green" "I underlined"  
#> 

# split to characters, keep color
cat(ansi_strsplit(str, "")[[1]], "\n", sep = " ")
#> I   a m   r e d - - - a n d   I   a m   g r e e n - I   u n d e r l i n e d 
strsplit(ansi_strip(str), "")
#> [[1]]
#>  [1] "I" " " "a" "m" " " "r" "e" "d" "-" "-" "-" "a" "n" "d" " " "I"
#> [17] " " "a" "m" " " "g" "r" "e" "e" "n" "-" "I" " " "u" "n" "d" "e"
#> [33] "r" "l" "i" "n" "e" "d"
#> 
```
