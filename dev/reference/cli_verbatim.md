# CLI verbatim text

It is not wrapped, but printed as is. Long lines will overflow. No glue
substitution is performed on verbatim text.

## Usage

``` r
cli_verbatim(..., .envir = parent.frame())
```

## Arguments

- ...:

  The text to show, in character vectors. Each element is printed on a
  new line.

- .envir:

  Environment to evaluate the glue expressions in.

## Details

### Line breaks

    cli_verbatim("This has\nthree\nlines,")

    #> This has
    #> three
    #> lines,

### Special characters

No glue substitution happens here.

    cli_verbatim("No string {interpolation} or {.emph styling} here")

    #> No string {interpolation} or {.emph styling} here

## See also

[`cli_code()`](https://cli.r-lib.org/dev/reference/cli_code.md) for
printing R or other source code.
