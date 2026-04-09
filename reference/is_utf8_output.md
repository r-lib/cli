# Whether cli is emitting UTF-8 characters

UTF-8 cli characters can be turned on by setting the `cli.unicode`
option to `TRUE`. They can be turned off by setting if to `FALSE`. If
this option is not set, then
[`base::l10n_info()`](https://rdrr.io/r/base/l10n_info.html) is used to
detect UTF-8 support.

## Usage

``` r
is_utf8_output()
```

## Value

Flag, whether cli uses UTF-8 characters.
