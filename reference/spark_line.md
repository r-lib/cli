# Draw a sparkline line graph with Braille characters.

You might want to avoid sparklines on non-UTF-8 systems, because they do
not look good. You can use
[`is_utf8_output()`](https://cli.r-lib.org/reference/is_utf8_output.md)
to test for support for them.

## Usage

``` r
spark_line(x)
```

## Arguments

- x:

  A numeric vector between 0 and 1

## Details

    x <- seq(0, 1, length = 10)
    spark_line(x)

    #> ⣀⡠⠔⠊⠉

## See also

[`spark_bar()`](https://cli.r-lib.org/reference/spark_bar.md)
