# Labels a character vector as containing ANSI control codes.

This function sets the class of its argument, activating
ANSI-string-specific methods such as for printing.

## Usage

``` r
ansi_string(x)
```

## Arguments

- x:

  A character vector or something that can be coerced into one.

## Value

A `cli_ansi_string` object, a subclass of `character`, with the same
length and contents as `x`.

## See also

Other low level ANSI functions:
[`ansi_has_any()`](https://cli.r-lib.org/dev/reference/ansi_has_any.md),
[`ansi_hide_cursor()`](https://cli.r-lib.org/dev/reference/ansi_hide_cursor.md),
[`ansi_regex()`](https://cli.r-lib.org/dev/reference/ansi_regex.md),
[`ansi_strip()`](https://cli.r-lib.org/dev/reference/ansi_strip.md)
