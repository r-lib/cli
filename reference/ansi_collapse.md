# Collapse a vector into a string scalar

Features:

- custom separator (`sep`),

- custom separator for length-two input (`sep2`),

- custom last separator (`last`),

- adds ellipsis to truncated strings,

- uses Unicode ellipsis character on UTF-8 console,

- can collapse "from both ends", with `style = "both-ends"`,

- can consider a limit for the display width of the result, in
  characters,

- handles ANSI control sequences correctly when measuring display width.

## Usage

``` r
ansi_collapse(
  x,
  sep = ", ",
  sep2 = sub("^,", "", last),
  last = ", and ",
  trunc = Inf,
  width = Inf,
  ellipsis = symbol$ellipsis,
  style = c("both-ends", "head")
)
```

## Arguments

- x:

  Character vector, or an object with an
  [`as.character()`](https://rdrr.io/r/base/character.html) method to
  collapse.

- sep:

  Separator. A character string.

- sep2:

  Separator for the special case that `x` contains only two elements. A
  character string. Defaults to the value of `last` without the serial
  comma.

- last:

  Last separator, if there is no truncation. E.g. use `", and "` for the
  [serial comma](https://en.wikipedia.org/wiki/Serial_comma). A
  character string.

- trunc:

  Maximum number of elements to show. For `style = "head"` at least
  `trunc = 1` is used. For `style = "both-ends"` at least `trunc = 5` is
  used, even if a smaller number is specified.

- width:

  Limit for the display width of the result, in characters. This is a
  hard limit, and the output will never exceed it. This argument is not
  implemented for the `"both-ends"` style, which always uses `Inf`, with
  a warning if a finite `width` value is set.

- ellipsis:

  Character string to use at the place of the truncation. By default,
  the Unicode ellipsis character is used if the console is UTF-8, and
  three dots otherwise.

- style:

  Truncation style:

  - `both-ends`: the default, shows the beginning and end of the vector,
    and skips elements in the middle if needed.

  - `head`: shows the beginning of the vector, and skips elements at the
    end, if needed.

## Value

Character scalar. It is `NA_character_` if any elements in `x` are `NA`.

## See also

`glue_collapse` in the glue package inspired this function.

## Examples

``` r
ansi_collapse(letters)
#> [1] "a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, and z"

# truncate
ansi_collapse(letters, trunc = 5)
#> [1] "a, b, c, …, y, and z"

# head style
ansi_collapse(letters, trunc = 5, style = "head")
#> [1] "a, b, c, d, e, …"
```
