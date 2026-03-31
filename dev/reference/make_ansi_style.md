# Create a new ANSI style

Create a function that can be used to add ANSI styles to text.

## Usage

``` r
make_ansi_style(..., bg = FALSE, grey = FALSE, colors = num_ansi_colors())
```

## Arguments

- ...:

  The style to create. See details and examples below.

- bg:

  Whether the color applies to the background.

- grey:

  Whether to specifically create a grey color. This flag is included,
  because ANSI 256 has a finer color scale for greys, then the usual 0:5
  scale for red, green and blue components. It is only used for RGB
  color specifications (either numerically or via a hexadecimal string),
  and it is ignored on eight color ANSI terminals.

- colors:

  Number of colors, detected automatically by default.

## Value

A function that can be used to color (style) strings.

## Details

The `...` style argument can be any of the following:

- A cli ANSI style function of class `cli_ansi_style`. This is returned
  as is, without looking at the other arguments.

- An R color name, see
  [`grDevices::colors()`](https://rdrr.io/r/grDevices/colors.html).

- A 6- or 8-digit hexadecimal color string, e.g. `#ff0000` means red.
  Transparency (alpha channel) values are ignored.

- A one-column matrix with three rows for the red, green and blue
  channels, as returned by
  [`grDevices::col2rgb()`](https://rdrr.io/r/grDevices/col2rgb.html).

`make_ansi_style()` detects the number of colors to use automatically
(this can be overridden using the `colors` argument). If the number of
colors is less than 256 (detected or given), then it falls back to the
color in the ANSI eight color mode that is closest to the specified (RGB
or R) color.

## See also

Other ANSI styling:
[`ansi-styles`](https://cli.r-lib.org/dev/reference/ansi-styles.md),
[`combine_ansi_styles()`](https://cli.r-lib.org/dev/reference/combine_ansi_styles.md),
[`num_ansi_colors()`](https://cli.r-lib.org/dev/reference/num_ansi_colors.md)

## Examples

``` r
make_ansi_style("orange")
#> <cli_ansi_style>
#> Example output
make_ansi_style("#123456")
#> <cli_ansi_style>
#> Example output
make_ansi_style("orange", bg = TRUE)
#> <cli_ansi_style>
#> Example output

orange <- make_ansi_style("orange")
orange("foobar")
#> <cli_ansi_string>
#> [1] foobar
cat(orange("foobar"))
#> foobar
```
