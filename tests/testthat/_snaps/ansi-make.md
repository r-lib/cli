# errors

    Code
      make_ansi_style(1:10)
    Condition
      Error:
      ! `style` must be an ANSI style
      i an ANSI style is a character scalar (cli style name, RGB or R color name), or a [3x1] or [4x1] numeric RGB matrix
      i `style` is an integer vector

# make_ansi_style

    Code
      make_ansi_style(1:10)
    Condition
      [1m[33mError[39m:[22m
      [33m![39m [1m[22m`style` must be an ANSI style
      [36mi[39m an ANSI style is a character scalar (cli style name, RGB or R color name), or a [3x1] or [4x1] numeric RGB matrix
      [36mi[39m `style` is an integer vector

---

    Code
      make_ansi_style("foobar")
    Condition
      [1m[33mError[39m:[22m
      [33m![39m [1m[22mUnknown style specification: [34m"style"[39m, it must be one of
      [36m*[39m a builtin cli style, e.g. [34m"bold"[39m or [34m"red"[39m,
      [36m*[39m an R color name, see `?grDevices::colors()`.
      [36m*[39m a [3x1] or [4x1] numeric RGB matrix with, range 0-255.

