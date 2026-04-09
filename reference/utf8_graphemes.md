# Break an UTF-8 character vector into grapheme clusters

Break an UTF-8 character vector into grapheme clusters

## Usage

``` r
utf8_graphemes(x)
```

## Arguments

- x:

  Character vector.

## Value

List of characters vectors, the grapheme clusters of the input string.

## See also

Other UTF-8 string manipulation:
[`utf8_nchar()`](https://cli.r-lib.org/reference/utf8_nchar.md),
[`utf8_substr()`](https://cli.r-lib.org/reference/utf8_substr.md)

## Examples

``` r
# Five grapheme clusters
str <- paste0(
  "\U0001f477\U0001f3ff\u200d\u2640\ufe0f",
  "\U0001f477\U0001f3ff",
  "\U0001f477\u200d\u2640\ufe0f",
  "\U0001f477\U0001f3fb",
  "\U0001f477\U0001f3ff")
cat(str, "\n")
#> 👷🏿‍♀️👷🏿👷‍♀️👷🏻👷🏿 
chrs <- utf8_graphemes(str)
```
