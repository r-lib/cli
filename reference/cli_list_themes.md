# List the currently active themes

If there is no active app, then it calls
[`start_app()`](https://cli.r-lib.org/reference/start_app.md).

## Usage

``` r
cli_list_themes()
```

## Value

A list of data frames with the active themes. Each data frame row is a
style that applies to selected CLI tree nodes. Each data frame has
columns:

- `selector`: The original CSS-like selector string. See
  [themes](https://cli.r-lib.org/reference/themes.md).

- `parsed`: The parsed selector, as used by cli for matching to nodes.

- `style`: The original style.

- `cnt`: The id of the container the style is currently applied to, or
  `NA` if the style is not used.

## See also

[themes](https://cli.r-lib.org/reference/themes.md)
