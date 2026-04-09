# Terminal Hyperlinks

`ansi_hyperlink()` creates an ANSI hyperlink.

## Usage

``` r
style_hyperlink(text, url, params = NULL)

ansi_has_hyperlink_support()

ansi_hyperlink_types()
```

## Arguments

- text:

  Text to show. `text` and `url` are recycled to match their length, via
  a [`paste0()`](https://rdrr.io/r/base/paste.html) call.

- url:

  URL to link to.

- params:

  A named character vector of additional parameters, or `NULL`.

## Value

Styled `cli_ansi_string` for `style_hyperlink()`. Logical scalar for
`ansi_has_hyperlink_support()`.

## Details

This function is currently experimental. In particular, many of the
`ansi_*()` functions do not support it properly.

`ansi_has_hyperlink_support()` checks if the current
[`stdout()`](https://rdrr.io/r/base/showConnections.html) supports
hyperlinks.

See also
<https://gist.github.com/egmontkob/eb114294efbcd5adb1944c9f3cb5feda>.

`ansi_hyperlink_types()` checks if current
[`stdout()`](https://rdrr.io/r/base/showConnections.html) supports
various types of hyperlinks. It returns a list with entries `href`,
`run`, `help` and `vignettes`.

## Examples

``` r
cat("This is an", style_hyperlink("R", "https://r-project.org"), "link.\n")
#> This is an R link.
ansi_has_hyperlink_support()
#> [1] FALSE
```
