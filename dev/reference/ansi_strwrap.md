# Wrap an ANSI styled string to a certain width

This function is similar to
[`base::strwrap()`](https://rdrr.io/r/base/strwrap.html), but works on
ANSI styled strings, and leaves the styling intact.

## Usage

``` r
ansi_strwrap(
  x,
  width = console_width(),
  indent = 0,
  exdent = 0,
  simplify = TRUE
)
```

## Arguments

- x:

  ANSI string.

- width:

  Width to wrap to.

- indent:

  Indentation of the first line of each paragraph.

- exdent:

  Indentation of the subsequent lines of each paragraph.

- simplify:

  Whether to return all wrapped strings in a single character vector, or
  wrap each element of `x` independently and return a list.

## Value

If `simplify` is `FALSE`, then a list of character vectors, each an ANSI
string. Otherwise a single ANSI string vector.

## See also

Other ANSI string operations:
[`ansi_align()`](https://cli.r-lib.org/dev/reference/ansi_align.md),
[`ansi_columns()`](https://cli.r-lib.org/dev/reference/ansi_columns.md),
[`ansi_nchar()`](https://cli.r-lib.org/dev/reference/ansi_nchar.md),
[`ansi_strsplit()`](https://cli.r-lib.org/dev/reference/ansi_strsplit.md),
[`ansi_strtrim()`](https://cli.r-lib.org/dev/reference/ansi_strtrim.md),
[`ansi_substr()`](https://cli.r-lib.org/dev/reference/ansi_substr.md),
[`ansi_substring()`](https://cli.r-lib.org/dev/reference/ansi_substring.md),
[`ansi_toupper()`](https://cli.r-lib.org/dev/reference/ansi_toupper.md),
[`ansi_trimws()`](https://cli.r-lib.org/dev/reference/ansi_trimws.md)

## Examples

``` r
text <- cli:::lorem_ipsum()
# Highlight some words, that start with 's'
rexp <- gregexpr("\\b([sS][a-zA-Z]+)\\b", text)
regmatches(text, rexp) <- lapply(regmatches(text, rexp), col_red)
cat(text)
#> Mollit adipisicing laborum Lorem non eu velit sint deserunt amet Lorem qui culpa. Laboris dolore cupidatat laborum incididunt. Cupidatat duis in amet sit. Incididunt labore aute esse est ipsum cillum commodo qui minim ut veniam laborum nostrud nostrud. Reprehenderit irure nostrud duis esse quis nisi aliquip ipsum minim duis fugiat ea. Dolore consectetur non cupidatat officia Lorem elit. Ad aliqua aute pariatur anim ex culpa Lorem. Mollit magna sint pariatur non quis do duis non sint elit ullamco exercitation consectetur aliqua. Nostrud laborum deserunt adipisicing tempor amet qui duis. Mollit non aliquip ea sunt quis tempor dolore esse.

wrp <- ansi_strwrap(text, width = 40)
cat(wrp, sep = "\n")
#> Mollit adipisicing laborum Lorem non eu
#> velit sint deserunt amet Lorem qui
#> culpa. Laboris dolore cupidatat laborum
#> incididunt. Cupidatat duis in amet sit.
#> Incididunt labore aute esse est ipsum
#> cillum commodo qui minim ut veniam
#> laborum nostrud nostrud. Reprehenderit
#> irure nostrud duis esse quis nisi
#> aliquip ipsum minim duis fugiat ea.
#> Dolore consectetur non cupidatat
#> officia Lorem elit. Ad aliqua aute
#> pariatur anim ex culpa Lorem. Mollit
#> magna sint pariatur non quis do duis
#> non sint elit ullamco exercitation
#> consectetur aliqua. Nostrud laborum
#> deserunt adipisicing tempor amet qui
#> duis. Mollit non aliquip ea sunt quis
#> tempor dolore esse.
```
