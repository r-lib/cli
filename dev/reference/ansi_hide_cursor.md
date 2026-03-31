# Hide/show cursor in a terminal

This only works in terminal emulators. In other environments, it does
nothing.

## Usage

``` r
ansi_hide_cursor(stream = "auto")

ansi_show_cursor(stream = "auto")

ansi_with_hidden_cursor(expr, stream = "auto")
```

## Arguments

- stream:

  The stream to inspect or manipulate, an R connection object. It can
  also be a string, one of `"auto"`, `"message"`, `"stdout"`,
  `"stderr"`. `"auto"` will select
  [`stdout()`](https://rdrr.io/r/base/showConnections.html) if the
  session is interactive and there are no sinks, otherwise it will
  select [`stderr()`](https://rdrr.io/r/base/showConnections.html).

- expr:

  R expression to evaluate.

## Details

`ansi_hide_cursor()` hides the cursor.

`ansi_show_cursor()` shows the cursor.

`ansi_with_hidden_cursor()` temporarily hides the cursor for evaluating
an expression.

## See also

Other terminal capabilities:
[`is_ansi_tty()`](https://cli.r-lib.org/dev/reference/is_ansi_tty.md),
[`is_dynamic_tty()`](https://cli.r-lib.org/dev/reference/is_dynamic_tty.md)

Other low level ANSI functions:
[`ansi_has_any()`](https://cli.r-lib.org/dev/reference/ansi_has_any.md),
[`ansi_regex()`](https://cli.r-lib.org/dev/reference/ansi_regex.md),
[`ansi_string()`](https://cli.r-lib.org/dev/reference/ansi_string.md),
[`ansi_strip()`](https://cli.r-lib.org/dev/reference/ansi_strip.md)
