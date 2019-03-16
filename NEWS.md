
# devel

* cli has now functions to add ANSI styles to text. These use the crayon
  package internally, and provide a simpler interface. See the `col_*`,
  `bg_*`, `style_*` and also the `make_ansi_style()` and
  `combine_ansi_styles()` functions (#51).

* The crayon package is now an optional dependency. If it cannot be loaded,
  then the cli ANSI styling functions do not add ANSI sequences to the
  text, but otherwise work the same way.

* New is_dynamic_tty() function detects if `\r` should be used for a
  stream (#62).

* Now `symbol` always uses ASCII symbols when the `cli.unicode` option is
  set to `FALSE`.

# 1.0.1

* New `cli_sitrep()` function, situation report about UTF-8 and ANSI
  color support (#53).

* Fall back to ASCII only characters on non-Windows platforms without
  UTF-8 support, and also in LaTeX when running knitr (#34).

# 1.0.0

First public release.
