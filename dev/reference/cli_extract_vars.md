# Extract variable and function names from cli format strings

Parses cli [inline
markup](https://cli.r-lib.org/dev/reference/inline-markup.md) and glue
substitutions in `text` without evaluating the embedded R expressions,
returning the symbol names referenced inside `{...}` interpolation
blocks via [`base::all.vars()`](https://rdrr.io/r/base/allnames.html).

## Usage

``` r
cli_extract_vars(text, functions = TRUE, unique = TRUE)
```

## Arguments

- text:

  Character vector of cli format strings.

- functions:

  Logical scalar passed to
  [`base::all.vars()`](https://rdrr.io/r/base/allnames.html): whether to
  include function names in addition to variable names. Defaults to
  `TRUE`.

- unique:

  Logical scalar passed to
  [`base::all.vars()`](https://rdrr.io/r/base/allnames.html): whether to
  deduplicate extracted symbol names. Defaults to `TRUE`.

## Value

Character vector of extracted symbol names.

## Details

Static analysis tools (such as `lintr::object_usage_linter()`) can use
`cli_extract_vars()` to discover variables and functions referenced in
cli calls. Malformed cli strings or R expressions signal an error of
class `"cli_error"` (with subclasses `"cli_glue_error"`,
`"cli_style_error"`, `"cli_parse_error"`, and
`"cli_pluralization_error"`), so static analysis callers should wrap
`cli_extract_vars()` in
[`base::tryCatch()`](https://rdrr.io/r/base/conditions.html).

If `text` is a named character vector (for example, as passed to
[`cli_dl()`](https://cli.r-lib.org/dev/reference/cli_dl.md),
[`cli_li()`](https://cli.r-lib.org/dev/reference/cli_li.md),
[`cli_bullets()`](https://cli.r-lib.org/dev/reference/cli_bullets.md),
or [`cli_abort()`](https://cli.r-lib.org/dev/reference/cli_abort.md)),
both `names(text)` and `text` are inspected.

## Examples

``` r
cli_extract_vars(
  "{.arg x} has {length(x)} elements, but it should be {.emph {length(y)}}"
)
#> [1] "length" "x"      "y"     
cli_extract_vars(
  "{.arg x} has {length(x)} elements, but it should be {.emph {length(y)}}",
  functions = FALSE
)
#> [1] "x" "y"
```
