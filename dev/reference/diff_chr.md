# Compare two character vectors elementwise

Its printed output is similar to calling `diff -u` at the command line.

## Usage

``` r
diff_chr(old, new, max_dist = Inf)
```

## Arguments

- old:

  First character vector.

- new:

  Second character vector.

- max_dist:

  Maximum distance to consider, or `Inf` for no limit. If the LCS edit
  distance is larger than this, then the function throws an error with
  class `"cli_diff_max_dist"`. (If you specify `Inf` the real limit is
  `.Machine$integer.max` but to reach this the function would have to
  run a very long time.)

## Value

A list that is a `cli_diff_chr` object, with a
[`format()`](https://rdrr.io/r/base/format.html) and a
[`print()`](https://rdrr.io/r/base/print.html) method. You can also
access its members:

- `old` and `new` are the original inputs,

- `lcs` is a data frame of LCS edit that transform `old` into `new`.

The `lcs` data frame has the following columns:

- `operation`: one of `"match"`, `"delete"` or `"insert"`.

- `offset`: offset in `old` for matches and deletions, offset in `new`
  for insertions.

- `length`: length of the operation, i.e. number of matching, deleted or
  inserted elements.

- `old_offset`: offset in `old` *after* the operation.

- `new_offset`: offset in `new` *after* the operation.

## See also

The diffobj package for a much more comprehensive set of `diff`-like
tools.

Other diff functions in cli:
[`diff_str()`](https://cli.r-lib.org/dev/reference/diff_str.md)

## Examples

``` r
letters2 <- c("P", "R", "E", letters, "P", "O", "S", "T")
letters2[11:16] <- c("M", "I", "D", "D", "L", "E")
diff_chr(letters, letters2)
#> @@ -1,3 +1,6 @@
#> +P
#> +R
#> +E
#>  a
#>  b
#>  c
#> @@ -5,12 +8,12 @@
#>  e
#>  f
#>  g
#> -h
#> -i
#> -j
#> -k
#> -l
#> -m
#> +M
#> +I
#> +D
#> +D
#> +L
#> +E
#>  n
#>  o
#>  p
#> @@ -24,3 +27,7 @@
#>  x
#>  y
#>  z
#> +P
#> +O
#> +S
#> +T
```
