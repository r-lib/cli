# Align an ANSI colored string

Align an ANSI colored string

## Usage

``` r
ansi_align(
  text,
  width = console_width(),
  align = c("left", "center", "right"),
  type = "width"
)
```

## Arguments

- text:

  The character vector to align.

- width:

  Width of the field to align in.

- align:

  Whether to align `"left"`, `"center"` or `"right"`.

- type:

  Passed on to
  [`ansi_nchar()`](https://cli.r-lib.org/reference/ansi_nchar.md) and
  there to [`nchar()`](https://rdrr.io/r/base/nchar.html)

## Value

The aligned character vector.

## Details

    str <- c(
      col_red("This is red"),
      style_bold("This is bold")
    )
    astr <- ansi_align(str, width = 30)
    boxx(astr)

    #> ┌────────────────────────────────────┐
    #> │                                    │
    #> │   This is red                      │
    #> │   This is bold                     │
    #> │                                    │
    #> └────────────────────────────────────┘

    str <- c(
      col_red("This is red"),
      style_bold("This is bold")
    )
    astr <- ansi_align(str, align = "center", width = 30)
    boxx(astr)

    #> ┌────────────────────────────────────┐
    #> │                                    │
    #> │             This is red            │
    #> │            This is bold            │
    #> │                                    │
    #> └────────────────────────────────────┘

    str <- c(
      col_red("This is red"),
      style_bold("This is bold")
    )
    astr <- ansi_align(str, align = "right", width = 30)
    boxx(astr)

    #> ┌────────────────────────────────────┐
    #> │                                    │
    #> │                      This is red   │
    #> │                     This is bold   │
    #> │                                    │
    #> └────────────────────────────────────┘

## See also

Other ANSI string operations:
[`ansi_columns()`](https://cli.r-lib.org/reference/ansi_columns.md),
[`ansi_nchar()`](https://cli.r-lib.org/reference/ansi_nchar.md),
[`ansi_strsplit()`](https://cli.r-lib.org/reference/ansi_strsplit.md),
[`ansi_strtrim()`](https://cli.r-lib.org/reference/ansi_strtrim.md),
[`ansi_strwrap()`](https://cli.r-lib.org/reference/ansi_strwrap.md),
[`ansi_substr()`](https://cli.r-lib.org/reference/ansi_substr.md),
[`ansi_substring()`](https://cli.r-lib.org/reference/ansi_substring.md),
[`ansi_toupper()`](https://cli.r-lib.org/reference/ansi_toupper.md),
[`ansi_trimws()`](https://cli.r-lib.org/reference/ansi_trimws.md)
