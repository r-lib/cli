# A block of code

A helper function that creates a `div` with class `code` and then calls
[`cli_verbatim()`](https://cli.r-lib.org/dev/reference/cli_verbatim.md)
to output code lines. The builtin theme formats these containers
specially. In particular, it adds syntax highlighting to valid R code.

## Usage

``` r
cli_code(
  lines = NULL,
  ...,
  language = "R",
  .auto_close = TRUE,
  .envir = environment()
)
```

## Arguments

- lines:

  Character vector, each line will be a line of code, and newline
  characters also create new lines. Note that *no* glue substitution is
  performed on the code.

- ...:

  More character vectors, they are appended to `lines`.

- language:

  Programming language. This is also added as a class, in addition to
  `code`.

- .auto_close:

  Passed to
  [`cli_div()`](https://cli.r-lib.org/dev/reference/cli_div.md) when
  creating the container of the code. By default the code container is
  closed after emitting `lines` and `...` via
  [`cli_verbatim()`](https://cli.r-lib.org/dev/reference/cli_verbatim.md).
  You can keep that container open with `.auto_close` and/or `.envir`,
  and then calling
  [`cli_verbatim()`](https://cli.r-lib.org/dev/reference/cli_verbatim.md)
  to add (more) code. Note that the code will be formatted and syntax
  highlighted separately for each
  [`cli_verbatim()`](https://cli.r-lib.org/dev/reference/cli_verbatim.md)
  call.

- .envir:

  Passed to
  [`cli_div()`](https://cli.r-lib.org/dev/reference/cli_div.md) when
  creating the container of the code.

## Value

The id of the container that contains the code.

## Details

    myfun <- function() {
      message("Just an example function")
      graphics::pairs(iris, col = 1:4)
    }
    cli_code(format(myfun))

    #> function ()
    #> {
    #>     message("Just an example function")
    #>     graphics::pairs(iris, col = 1:4)
    #> }
