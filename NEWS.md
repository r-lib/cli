
# cli 2.0.2

* The status bar now does not simplify multiple spaces by a single space.

* cli now does not crash if it fails to detect whether the RStudio theme
  is a dark theme (#138).

* cli now works better with wide Unicode characters, for example emojis.
  In particular, a status bar containing emojis is cleared properly (#133).

* The status bar now does not flicker when updated, in terminals (#135).

# cli 2.0.1

* Symbols (`symbol$*`) are now correctly printed in RStudio on Windows (#124).

* The default theme for `cli_code()` output looks better now, especially
  in RStudio (#123).

* Remove spurious newline after a `cli_process_start()` was cleared
  manually, and also at the end of the function.

* Use Oxford comma when listing 3 or more items (@jonocarroll, #128).

# cli 2.0.0

## Semantic command line interface tools

cli 2.0.0 has a new set of functions that help creating a CLI using a set
of higher level elements: headings, paragraphs, lists, alerts, code blocks,
etc. The formatting of all elements can be customized via themes.
See the "Building a semantic CLI" article on the package web site:
https://cli.r-lib.org

## Bug fixes:

* Fix a bug in `is_dynamic_tty()`, setting `R_CLI_DYNAMIC="FALSE"` now
  properly turns dynamic tty off (#70).

# cli 1.1.0

* cli has now functions to add ANSI styles to text. These use the crayon
  package internally, and provide a simpler interface. See the `col_*`,
  `bg_*`, `style_*` and also the `make_ansi_style()` and
  `combine_ansi_styles()` functions (#51).

* New `is_dynamic_tty()` function detects if `\r` should be used for a
  stream (#62).

* New `is_ansi_tty()` function detects if ANSI control sequences can be
  used for a stream.

* New `ansi_hide_cursor()`, `ansi_show_cursor()` and
  `ansi_with_hidden_cursor()` functions to hide and show the cursor in
  terminals.

* New `make_spinner()` function helps integrating spinners into your
  functions.

* Now `symbol` always uses ASCII symbols when the `cli.unicode` option is
  set to `FALSE`.

# 1.0.1

* New `cli_sitrep()` function, situation report about UTF-8 and ANSI
  color support (#53).

* Fall back to ASCII only characters on non-Windows platforms without
  UTF-8 support, and also in LaTeX when running knitr (#34).

# cli 1.0.0

First public release.
