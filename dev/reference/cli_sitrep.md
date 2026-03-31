# cli situation report

Contains currently:

- `cli_unicode_option`: whether the `cli.unicode` option is set and its
  value. See
  [`is_utf8_output()`](https://cli.r-lib.org/dev/reference/is_utf8_output.md).

- `symbol_charset`: the selected character set for
  [symbol](https://cli.r-lib.org/dev/reference/symbol.md), UTF-8,
  Windows, or ASCII.

- `console_utf8`: whether the console supports UTF-8. See
  [`base::l10n_info()`](https://rdrr.io/r/base/l10n_info.html).

- `latex_active`: whether we are inside knitr, creating a LaTeX
  document.

- `num_colors`: number of ANSI colors. See
  [`num_ansi_colors()`](https://cli.r-lib.org/dev/reference/num_ansi_colors.md).

- `console_with`: detected console width.

## Usage

``` r
cli_sitrep()
```

## Value

Named list with entries listed above. It has a `cli_sitrep` class, with
a [`print()`](https://rdrr.io/r/base/print.html) and
[`format()`](https://rdrr.io/r/base/format.html) method.

## Examples

``` r
cli_sitrep()
#> - cli_unicode_option : NULL
#> - symbol_charset     : UTF-8
#> - console_utf8       : TRUE
#> - latex_active       : FALSE
#> - num_colors         : 256
#> - console_width      : 71
```
