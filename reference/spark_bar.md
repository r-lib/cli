# Draw a sparkline bar graph with unicode block characters

Rendered using [block
elements](https://en.wikipedia.org/wiki/Block_Elements). In most common
fixed width fonts these are rendered wider than regular characters which
means they are not suitable if you need precise alignment.

You might want to avoid sparklines on non-UTF-8 systems, because they do
not look good. You can use
[`is_utf8_output()`](https://cli.r-lib.org/reference/is_utf8_output.md)
to test for support for them.

## Usage

``` r
spark_bar(x)
```

## Arguments

- x:

  A numeric vector between 0 and 1

## Details

    x <- seq(0, 1, length = 6)
    spark_bar(x)

    #> ▁▂▄▅▇█

    x <- seq(0, 1, length = 6)
    spark_bar(sample(x))

    #> ▅▁█▄▇▂

    spark_bar(seq(0, 1, length = 8))

    #> ▁▂▃▄▅▆▇█

`NA`s are left out:

    spark_bar(c(0, NA, 0.5, NA, 1))

    #> ▁ ▄ █

## See also

[`spark_line()`](https://cli.r-lib.org/reference/spark_line.md)
