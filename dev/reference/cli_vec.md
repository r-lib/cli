# Add custom cli style to a vector

Add custom cli style to a vector

## Usage

``` r
cli_vec(x, style = list())
```

## Arguments

- x:

  Vector that will be collapsed by cli.

- style:

  Style to apply to the vector. It is used as a theme on a `span`
  element that is created for the vector. You can set `vec-sep`,
  `vec-sep2`, and `vec-last` to modify the general separator, the 2-item
  separator, and the last separator.

## Details

You can use this function to change the default parameters of collapsing
the vector into a string, see an example below.

The style is added as an attribute, so operations that remove attributes
will remove the style as well.

### Custom collapsing separator

    v <- cli_vec(
      c("foo", "bar", "foobar"),
      style = list("vec-sep" = " & ", "vec-last" = " & ")
    )
    cli_text("My list: {v}.")

    #> My list: foo & bar & foobar.

### Custom truncation

    x <- cli_vec(names(mtcars), list("vec-trunc" = 3))
    cli_text("Column names: {x}.")

    #> Column names: mpg, cyl, disp, …, gear, and carb.

## See also

[`cli_format()`](https://cli.r-lib.org/dev/reference/cli_format.md)
