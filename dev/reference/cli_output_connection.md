# The connection option that cli would use

Note that this only refers to the current R process. If the output is
produced in another process, then it is not relevant.

## Usage

``` r
cli_output_connection()
```

## Value

Connection object.

## Details

In interactive sessions the standard output is chosen, otherwise the
standard error is used. This is to avoid painting output messages red in
the R GUIs.
