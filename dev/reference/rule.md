# Make a rule with one or two text labels

The rule can include either a centered text label, or labels on the left
and right side.

To color the labels, use the functions `col_*`, `bg_*` and `style_*`
functions, see [ANSI
styles](https://cli.r-lib.org/dev/reference/ansi-styles.md), and the
examples below. To color the line, either these functions directly, or
the `line_col` option.

## Usage

``` r
rule(
  left = "",
  center = "",
  right = "",
  line = 1,
  col = NULL,
  line_col = col,
  background_col = NULL,
  width = console_width()
)
```

## Arguments

- left:

  Label to show on the left. It interferes with the `center` label, only
  at most one of them can be present.

- center:

  Label to show at the center. It interferes with the `left` and `right`
  labels.

- right:

  Label to show on the right. It interferes with the `center` label,
  only at most one of them can be present.

- line:

  The character or string that is used to draw the line. It can also `1`
  or `2`, to request a single line (Unicode, if available), or a double
  line. Some strings are interpreted specially, see *Line styles* below.

- col:

  Color of text, and default line color. Either an ANSI style function
  (see [ANSI
  styles](https://cli.r-lib.org/dev/reference/ansi-styles.md)), or a
  color name that is passed to
  [`make_ansi_style()`](https://cli.r-lib.org/dev/reference/make_ansi_style.md).

- line_col, background_col:

  Either a color name (used in
  [`make_ansi_style()`](https://cli.r-lib.org/dev/reference/make_ansi_style.md)),
  or a style function (see [ANSI
  styles](https://cli.r-lib.org/dev/reference/ansi-styles.md)), to color
  the line and background.

- width:

  Width of the rule. Defaults to the `width` option, see
  [`base::options()`](https://rdrr.io/r/base/options.html).

## Value

Character scalar, the rule.

## Details

### Simple rule

    rule()

    #> ──────────────────────────────────────────────────────────────────────

### Line styles

Some strings for the `line` argument are interpreted specially:

- `"single"`: (same as `1`), a single line,

- `"double"`: (same as `2`), a double line,

- `"bar1"`, `"bar2"`, `"bar3"`, etc., `"bar8"` uses varying height bars.

#### Double rule

    rule(line = 2)

    #> ══════════════════════════════════════════════════════════════════════

#### Bars

    rule(line = "bar2")
    rule(line = "bar5")

    #> ▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂
    #> ▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅▅

#### Custom lines

    rule(center = "TITLE", line = "~")

    #> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ TITLE ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    rule(center = "TITLE", line = col_blue("~-"))

    #> ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~- TITLE ~-~-~-~-~-~-~-~-~-~-~-~-~-~-~-~

    rule(center = bg_red(" ", symbol$star, "TITLE",
      symbol$star, " "),
      line = "\u2582",
      line_col = "orange")

    #> ▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂  ★TITLE★  ▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂▂

### Left label

    rule(left = "Results")

    #> ── Results ───────────────────────────────────────────────────────────

### Centered label

    rule(center = " * RESULTS * ")

    #> ────────────────────────────  * RESULTS *  ───────────────────────────

### Colored labels

    rule(center = col_red(" * RESULTS * "))

    #> ────────────────────────────  * RESULTS *  ───────────────────────────

### Colored line

    rule(center = col_red(" * RESULTS * "), line_col = "red")

    #> ────────────────────────────  * RESULTS *  ───────────────────────────
