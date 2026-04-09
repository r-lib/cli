# Compare two character strings, character by character

Characters are defined by UTF-8 graphemes.

## Usage

``` r
diff_str(old, new, max_dist = Inf)
```

## Arguments

- old:

  First string, must not be `NA`.

- new:

  Second string, must not be `NA`.

- max_dist:

  Maximum distance to consider, or `Inf` for no limit. If the LCS edit
  distance is larger than this, then the function throws an error with
  class `"cli_diff_max_dist"`. (If you specify `Inf` the real limit is
  `.Machine$integer.max` but to reach this the function would have to
  run a very long time.)

## Value

A list that is a `cli_diff_str` object and also a `cli_diff_chr` object,
see diff_str for the details about its structure.

## See also

The diffobj package for a much more comprehensive set of `diff`-like
tools.

Other diff functions in cli:
[`diff_chr()`](https://cli.r-lib.org/reference/diff_chr.md)

## Examples

``` r
str1 <- "abcdefghijklmnopqrstuvwxyz"
str2 <- "PREabcdefgMIDDLEnopqrstuvwxyzPOST"
diff_str(str1, str2)
#> PREabcdefghijklmMIDDLEnopqrstuvwxyzPOST
```
