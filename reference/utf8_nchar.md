# Count the number of characters in a character vector

By default it counts Unicode grapheme clusters, instead of code points.

## Usage

``` r
utf8_nchar(x, type = c("chars", "bytes", "width", "graphemes", "codepoints"))
```

## Arguments

- x:

  Character vector, it is converted to UTF-8.

- type:

  Whether to count graphemes (characters), code points, bytes, or
  calculate the display width of the string.

## Value

Numeric vector, the length of the strings in the character vector.

## See also

Other UTF-8 string manipulation:
[`utf8_graphemes()`](https://cli.r-lib.org/reference/utf8_graphemes.md),
[`utf8_substr()`](https://cli.r-lib.org/reference/utf8_substr.md)

## Examples

``` r
# Grapheme example, emoji with combining characters. This is a single
# grapheme, consisting of five Unicode code points:
# * `\U0001f477` is the construction worker emoji
# * `\U0001f3fb` is emoji modifier that changes the skin color
# * `\u200d` is the zero width joiner
# * `\u2640` is the female sign
# * `\ufe0f` is variation selector 16, requesting an emoji style glyph
emo <- "\U0001f477\U0001f3fb\u200d\u2640\ufe0f"
cat(emo)
#> 👷🏻‍♀️

utf8_nchar(emo, "chars") # = graphemes
#> [1] 1
utf8_nchar(emo, "bytes")
#> [1] 17
utf8_nchar(emo, "width")
#> [1] 2
utf8_nchar(emo, "codepoints")
#> [1] 5

# For comparison, the output for width depends on the R version used:
nchar(emo, "chars")
#> [1] 5
nchar(emo, "bytes")
#> [1] 17
nchar(emo, "width")
#> [1] 5
```
