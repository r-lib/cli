# Like [`base::nzchar()`](https://rdrr.io/r/base/nchar.html), but for ANSI strings

Like [`base::nzchar()`](https://rdrr.io/r/base/nchar.html), but for ANSI
strings

## Usage

``` r
ansi_nzchar(x, ...)
```

## Arguments

- x:

  Character vector. Other objects are coerced using
  [`base::as.character()`](https://rdrr.io/r/base/character.html).

- ...:

  Passed to [`base::nzchar()`](https://rdrr.io/r/base/nchar.html).

## Examples

``` r
ansi_nzchar("")
#> [1] FALSE
ansi_nzchar(col_red(""))
#> [1] FALSE
```
