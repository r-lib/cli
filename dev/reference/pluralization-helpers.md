# Pluralization helper functions

Pluralization helper functions

## Usage

``` r
no(expr)

qty(expr)
```

## Arguments

- expr:

  For `no()` it is an expression that is printed as "no" in cli
  expressions, it is interpreted as a zero quantity. For `qty()` an
  expression that sets the pluralization quantity without printing
  anything. See examples below.

## See also

Other pluralization:
[`pluralization`](https://cli.r-lib.org/dev/reference/pluralization.md),
[`pluralize()`](https://cli.r-lib.org/dev/reference/pluralize.md)

## Examples

``` r
nfile <- 0; cli_text("Found {no(nfile)} file{?s}.")
#> Found no files.

#> Found no files.

nfile <- 1; cli_text("Found {no(nfile)} file{?s}.")
#> Found 1 file.

#> Found 1 file.

nfile <- 2; cli_text("Found {no(nfile)} file{?s}.")
#> Found 2 files.

#> Found 2 files.
```
