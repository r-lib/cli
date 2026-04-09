# Convert ANSI styled text to HTML

Convert ANSI styled text to HTML

## Usage

``` r
ansi_html(x, escape_reserved = TRUE, csi = c("drop", "keep"))
```

## Arguments

- x:

  Input character vector.

- escape_reserved:

  Whether to escape characters that are reserved in HTML (`&`, `<` and
  `>`).

- csi:

  What to do with non-SGR ANSI sequences, either `"keep"`, or `"drop"`
  them.

## Value

Character vector of HTML.

## See also

Other ANSI to HTML conversion:
[`ansi_html_style()`](https://cli.r-lib.org/reference/ansi_html_style.md)

## Examples

``` r
## Syntax highlight the source code of an R function with ANSI tags,
## and export it to a HTML file.
code <- withr::with_options(
  list(ansi.num_colors = 256),
  code_highlight(format(ansi_html))
)
hcode <- paste(ansi_html(code), collapse = "\n")
css <- paste(format(ansi_html_style()), collapse=  "\n")
page <- htmltools::tagList(
  htmltools::tags$head(htmltools::tags$style(css)),
  htmltools::tags$pre(htmltools::HTML(hcode))
)

if (interactive()) htmltools::html_print(page)
```
