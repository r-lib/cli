# Format a character vector in multiple columns

This function helps with multi-column output of ANSI styles strings. It
works well together with
[`boxx()`](https://cli.r-lib.org/dev/reference/boxx.md), see the example
below.

## Usage

``` r
ansi_columns(
  text,
  width = console_width(),
  sep = " ",
  fill = c("rows", "cols"),
  max_cols = 4,
  align = c("left", "center", "right"),
  type = "width",
  ellipsis = symbol$ellipsis
)
```

## Arguments

- text:

  Character vector to format. Each element will formatted as a cell of a
  table.

- width:

  Width of the screen.

- sep:

  Separator between the columns. It may have ANSI styles.

- fill:

  Whether to fill the columns row-wise or column-wise.

- max_cols:

  Maximum number of columns to use. Will not use more, even if there is
  space for it.

- align:

  Alignment within the columns.

- type:

  Passed to
  [`ansi_nchar()`](https://cli.r-lib.org/dev/reference/ansi_nchar.md)
  and
  [`ansi_align()`](https://cli.r-lib.org/dev/reference/ansi_align.md).
  Most probably you want the default, `"width"`.

- ellipsis:

  The string to append to truncated strings. Supply an empty string if
  you don't want a marker.

## Value

ANSI string vector.

## Details

If a string does not fit into the specified `width`, it will be
truncated using
[`ansi_strtrim()`](https://cli.r-lib.org/dev/reference/ansi_strtrim.md).

    fmt <- ansi_columns(
      paste(col_red("foo"), 1:10),
      width = 50,
      fill = "rows",
      max_cols=10,
      align = "center",
      sep = "   "
    )
    boxx(fmt, padding = c(0,1,0,1), header = col_cyan("Columns"))

    #> ┌ Columns ───────────────────────────────────────────┐
    #> │  foo 1     foo 2     foo 3     foo 4     foo 5     │
    #> │  foo 6     foo 7     foo 8     foo 9     foo 10    │
    #> └────────────────────────────────────────────────────┘

## See also

Other ANSI string operations:
[`ansi_align()`](https://cli.r-lib.org/dev/reference/ansi_align.md),
[`ansi_nchar()`](https://cli.r-lib.org/dev/reference/ansi_nchar.md),
[`ansi_strsplit()`](https://cli.r-lib.org/dev/reference/ansi_strsplit.md),
[`ansi_strtrim()`](https://cli.r-lib.org/dev/reference/ansi_strtrim.md),
[`ansi_strwrap()`](https://cli.r-lib.org/dev/reference/ansi_strwrap.md),
[`ansi_substr()`](https://cli.r-lib.org/dev/reference/ansi_substr.md),
[`ansi_substring()`](https://cli.r-lib.org/dev/reference/ansi_substring.md),
[`ansi_toupper()`](https://cli.r-lib.org/dev/reference/ansi_toupper.md),
[`ansi_trimws()`](https://cli.r-lib.org/dev/reference/ansi_trimws.md)
