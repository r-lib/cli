# Simplify ANSI styling tags

It creates an equivalent, but possibly shorter ANSI styled string, by
removing duplicate and empty tags.

## Usage

``` r
ansi_simplify(x, csi = c("keep", "drop"))
```

## Arguments

- x:

  Input string

- csi:

  What to do with non-SGR ANSI sequences, either `"keep"`, or `"drop"`
  them.

## Value

Simplified `cli_ansi_string` vector.
