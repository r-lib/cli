# Substring of an UTF-8 string

This function uses grapheme clusters instead of Unicode code points in
UTF-8 strings.

## Usage

``` r
utf8_substr(x, start, stop)
```

## Arguments

- x:

  Character vector.

- start:

  Starting index or indices, recycled to match the length of `x`.

- stop:

  Ending index or indices, recycled to match the length of `x`.

## Value

Character vector of the same length as `x`, containing the requested
substrings.

## See also

Other UTF-8 string manipulation:
[`utf8_graphemes()`](https://cli.r-lib.org/reference/utf8_graphemes.md),
[`utf8_nchar()`](https://cli.r-lib.org/reference/utf8_nchar.md)

## Examples

``` r
# Five grapheme clusters, select the middle three
str <- paste0(
  "\U0001f477\U0001f3ff\u200d\u2640\ufe0f",
  "\U0001f477\U0001f3ff",
  "\U0001f477\u200d\u2640\ufe0f",
  "\U0001f477\U0001f3fb",
  "\U0001f477\U0001f3ff")
cat(str)
#> 👷🏿‍♀️👷🏿👷‍♀️👷🏻👷🏿
str24 <- utf8_substr(str, 2, 4)
cat(str24)
#> 👷🏿👷‍♀️👷🏻
```
