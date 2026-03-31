# Generic CLI container

See [containers](https://cli.r-lib.org/dev/reference/containers.md). A
`cli_div` container is special, because it may add new themes, that are
valid within the container.

## Usage

``` r
cli_div(
  id = NULL,
  class = NULL,
  theme = NULL,
  .auto_close = TRUE,
  .envir = parent.frame()
)
```

## Arguments

- id:

  Element id, a string. If `NULL`, then a new id is generated and
  returned.

- class:

  Class name, sting. Can be used in themes.

- theme:

  A custom theme for the container. See
  [themes](https://cli.r-lib.org/dev/reference/themes.md).

- .auto_close:

  Whether to close the container, when the calling function finishes (or
  `.envir` is removed, if specified).

- .envir:

  Environment to evaluate the glue expressions in. It is also used to
  auto-close the container if `.auto_close` is `TRUE`.

## Value

The id of the new container element, invisibly.

## Details

### Custom themes

    d <- cli_div(theme = list(h1 = list(color = "cyan",
                                        "font-weight" = "bold")))
    cli_h1("Custom title")
    cli_end(d)

    #>
    #> Custom title

### Auto-closing

By default a `cli_div()` is closed automatically when the calling frame
exits.

    div <- function() {
      cli_div(class = "tmp", theme = list(.tmp = list(color = "yellow")))
      cli_text("This is yellow")
    }
    div()
    cli_text("This is not yellow any more")

    #> This is yellow
    #> This is not yellow any more
