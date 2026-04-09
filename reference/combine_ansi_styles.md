# Combine two or more ANSI styles

Combine two or more styles or style functions into a new style function
that can be called on strings to style them.

## Usage

``` r
combine_ansi_styles(...)
```

## Arguments

- ...:

  The styles to combine. For character strings, the
  [`make_ansi_style()`](https://cli.r-lib.org/reference/make_ansi_style.md)
  function is used to create a style first. They will be applied from
  right to left.

## Value

The combined style function.

## Details

It does not usually make sense to combine two foreground colors (or two
background colors), because only the first one applied will be used.

It does make sense to combine different kind of styles, e.g. background
color, foreground color, bold font.

## See also

Other ANSI styling:
[`ansi-styles`](https://cli.r-lib.org/reference/ansi-styles.md),
[`make_ansi_style()`](https://cli.r-lib.org/reference/make_ansi_style.md),
[`num_ansi_colors()`](https://cli.r-lib.org/reference/num_ansi_colors.md)

## Examples

``` r
## Use style names
alert <- combine_ansi_styles("bold", "red4")
cat(alert("Warning!"), "\n")
#> Warning! 

## Or style functions
alert <- combine_ansi_styles(style_bold, col_red, bg_cyan)
cat(alert("Warning!"), "\n")
#> Warning! 

## Combine a composite style
alert <- combine_ansi_styles(
  "bold",
  combine_ansi_styles("red", bg_cyan))
cat(alert("Warning!"), "\n")
#> Warning! 
```
