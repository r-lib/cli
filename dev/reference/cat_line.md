# `cat()` helpers

These helpers provide useful wrappers around
[`cat()`](https://rdrr.io/r/base/cat.html): most importantly they all
set `sep = ""`, and `cat_line()` automatically adds a newline.

## Usage

``` r
cat_line(..., col = NULL, background_col = NULL, file = stdout())

cat_bullet(
  ...,
  col = NULL,
  background_col = NULL,
  bullet = "bullet",
  bullet_col = NULL,
  file = stdout()
)

cat_boxx(..., file = stdout())

cat_rule(..., file = stdout())

cat_print(x, file = "")
```

## Arguments

- ...:

  For `cat_line()` and `cat_bullet()`, pasted together with
  `collapse = "\n"`. For `cat_rule()` and `cat_boxx()` passed on to
  [`rule()`](https://cli.r-lib.org/dev/reference/rule.md) and
  [`boxx()`](https://cli.r-lib.org/dev/reference/boxx.md) respectively.

- col, background_col, bullet_col:

  Colors for text, background, and bullets respectively.

- file:

  Output destination. Defaults to standard output.

- bullet:

  Name of bullet character. Indexes into
  [symbol](https://cli.r-lib.org/dev/reference/symbol.md)

- x:

  An object to print.

## Examples

``` r
cat_line("This is ", "a ", "line of text.", col = "red")
#> This is a line of text.
cat_bullet(letters[1:5])
#> • a
#> • b
#> • c
#> • d
#> • e
cat_bullet(letters[1:5], bullet = "tick", bullet_col = "green")
#> ✔ a
#> ✔ b
#> ✔ c
#> ✔ d
#> ✔ e
cat_rule()
#> ───────────────────────────────────────────────────────────────────────
```
