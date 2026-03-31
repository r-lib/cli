# Debug cli internals

Return the current state of a cli app. It includes the currently open
tags, their ids, classes and their computed styles.

## Usage

``` r
cli_debug_doc(app = default_app() %||% start_app())
```

## Arguments

- app:

  The cli app to debug. Defaults to the current app. if there is no app,
  then it creates one by calling
  [`start_app()`](https://cli.r-lib.org/dev/reference/start_app.md).

## Value

Data frame with columns: `tag`, `id`, `class` (space separated), theme
(id of the theme the element added), `styles` (computed styles for the
element).

## Details

The returned data frame has a print method, and if you want to create a
plain data frame from it, index it with an empty bracket:
`cli_debug_doc()[]`.

To see all currently active themes, use `app$themes`, e.g. for the
default app: `default_app()$themes`.

## See also

[`cli_sitrep()`](https://cli.r-lib.org/dev/reference/cli_sitrep.md). To
debug containers, you can set the `CLI-DEBUG_BAD_END` environment
variable to `true`, and then cli will warn when it cannot find the
specified container to close (or any contained at all).

## Examples

``` r
if (FALSE) { # \dontrun{
cli_debug_doc()

olid <- cli_ol()
cli_li()
cli_debug_doc()
cli_debug_doc()[]

cli_end(olid)
cli_debug_doc()
} # }
```
