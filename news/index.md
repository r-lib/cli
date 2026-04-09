# Changelog

## cli 3.6.6

CRAN release: 2026-04-09

- New `{.num}` and `{.bytes}` inline styles to format numbers and bytes
  ([@m-muecke](https://github.com/m-muecke),
  [\#644](https://github.com/r-lib/cli/issues/644),
  [\#588](https://github.com/r-lib/cli/issues/588),
  [\#643](https://github.com/r-lib/cli/issues/643)).

## cli 3.6.5

CRAN release: 2025-04-23

- [`code_highlight()`](https://cli.r-lib.org/reference/code_highlight.md)
  supports long strings and symbols
  ([\#727](https://github.com/r-lib/cli/issues/727)
  [@moodymudskipper](https://github.com/moodymudskipper)).

## cli 3.6.4

CRAN release: 2025-02-13

- Pluralization now handles edge cases (`NA`, `NaN`, `Inf` and `-Inf`)
  better ([@rundel](https://github.com/rundel),
  [\#716](https://github.com/r-lib/cli/issues/716)).

- The URI generated for `.file`, `.run`, `.help` and `.vignette`
  hyperlinks can now be configured via options and env vars
  ([@jennybc](https://github.com/jennybc),
  [\#739](https://github.com/r-lib/cli/issues/739),
  [\#744](https://github.com/r-lib/cli/issues/744)).

- [`cli_progress_bar()`](https://cli.r-lib.org/reference/cli_progress_bar.md)
  now accepts `total` = Inf or -Inf which mimics the behavior of when
  `total` is NA ([@LouisMPenrod](https://github.com/LouisMPenrod),
  [\#630](https://github.com/r-lib/cli/issues/630)).

- [`num_ansi_colors()`](https://cli.r-lib.org/reference/num_ansi_colors.md)
  now does not warn in Emacs if the `INSIDE_EMACS` environment variable
  is not a proper version number ([@rundel](https://github.com/rundel),
  [\#689](https://github.com/r-lib/cli/issues/689)).

- [`ansi_collapse()`](https://cli.r-lib.org/reference/ansi_collapse.md)
  and inline collapsing now uses `last` as the separator (without the
  serial comma) for two-element vectors if `sep2` is not given
  ([@rundel](https://github.com/rundel),
  [\#681](https://github.com/r-lib/cli/issues/681)).

- [`ansi_collapse()`](https://cli.r-lib.org/reference/ansi_collapse.md)
  is now correct for length-1 vectors with style “head” if width is
  specified ([@rundel](https://github.com/rundel),
  [\#590](https://github.com/r-lib/cli/issues/590)).

- New [`hash_xxhash()`](https://cli.r-lib.org/reference/hash_xxhash.md)
  etc. functions to calculate the xxHash of strings, raw vectors,
  objects, files.

## cli 3.6.3

CRAN release: 2024-06-21

- cli now builds on ARM Windows.

- “Solarized Dark” is now the default syntax highlighting theme in
  terminals.

- The `{.obj_type_friendly}` inline style now only shows the first class
  name ([\#669](https://github.com/r-lib/cli/issues/669)
  [@olivroy](https://github.com/olivroy)).

- Syntax highlighting now does not fail in RStudio if the rstudioapi
  package is not installed
  ([\#697](https://github.com/r-lib/cli/issues/697)).

## cli 3.6.2

CRAN release: 2023-12-11

- `ansi_collapse(x, trunc = 1, style = "head")` now indeed shows one
  element if `length(x) == 2`, as documented
  ([@salim-b](https://github.com/salim-b),
  [\#572](https://github.com/r-lib/cli/issues/572)).

- [`ansi_collapse()`](https://cli.r-lib.org/reference/ansi_collapse.md)
  gains a `sep2` argument to specify a separate separator for length-two
  inputs. It defaults to `" and "` which, in conjunction with the other
  defaults, produces a collapsed string that fully adheres to the
  [serial comma](https://en.wikipedia.org/wiki/Serial_comma) rules.
  ([@salim-b](https://github.com/salim-b),
  [\#569](https://github.com/r-lib/cli/issues/569))

- [`ansi_string()`](https://cli.r-lib.org/reference/ansi_string.md) is
  now an exported function
  ([@multimeric](https://github.com/multimeric),
  [\#573](https://github.com/r-lib/cli/issues/573)).

## cli 3.6.1

CRAN release: 2023-03-23

- ANSI hyperlinks are now turned off on the RStudio render plane
  ([\#581](https://github.com/r-lib/cli/issues/581)).

## cli 3.6.0

CRAN release: 2023-01-09

- The progressr progress handler now reports progress correctly
  ([@HenrikBengtsson](https://github.com/HenrikBengtsson),
  [\#558](https://github.com/r-lib/cli/issues/558)).

- New `hash_*sha1()` functions to calculate the SHA-1 hash of strings,
  objects, files.

- cli now shows progress bars after one second by default, if they are
  less than half way at the point. (Or after two seconds,
  unconditionally, as before.) See the the `cli.progress_show_after`
  option in
  [`?"cli-config"`](https://cli.r-lib.org/reference/cli-config.md) for
  details ([\#542](https://github.com/r-lib/cli/issues/542)).

- [`format_inline()`](https://cli.r-lib.org/reference/format_inline.md)
  now has a new argument `keep_whitespace`, and it keeps whitespace,
  including newline and form feed characters by default.

## cli 3.5.0

CRAN release: 2022-12-20

- New [`keypress()`](https://cli.r-lib.org/reference/keypress.md)
  function to read a single key press from a terminal.

- New function
  [`pretty_print_code()`](https://cli.r-lib.org/reference/pretty_print_code.md)
  to print function objects with syntax highlighting at the R console.

- `col_*` and `bg_*` functions how handle zero-length input correctly
  ([\#532](https://github.com/r-lib/cli/issues/532)).

- New function
  [`ansi_collapse()`](https://cli.r-lib.org/reference/ansi_collapse.md)
  to collapse character vectors into a single string.

- [`ansi_strtrim()`](https://cli.r-lib.org/reference/ansi_strtrim.md)
  now handles some edge cases better, when `ellipsis` has length zero,
  and when it is wider than `width`.

- New [`hash_file_md5()`](https://cli.r-lib.org/reference/hash_md5.md)
  function to calculate the MD5 hash of one or more files.

## cli 3.4.1

CRAN release: 2022-09-23

- cli has better error messages now.

- New
  [`format_inline()`](https://cli.r-lib.org/reference/format_inline.md)
  argument: `collapse`, to collapse multi-line output, potentially
  because of `\f` characters.

## cli 3.4.0

CRAN release: 2022-09-08

- New experimental styles to create ANSI hyperlinks in RStudio and
  terminals that support them. See
  [`?cli::links`](https://cli.r-lib.org/reference/links.md) for details
  ([\#513](https://github.com/r-lib/cli/issues/513)).

- Expressions that start and end with a
  [`{}`](https://rdrr.io/r/base/Paren.html) substitution are now styled
  correctly. E.g. `{.code {var1} + {var2}}`
  ([\#517](https://github.com/r-lib/cli/issues/517)).

- New `{.obj_type_friendly}` inline style to format the type of an R
  object in a user friendly way
  ([\#463](https://github.com/r-lib/cli/issues/463)).

- Improved vector collapsing behavior. cli now shows both the beginning
  and end of the collapsed vector, by default
  ([\#419](https://github.com/r-lib/cli/issues/419)).

- Nested [`cli()`](https://cli.r-lib.org/reference/cli.md) calls work
  now ([\#497](https://github.com/r-lib/cli/issues/497)).

- Return values now work as they should within
  [`cli()`](https://cli.r-lib.org/reference/cli.md) calls
  ([\#496](https://github.com/r-lib/cli/issues/496)).

- Style attributes with underscores have new names with dashes instead:
  `vec_sep`, `vec_last`, `vec_trunc`, `string-quote`. The old names
  still work, but the new ones take precedence
  ([\#483](https://github.com/r-lib/cli/issues/483)).

- cli now does not crash at the end of the R session on Arm Windows
  ([\#494](https://github.com/r-lib/cli/issues/494);
  [@kevinushey](https://github.com/kevinushey))

- Vectors are truncated at 20 elements now by default, instead of 100
  ([\#430](https://github.com/r-lib/cli/issues/430)).

- 20 new spinners from the awesome
  [cli-spinners](https://github.com/sindresorhus/cli-spinners) package,
  and from [@HenrikBengtsson](https://github.com/HenrikBengtsson) in
  [\#469](https://github.com/r-lib/cli/issues/469). Run this to demo
  them, some need UTF-8 and emoji support:

  ``` r
  new <- c("dots13", "dots8Bit", "sand", "material", "weather", "christmas",
    "grenade", "point", "layer", "betaWave", "fingerDance", "fistBump",
    "soccerHeader", "mindblown", "speaker", "orangePulse", "bluePulse",
    "orangeBluePulse", "timeTravel", "aesthetic", "growVeriticalDotsLR",
    "growVeriticalDotsRL", "growVeriticalDotsLL", "growVeriticalDotsRR")
  demo_spinners(new)
  ```

- cli exit handlers are now compatible again with the withr package
  ([\#437](https://github.com/r-lib/cli/issues/437)).

- cli functions now keep trailing `\f` characters as newlines. They also
  keep multiple consecutive `\f` as multiple newlines
  ([\#491](https://github.com/r-lib/cli/issues/491)).

- [`{}`](https://rdrr.io/r/base/Paren.html) substitutions within inline
  styles are now formatted correctly. E.g. `{.code download({url})}`
  will not add backticks to `url`, and `{.val pre-{x}-post}` will format
  the whole value instead of `x`.
  ([\#422](https://github.com/r-lib/cli/issues/422),
  [\#474](https://github.com/r-lib/cli/issues/474)).

- cli now replaces newline characters within `{.class ... }` inline
  styles with spaces. If the `cli.warn_inline_newlines` option is set to
  TRUE, then it also throws a warning.
  ([\#417](https://github.com/r-lib/cli/issues/417)).

- `code_highlight` now falls back to the default theme (instead of no
  theme) for unknown RStudio themes
  ([\#482](https://github.com/r-lib/cli/issues/482),
  [@rossellhayes](https://github.com/rossellhayes)).

- [`cli_abort()`](https://cli.r-lib.org/reference/cli_abort.md) now
  supplies `.frame` to `abort()`. This fixes an issue with the
  `.internal = TRUE` argument (r-lib/rlang#1386).

- cli now does a better job at detecting the RStudio build pane, job
  pane and render pane, and their capabilities w.r.t. ANSI colors and
  hyperlinks. Note that this requires a daily build of RStudio
  ([\#465](https://github.com/r-lib/cli/issues/465)).

- New functions for ANSI strings:
  [`ansi_grep()`](https://cli.r-lib.org/reference/ansi_grep.md),
  [`ansi_grepl()`](https://cli.r-lib.org/reference/ansi_grep.md),
  [`ansi_nzchar()`](https://cli.r-lib.org/reference/ansi_nzchar.md).
  They work like the corresponding base R functions, but handle ANSI
  markup.

- [`style_hyperlink()`](https://cli.r-lib.org/reference/style_hyperlink.md)
  (really) no longer breaks if the env variable `VTE_VERSION` is of the
  form `\d{4}`, i.e., 4 consecutive numbers
  ([\#441](https://github.com/r-lib/cli/issues/441),
  [@michaelchirico](https://github.com/michaelchirico))

- [`cli_dl()`](https://cli.r-lib.org/reference/cli_dl.md) and its
  corresponding [`cli_li()`](https://cli.r-lib.org/reference/cli_li.md)
  can now style the labels.

- The behavior cli’s inline styling expressions is now more predictable.
  cli does not try to evaluate a styled string as an R expression any
  more. E.g. the meaning of `"{.emph +1}"` is now always the “+1”, with
  style `.emph`, even if an `.emph` variable is available and the
  `.emph + 1` expression can be evaluated.

- Functions that apply bright background colors
  (e.g. [`bg_br_yellow()`](https://cli.r-lib.org/reference/ansi-styles.md))
  now close themselves. They no longer format text after the end of the
  function ([\#484](https://github.com/r-lib/cli/issues/484),
  [@rossellhayes](https://github.com/rossellhayes)).

## cli 3.3.0

CRAN release: 2022-04-25

- [`style_hyperlink()`](https://cli.r-lib.org/reference/style_hyperlink.md)
  no longer breaks if the env variable `VTE_VERSION` is of the form
  `\d{4}`, i.e., 4 consecutive numbers
  ([\#441](https://github.com/r-lib/cli/issues/441),
  [@michaelchirico](https://github.com/michaelchirico))

- `ansi_*()` functions support ANSI hyperlinks again
  ([\#444](https://github.com/r-lib/cli/issues/444)).

- Turning off ANSI colors via the `cli.num_colors` option or the
  `R_CLI_NUM_COLORS` or the `NO_COLOR` environment variable now also
  turns off ANSI hyperlinks
  ([\#447](https://github.com/r-lib/cli/issues/447)).

- `symbol` now only has two variants: UTF-8 and ASCII. There are no
  special variants for RStudio and Windows RGui any more
  ([\#424](https://github.com/r-lib/cli/issues/424)).

## cli 3.2.0

CRAN release: 2022-02-14

### Breaking change

- The `cli_theme_dark` option is now known as `cli.theme_dark`, to be
  consistent with all other cli option names
  ([\#380](https://github.com/r-lib/cli/issues/380)).

### Other changes

- The preferred names of the S3 classes `ansi_string`, `ansi_style`,
  `boxx`, `rule` and `tree` now have `cli_` prefix: `cli_ansi_string`,
  etc. This will help avoiding name conflicts with other packages
  eventually, but for now the old names are kept as well, for
  compatibility.

- [`cli_abort()`](https://cli.r-lib.org/reference/cli_abort.md) has been
  updated to work nicely with rlang 1.0. The default `call` and
  backtrace soft-truncation are set to `.envir` (which itself is set to
  the immediate caller of
  [`cli_abort()`](https://cli.r-lib.org/reference/cli_abort.md) by
  default).

  Line formatting now happens lazily at display time via
  [`rlang::cnd_message()`](https://rlang.r-lib.org/reference/cnd_message.html)
  (which is called by the
  [`conditionMessage()`](https://rdrr.io/r/base/conditions.html) method
  for rlang errors).

- New [`hash_sha256()`](https://cli.r-lib.org/reference/hash_sha256.md)
  function to calculate SHA-256 hashes. New `hash_raw_*()`,
  `hash_obj_*()` and `hash_file_*()` functions to calculate various
  hashes of raw vectors, R objects and files.

- You can use the new `cli.default_num_colors` option to set the default
  number of ANSI colors, only if ANSI support is otherwise detected. See
  the details in the manual of
  [`num_ansi_colors()`](https://cli.r-lib.org/reference/num_ansi_colors.md).

- You can set the new `ESS_BACKGROUND_MODE` environment variable to
  `dark` to indicate dark mode.

- cli now handles quotes and comment characters better in the semantion
  `cli_*()` functions that perform glue string interpolation
  ([\#370](https://github.com/r-lib/cli/issues/370)).

## cli 3.1.1

CRAN release: 2022-01-20

- [`style_hyperlink()`](https://cli.r-lib.org/reference/style_hyperlink.md)
  gains a `params=` argument
  ([\#384](https://github.com/r-lib/cli/issues/384)).

## cli 3.1.0

CRAN release: 2021-10-27

### Breaking changes

- The C progress bar API now uses `double` instead of `int` as the data
  type of the progress units
  ([\#335](https://github.com/r-lib/cli/issues/335)).

### New features

- Several improvements and changes in the `ansi_*()` functions:

  - most `ansi_*()` functions are now implemented in C and they are much
    faster ([\#316](https://github.com/r-lib/cli/issues/316)).
  - they handle `NA` values better.
  - many functions now use UTF-8 graphemes by default instead of code
    points. E.g.
    [`ansi_nchar()`](https://cli.r-lib.org/reference/ansi_nchar.md)
    counts graphemes, etc.
  - they convert their input to UTF-8 and always return UTF-8 encoded
    strings.
  - new function
    [`ansi_simplify()`](https://cli.r-lib.org/reference/ansi_simplify.md)
    to remove superfluous ANSI tags.
  - new function
    [`ansi_html()`](https://cli.r-lib.org/reference/ansi_html.md) to
    convert ANSI-highlighted strings to HTML.
  - [`ansi_has_any()`](https://cli.r-lib.org/reference/ansi_has_any.md)
    and [`ansi_strip()`](https://cli.r-lib.org/reference/ansi_strip.md)
    now have `sgr` and `csi` arguments to look for SGR tags, CSI tags,
    or both.

- New functions that handle UTF-8 encoded strings correctly:
  [`utf8_graphemes()`](https://cli.r-lib.org/reference/utf8_graphemes.md),
  [`utf8_nchar()`](https://cli.r-lib.org/reference/utf8_nchar.md),
  [`utf8_substr()`](https://cli.r-lib.org/reference/utf8_substr.md).

- Support for palettes, including a colorblind friendly palette. See
  [`?ansi_palettes`](https://cli.r-lib.org/reference/ansi_palettes.md)
  for details.

- True color support:
  [`num_ansi_colors()`](https://cli.r-lib.org/reference/num_ansi_colors.md)
  now detects terminals with 24 bit color support, and
  [`make_ansi_style()`](https://cli.r-lib.org/reference/make_ansi_style.md)
  uses the exact RGB colors on these terminals
  ([\#208](https://github.com/r-lib/cli/issues/208)).

- The new `col_br_*()` and `bg_br_()` functions create bright versions
  of eight base ANSI colors
  ([\#327](https://github.com/r-lib/cli/issues/327)).

- New function
  [`code_highlight()`](https://cli.r-lib.org/reference/code_highlight.md)
  to syntax highlight R code. It supports several themes out of the box,
  see
  [`code_theme_list()`](https://cli.r-lib.org/reference/code_theme_list.md)
  ([\#348](https://github.com/r-lib/cli/issues/348)).

- New functions for hashing:
  [`hash_animal()`](https://cli.r-lib.org/reference/hash_animal.md),
  [`hash_emoji()`](https://cli.r-lib.org/reference/hash_emoji.md) and
  [`hash_md5()`](https://cli.r-lib.org/reference/hash_md5.md).

- New [`diff_chr()`](https://cli.r-lib.org/reference/diff_chr.md) and
  [`diff_str()`](https://cli.r-lib.org/reference/diff_str.md) functions
  to calculate the difference of character vectors and letters of
  strings.

### Smaller improvements

- Progress bars with `clear = FALSE` now print the last, completed,
  state properly.

- The progress bar for Shiny apps now handles output from
  [`cli_progress_output()`](https://cli.r-lib.org/reference/cli_progress_output.md).

- Progress variables in C `format_done` strings work correctly now
  ([\#337](https://github.com/r-lib/cli/issues/337)).

- [`cli_dl()`](https://cli.r-lib.org/reference/cli_dl.md) now works with
  an empty description, and gives a better error for invalid input
  ([\#347](https://github.com/r-lib/cli/issues/347)).

- [`rule()`](https://cli.r-lib.org/reference/rule.md) is now works
  better if the labels have ANSI markup.

- `cli_spark` objects now have
  [`format()`](https://rdrr.io/r/base/format.html) and
  [`print()`](https://rdrr.io/r/base/print.html) methods.

- [`cli_process_done()`](https://cli.r-lib.org/reference/cli_process_start.md)
  now does not error without a process
  ([\#351](https://github.com/r-lib/cli/issues/351)).

- ANSI markup is now supported in RStudio jobs
  ([\#353](https://github.com/r-lib/cli/issues/353)).

- The lack of ANSI support is now again correctly detected if there is
  an active [`sink()`](https://rdrr.io/r/base/sink.html)
  ([\#366](https://github.com/r-lib/cli/issues/366)).

## cli 3.0.1

CRAN release: 2021-07-17

- [`ansi_strtrim()`](https://cli.r-lib.org/reference/ansi_strtrim.md)
  now correctly keeps `NA` values
  ([\#309](https://github.com/r-lib/cli/issues/309)).

- [`format_inline()`](https://cli.r-lib.org/reference/format_inline.md)
  now uses the correct environment
  ([@rundel](https://github.com/rundel),
  [\#314](https://github.com/r-lib/cli/issues/314)).

## cli 3.0.0

CRAN release: 2021-06-30

- New functions for progress bars, please see the new articles at
  <https://cli.r-lib.org/articles/> for details.

- New [`cli_abort()`](https://cli.r-lib.org/reference/cli_abort.md),
  [`cli_warn()`](https://cli.r-lib.org/reference/cli_abort.md) and
  [`cli_inform()`](https://cli.r-lib.org/reference/cli_abort.md)
  functions, to throw errors with cli pluralization and styling.

- New
  [`format_inline()`](https://cli.r-lib.org/reference/format_inline.md)
  function to format a cli string without emitting it
  ([\#278](https://github.com/r-lib/cli/issues/278)).

## cli 2.5.0

CRAN release: 2021-04-26

- New `style_no_*()` functions to locally undo styling. New
  [`col_none()`](https://cli.r-lib.org/reference/ansi-styles.md) and
  [`bg_none()`](https://cli.r-lib.org/reference/ansi-styles.md)
  functions to locally undo text color and background color.

- It is now possible to undo text and background color in a theme, by
  setting them to `NULL` or `"none"`.

- `cli_memo()` was renamed to
  [`cli_bullets()`](https://cli.r-lib.org/reference/cli_bullets.md), as
  it is by default formatted as a bullet list
  ([\#250](https://github.com/r-lib/cli/issues/250)).

- New
  [`ansi_toupper()`](https://cli.r-lib.org/reference/ansi_toupper.md),
  `ansi_tolower` and
  [`ansi_chartr()`](https://cli.r-lib.org/reference/ansi_toupper.md)
  functions, the ANSI styling aware variants of
  [`toupper()`](https://rdrr.io/r/base/chartr.html),
  [`tolower()`](https://rdrr.io/r/base/chartr.html) and
  [`chartr()`](https://rdrr.io/r/base/chartr.html)
  ([\#248](https://github.com/r-lib/cli/issues/248)).

- New
  [`test_that_cli()`](https://cli.r-lib.org/reference/test_that_cli.md)
  helper function to write testthat tests for cli output.

- [`tree()`](https://cli.r-lib.org/reference/tree.md) now does not
  produce warnings for tibbles
  ([\#238](https://github.com/r-lib/cli/issues/238)).

- New inline style: `.cls` to format class names, e.g.
  `"{.var fit} must be an {.cls lm} object"`.

## cli 2.4.0

CRAN release: 2021-04-05

- New `cli_memo()` function to create a list of items or tasks.

- New [`cli::cli()`](https://cli.r-lib.org/reference/cli.md) function to
  create a single cli message from multiple cli calls
  ([\#170](https://github.com/r-lib/cli/issues/170)).

- cli now highlights weird names, e.g. path names with leading or
  trailing space ([\#227](https://github.com/r-lib/cli/issues/227)).

- Styling is fixed at several places. In particular, nested lists should
  be now formatted better
  ([\#221](https://github.com/r-lib/cli/issues/221)).

- New [`spark_bar()`](https://cli.r-lib.org/reference/spark_bar.md) and
  [`spark_line()`](https://cli.r-lib.org/reference/spark_line.md)
  functions to draw small bar or line charts.

## cli 2.3.1

CRAN release: 2021-02-23

- ANSI color support detection works correctly now in older RStudio, and
  also on older R versions.

- [`cli_h1()`](https://cli.r-lib.org/reference/cli_h1.md),
  [`cli_h2()`](https://cli.r-lib.org/reference/cli_h1.md) and
  [`cli_h3()`](https://cli.r-lib.org/reference/cli_h1.md) now work with
  multiple glue substitutions
  ([\#218](https://github.com/r-lib/cli/issues/218)).

## cli 2.3.0

CRAN release: 2021-01-31

- [`boxx()`](https://cli.r-lib.org/reference/boxx.md) now correctly
  calculates the width of the box for non-ASCII characters.

- New [`ansi_trimws()`](https://cli.r-lib.org/reference/ansi_trimws.md)
  and
  [`ansi_strwrap()`](https://cli.r-lib.org/reference/ansi_strwrap.md)
  functions, they are similar to
  [`trimws()`](https://rdrr.io/r/base/trimws.html) and
  [`strwrap()`](https://rdrr.io/r/base/strwrap.html) but work on ANSI
  strings.

- New
  [`ansi_columns()`](https://cli.r-lib.org/reference/ansi_columns.md)
  function to format ANSI strings in multiple columns.

- [`ansi_substr()`](https://cli.r-lib.org/reference/ansi_substr.md),
  [`ansi_substring()`](https://cli.r-lib.org/reference/ansi_substring.md),
  [`ansi_strsplit()`](https://cli.r-lib.org/reference/ansi_strsplit.md),
  [`ansi_align()`](https://cli.r-lib.org/reference/ansi_align.md) now
  always return `cli_ansi_string` objects.

- [`ansi_nchar()`](https://cli.r-lib.org/reference/ansi_nchar.md),
  [`ansi_align()`](https://cli.r-lib.org/reference/ansi_align.md),
  [`ansi_strtrim()`](https://cli.r-lib.org/reference/ansi_strtrim.md)
  and the new
  [`ansi_strwrap()`](https://cli.r-lib.org/reference/ansi_strwrap.md) as
  well handle wide Unicode correctly, according to their display width.

- [`boxx()`](https://cli.r-lib.org/reference/boxx.md) can now add
  headers and footers to boxes.

## cli 2.2.0

CRAN release: 2020-11-20

- New
  [`style_hyperlink()`](https://cli.r-lib.org/reference/style_hyperlink.md)
  function to add hyperlinks, on terminals that support them.

- [`cli_format_method()`](https://cli.r-lib.org/reference/cli_format_method.md)
  now works properly in knitr, and other environments that catch message
  conditions ([\#159](https://github.com/r-lib/cli/issues/159)).

- ANSI strings created by `col_*`, `bg_*` and `style_*` now also add the
  `character` class to the result. This fixes issues with code that
  expect `character` objects.

- New functions to manipulate ANSI strings: `ansi_aling()`,
  [`ansi_has_any()`](https://cli.r-lib.org/reference/ansi_has_any.md),
  [`ansi_nchar()`](https://cli.r-lib.org/reference/ansi_nchar.md),
  [`ansi_regex()`](https://cli.r-lib.org/reference/ansi_regex.md),
  [`ansi_strip()`](https://cli.r-lib.org/reference/ansi_strip.md),
  [`ansi_strsplit()`](https://cli.r-lib.org/reference/ansi_strsplit.md),
  [`ansi_substr()`](https://cli.r-lib.org/reference/ansi_substr.md),
  [`ansi_substring()`](https://cli.r-lib.org/reference/ansi_substring.md).

## cli 2.1.0

CRAN release: 2020-10-12

- New [`cli_vec()`](https://cli.r-lib.org/reference/cli_vec.md) function
  to allow easier formatting of collapsed vectors. It is now also
  possible to use styling to set the collapsing parameters
  ([\#129](https://github.com/r-lib/cli/issues/129)).

- New [`pluralize()`](https://cli.r-lib.org/reference/pluralize.md)
  function to perform pluralization without generating cli output
  ([\#155](https://github.com/r-lib/cli/issues/155)).

- [`console_width()`](https://cli.r-lib.org/reference/console_width.md)
  works better now in RStudio, and also in terminals.

- Styling of verbatim text work properly now
  ([\#147](https://github.com/r-lib/cli/issues/147),
  [@tzakharko](https://github.com/tzakharko)).

- Messages (i.e. `message` conditions) coming from cli now have the
  `cliMessage` class, so you can easily suppress them without
  suppressing other messages
  ([\#156](https://github.com/r-lib/cli/issues/156)).

- cli prints the output to
  [`stderr()`](https://rdrr.io/r/base/showConnections.html) now, if
  there is an output or message sink. This is to make interactive and
  non-interactive sessions consistent
  ([\#153](https://github.com/r-lib/cli/issues/153)).

- Pluralization works correctly now if the last alternative is the empty
  string ([\#158](https://github.com/r-lib/cli/issues/158)).

- cli now caches the result of the dark background detection in iTerm on
  macOS. Reload cli to delete the cache
  ([\#131](https://github.com/r-lib/cli/issues/131)).

- The
  [`is_dynamic_tty()`](https://cli.r-lib.org/reference/is_dynamic_tty.md),
  [`is_ansi_tty()`](https://cli.r-lib.org/reference/is_ansi_tty.md) and
  [`ansi_hide_cursor()`](https://cli.r-lib.org/reference/ansi_hide_cursor.md)
  and related functions now default to the `"auto"` stream, which is
  automatically selected to be either
  [`stdout()`](https://rdrr.io/r/base/showConnections.html) or
  [`stderr()`](https://rdrr.io/r/base/showConnections.html). See the
  manual for details ([\#144](https://github.com/r-lib/cli/issues/144)).

- The default theme now quotes file names, paths, email addresses if
  they don’t start or end with an alphanumeric character or a slash.
  This is to make it easier to spot names that start or end with a space
  ([\#167](https://github.com/r-lib/cli/issues/167)).

- [`make_spinner()`](https://cli.r-lib.org/reference/make_spinner.md)
  clears the line properly now
  ([@tzakharko](https://github.com/tzakharko),
  [\#164](https://github.com/r-lib/cli/issues/164)).

- Semantic cli functions now automatically replace Unicode non-breaking
  space characters (`\u00a0`) with regular space characters, right
  before output. They are still used to calculate the line breaks, but
  not outputted ([\#161](https://github.com/r-lib/cli/issues/161)).

- Progress bars now respect
  [`is_dynamic_tty()`](https://cli.r-lib.org/reference/is_dynamic_tty.md)
  and do not output `\r` when this is false
  ([@jimhester](https://github.com/jimhester),
  [\#177](https://github.com/r-lib/cli/issues/177))

## cli 2.0.2

CRAN release: 2020-02-28

- The status bar now does not simplify multiple spaces by a single
  space.

- cli now does not crash if it fails to detect whether the RStudio theme
  is a dark theme ([\#138](https://github.com/r-lib/cli/issues/138)).

- cli now works better with wide Unicode characters, for example emojis.
  In particular, a status bar containing emojis is cleared properly
  ([\#133](https://github.com/r-lib/cli/issues/133)).

- The status bar now does not flicker when updated, in terminals
  ([\#135](https://github.com/r-lib/cli/issues/135)).

## cli 2.0.1

CRAN release: 2020-01-08

- Symbols (`symbol$*`) are now correctly printed in RStudio on Windows
  ([\#124](https://github.com/r-lib/cli/issues/124)).

- The default theme for
  [`cli_code()`](https://cli.r-lib.org/reference/cli_code.md) output
  looks better now, especially in RStudio
  ([\#123](https://github.com/r-lib/cli/issues/123)).

- Remove spurious newline after a
  [`cli_process_start()`](https://cli.r-lib.org/reference/cli_process_start.md)
  was cleared manually, and also at the end of the function.

- Use Oxford comma when listing 3 or more items
  ([@jonocarroll](https://github.com/jonocarroll),
  [\#128](https://github.com/r-lib/cli/issues/128)).

## cli 2.0.0

CRAN release: 2019-12-09

### Semantic command line interface tools

cli 2.0.0 has a new set of functions that help creating a CLI using a
set of higher level elements: headings, paragraphs, lists, alerts, code
blocks, etc. The formatting of all elements can be customized via
themes. See the “Building a semantic CLI” article on the package web
site: <https://cli.r-lib.org>

### Bug fixes:

- Fix a bug in
  [`is_dynamic_tty()`](https://cli.r-lib.org/reference/is_dynamic_tty.md),
  setting `R_CLI_DYNAMIC="FALSE"` now properly turns dynamic tty off
  ([\#70](https://github.com/r-lib/cli/issues/70)).

## cli 1.1.0

CRAN release: 2019-03-19

- cli has now functions to add ANSI styles to text. These use the crayon
  package internally, and provide a simpler interface. See the `col_*`,
  `bg_*`, `style_*` and also the
  [`make_ansi_style()`](https://cli.r-lib.org/reference/make_ansi_style.md)
  and
  [`combine_ansi_styles()`](https://cli.r-lib.org/reference/combine_ansi_styles.md)
  functions ([\#51](https://github.com/r-lib/cli/issues/51)).

- New
  [`is_dynamic_tty()`](https://cli.r-lib.org/reference/is_dynamic_tty.md)
  function detects if `\r` should be used for a stream
  ([\#62](https://github.com/r-lib/cli/issues/62)).

- New [`is_ansi_tty()`](https://cli.r-lib.org/reference/is_ansi_tty.md)
  function detects if ANSI control sequences can be used for a stream.

- New
  [`ansi_hide_cursor()`](https://cli.r-lib.org/reference/ansi_hide_cursor.md),
  [`ansi_show_cursor()`](https://cli.r-lib.org/reference/ansi_hide_cursor.md)
  and
  [`ansi_with_hidden_cursor()`](https://cli.r-lib.org/reference/ansi_hide_cursor.md)
  functions to hide and show the cursor in terminals.

- New
  [`make_spinner()`](https://cli.r-lib.org/reference/make_spinner.md)
  function helps integrating spinners into your functions.

- Now `symbol` always uses ASCII symbols when the `cli.unicode` option
  is set to `FALSE`.

## cli 1.0.0

CRAN release: 2017-11-05

First public release.
