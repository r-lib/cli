# Package index

## Introduction

To learn how to use cli’s semantic markup, start with the [‘Building a
semantic CLI’](https://cli.r-lib.org/articles/semantic-cli.md) vignette.

More detailed summaries about various cli topics:

- [`inline-markup`](https://cli.r-lib.org/reference/inline-markup.md) :
  About inline markup in the semantic cli
- [`links`](https://cli.r-lib.org/reference/links.md) : cli hyperlinks
- [`containers`](https://cli.r-lib.org/reference/containers.md) : About
  cli containers
- [`themes`](https://cli.r-lib.org/reference/themes.md) : About cli
  themes
- [`pluralization`](https://cli.r-lib.org/reference/pluralization.md) :
  About cli pluralization

## Semantic CLI Elements

- [`cli()`](https://cli.r-lib.org/reference/cli.md) : Compose multiple
  cli functions
- [`cli_alert()`](https://cli.r-lib.org/reference/cli_alert.md)
  [`cli_alert_success()`](https://cli.r-lib.org/reference/cli_alert.md)
  [`cli_alert_danger()`](https://cli.r-lib.org/reference/cli_alert.md)
  [`cli_alert_warning()`](https://cli.r-lib.org/reference/cli_alert.md)
  [`cli_alert_info()`](https://cli.r-lib.org/reference/cli_alert.md) :
  CLI alerts
- [`cli_blockquote()`](https://cli.r-lib.org/reference/cli_blockquote.md)
  : CLI block quote
- [`cli_bullets()`](https://cli.r-lib.org/reference/cli_bullets.md) :
  List of items
- [`cli_bullets_raw()`](https://cli.r-lib.org/reference/cli_bullets_raw.md)
  [`format_bullets_raw()`](https://cli.r-lib.org/reference/cli_bullets_raw.md)
  : List of verbatim items
- [`cli_code()`](https://cli.r-lib.org/reference/cli_code.md) : A block
  of code
- [`cli_div()`](https://cli.r-lib.org/reference/cli_div.md) : Generic
  CLI container
- [`cli_dl()`](https://cli.r-lib.org/reference/cli_dl.md) : Definition
  list
- [`cli_end()`](https://cli.r-lib.org/reference/cli_end.md) : Close a
  CLI container
- [`cli_format()`](https://cli.r-lib.org/reference/cli_format.md) :
  Format a value for printing
- [`cli_h1()`](https://cli.r-lib.org/reference/cli_h1.md)
  [`cli_h2()`](https://cli.r-lib.org/reference/cli_h1.md)
  [`cli_h3()`](https://cli.r-lib.org/reference/cli_h1.md) : CLI headings
- [`cli_li()`](https://cli.r-lib.org/reference/cli_li.md) : CLI list
  item(s)
- [`cli_ol()`](https://cli.r-lib.org/reference/cli_ol.md) : Ordered CLI
  list
- [`cli_par()`](https://cli.r-lib.org/reference/cli_par.md) : CLI
  paragraph
- [`cli_rule()`](https://cli.r-lib.org/reference/cli_rule.md) : CLI
  horizontal rule
- [`cli_text()`](https://cli.r-lib.org/reference/cli_text.md) : CLI text
- [`cli_ul()`](https://cli.r-lib.org/reference/cli_ul.md) : Unordered
  CLI list
- [`cli_vec()`](https://cli.r-lib.org/reference/cli_vec.md) : Add custom
  cli style to a vector
- [`cli_verbatim()`](https://cli.r-lib.org/reference/cli_verbatim.md) :
  CLI verbatim text
- [`format_inline()`](https://cli.r-lib.org/reference/format_inline.md)
  : Format and returns a line of text

## Themes

- [`themes`](https://cli.r-lib.org/reference/themes.md) : About cli
  themes
- [`builtin_theme()`](https://cli.r-lib.org/reference/builtin_theme.md)
  : The built-in CLI theme
- [`simple_theme()`](https://cli.r-lib.org/reference/simple_theme.md) :
  A simple CLI theme
- [`cli_list_themes()`](https://cli.r-lib.org/reference/cli_list_themes.md)
  : List the currently active themes

## Pluralization

cli has tools to create messages that are printed correctly in singular
and plural forms. See the
[‘Pluralization’](https://cli.r-lib.org/articles/pluralization.md)
article for an introduction.

- [`pluralize()`](https://cli.r-lib.org/reference/pluralize.md) : String
  templating with pluralization
- [`no()`](https://cli.r-lib.org/reference/pluralization-helpers.md)
  [`qty()`](https://cli.r-lib.org/reference/pluralization-helpers.md) :
  Pluralization helper functions

## Progress bars

cli progress bars work well with other bits of the semantic cli API. See
the [‘Introduction to Progress Bars in
cli’](https://cli.r-lib.org/articles/progress.md) article for an
introduction, and the [‘Advanced cli Progress
Bars’](https://cli.r-lib.org/articles/progress-advanced.md) article for
more advanced topics.

### Create and update progress bars

- [`cli_progress_along()`](https://cli.r-lib.org/reference/cli_progress_along.md)
  : Add a progress bar to a mapping function or for loop
- [`cli_progress_bar()`](https://cli.r-lib.org/reference/cli_progress_bar.md)
  [`cli_progress_update()`](https://cli.r-lib.org/reference/cli_progress_bar.md)
  [`cli_progress_done()`](https://cli.r-lib.org/reference/cli_progress_bar.md)
  : cli progress bars
- [`cli_progress_message()`](https://cli.r-lib.org/reference/cli_progress_message.md)
  : Simplified cli progress messages
- [`cli_progress_output()`](https://cli.r-lib.org/reference/cli_progress_output.md)
  : Add text output to a progress bar
- [`cli_progress_step()`](https://cli.r-lib.org/reference/cli_progress_step.md)
  : Simplified cli progress messages, with styling
- [`progress-variables`](https://cli.r-lib.org/reference/progress-variables.md)
  [`cli__pb_bar`](https://cli.r-lib.org/reference/progress-variables.md)
  [`pb_bar`](https://cli.r-lib.org/reference/progress-variables.md)
  [`cli__pb_current`](https://cli.r-lib.org/reference/progress-variables.md)
  [`pb_current`](https://cli.r-lib.org/reference/progress-variables.md)
  [`cli__pb_current_bytes`](https://cli.r-lib.org/reference/progress-variables.md)
  [`pb_current_bytes`](https://cli.r-lib.org/reference/progress-variables.md)
  [`cli__pb_elapsed`](https://cli.r-lib.org/reference/progress-variables.md)
  [`pb_elapsed`](https://cli.r-lib.org/reference/progress-variables.md)
  [`cli__pb_elapsed_clock`](https://cli.r-lib.org/reference/progress-variables.md)
  [`pb_elapsed_clock`](https://cli.r-lib.org/reference/progress-variables.md)
  [`cli__pb_elapsed_raw`](https://cli.r-lib.org/reference/progress-variables.md)
  [`pb_elapsed_raw`](https://cli.r-lib.org/reference/progress-variables.md)
  [`cli__pb_eta`](https://cli.r-lib.org/reference/progress-variables.md)
  [`pb_eta`](https://cli.r-lib.org/reference/progress-variables.md)
  [`cli__pb_eta_raw`](https://cli.r-lib.org/reference/progress-variables.md)
  [`pb_eta_raw`](https://cli.r-lib.org/reference/progress-variables.md)
  [`cli__pb_eta_str`](https://cli.r-lib.org/reference/progress-variables.md)
  [`pb_eta_str`](https://cli.r-lib.org/reference/progress-variables.md)
  [`cli__pb_extra`](https://cli.r-lib.org/reference/progress-variables.md)
  [`pb_extra`](https://cli.r-lib.org/reference/progress-variables.md)
  [`cli__pb_id`](https://cli.r-lib.org/reference/progress-variables.md)
  [`pb_id`](https://cli.r-lib.org/reference/progress-variables.md)
  [`cli__pb_name`](https://cli.r-lib.org/reference/progress-variables.md)
  [`pb_name`](https://cli.r-lib.org/reference/progress-variables.md)
  [`cli__pb_percent`](https://cli.r-lib.org/reference/progress-variables.md)
  [`pb_percent`](https://cli.r-lib.org/reference/progress-variables.md)
  [`cli__pb_pid`](https://cli.r-lib.org/reference/progress-variables.md)
  [`pb_pid`](https://cli.r-lib.org/reference/progress-variables.md)
  [`cli__pb_rate`](https://cli.r-lib.org/reference/progress-variables.md)
  [`pb_rate`](https://cli.r-lib.org/reference/progress-variables.md)
  [`cli__pb_rate_raw`](https://cli.r-lib.org/reference/progress-variables.md)
  [`pb_rate_raw`](https://cli.r-lib.org/reference/progress-variables.md)
  [`cli__pb_rate_bytes`](https://cli.r-lib.org/reference/progress-variables.md)
  [`pb_rate_bytes`](https://cli.r-lib.org/reference/progress-variables.md)
  [`cli__pb_spin`](https://cli.r-lib.org/reference/progress-variables.md)
  [`pb_spin`](https://cli.r-lib.org/reference/progress-variables.md)
  [`cli__pb_status`](https://cli.r-lib.org/reference/progress-variables.md)
  [`pb_status`](https://cli.r-lib.org/reference/progress-variables.md)
  [`cli__pb_timestamp`](https://cli.r-lib.org/reference/progress-variables.md)
  [`pb_timestamp`](https://cli.r-lib.org/reference/progress-variables.md)
  [`cli__pb_total`](https://cli.r-lib.org/reference/progress-variables.md)
  [`pb_total`](https://cli.r-lib.org/reference/progress-variables.md)
  [`cli__pb_total_bytes`](https://cli.r-lib.org/reference/progress-variables.md)
  [`pb_total_bytes`](https://cli.r-lib.org/reference/progress-variables.md)
  : Progress bar variables

### Progress bars in C/C++

- [`progress-c`](https://cli.r-lib.org/reference/progress-c.md) : The
  cli progress C API

### Progress bar utilities

- [`cli_progress_builtin_handlers()`](https://cli.r-lib.org/reference/cli_progress_builtin_handlers.md)
  : cli progress handlers
- [`cli_progress_demo()`](https://cli.r-lib.org/reference/cli_progress_demo.md)
  : cli progress bar demo
- [`cli_progress_styles()`](https://cli.r-lib.org/reference/cli_progress_styles.md)
  : List of built-in cli progress styles
- [`cli_progress_num()`](https://cli.r-lib.org/reference/progress-utils.md)
  [`cli_progress_cleanup()`](https://cli.r-lib.org/reference/progress-utils.md)
  : Progress bar utility functions.

## Terminal Colors and Styles

- [`truecolor`](https://cli.r-lib.org/reference/ansi_palettes.md)
  [`ansi_palettes`](https://cli.r-lib.org/reference/ansi_palettes.md)
  [`ansi_palette_show()`](https://cli.r-lib.org/reference/ansi_palettes.md)
  : ANSI colors palettes
- [`num_ansi_colors()`](https://cli.r-lib.org/reference/num_ansi_colors.md)
  [`detect_tty_colors()`](https://cli.r-lib.org/reference/num_ansi_colors.md)
  : Detect the number of ANSI colors to use
- [`bg_black()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`bg_blue()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`bg_cyan()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`bg_green()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`bg_magenta()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`bg_red()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`bg_white()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`bg_yellow()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`bg_none()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`bg_br_black()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`bg_br_blue()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`bg_br_cyan()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`bg_br_green()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`bg_br_magenta()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`bg_br_red()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`bg_br_white()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`bg_br_yellow()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`col_black()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`col_blue()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`col_cyan()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`col_green()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`col_magenta()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`col_red()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`col_white()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`col_yellow()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`col_grey()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`col_silver()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`col_none()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`col_br_black()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`col_br_blue()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`col_br_cyan()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`col_br_green()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`col_br_magenta()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`col_br_red()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`col_br_white()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`col_br_yellow()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`style_dim()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`style_blurred()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`style_bold()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`style_hidden()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`style_inverse()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`style_italic()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`style_reset()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`style_strikethrough()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`style_underline()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`style_no_bold()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`style_no_blurred()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`style_no_dim()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`style_no_italic()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`style_no_underline()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`style_no_inverse()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`style_no_hidden()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`style_no_strikethrough()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`style_no_color()`](https://cli.r-lib.org/reference/ansi-styles.md)
  [`style_no_bg_color()`](https://cli.r-lib.org/reference/ansi-styles.md)
  : ANSI colored text
- [`style_hyperlink()`](https://cli.r-lib.org/reference/style_hyperlink.md)
  [`ansi_has_hyperlink_support()`](https://cli.r-lib.org/reference/style_hyperlink.md)
  [`ansi_hyperlink_types()`](https://cli.r-lib.org/reference/style_hyperlink.md)
  : Terminal Hyperlinks
- [`combine_ansi_styles()`](https://cli.r-lib.org/reference/combine_ansi_styles.md)
  : Combine two or more ANSI styles
- [`make_ansi_style()`](https://cli.r-lib.org/reference/make_ansi_style.md)
  : Create a new ANSI style

## ANSI and/or UTF-8 String Manipulation

- [`ansi_align()`](https://cli.r-lib.org/reference/ansi_align.md) :
  Align an ANSI colored string

- [`ansi_collapse()`](https://cli.r-lib.org/reference/ansi_collapse.md)
  : Collapse a vector into a string scalar

- [`ansi_columns()`](https://cli.r-lib.org/reference/ansi_columns.md) :
  Format a character vector in multiple columns

- [`ansi_grep()`](https://cli.r-lib.org/reference/ansi_grep.md)
  [`ansi_grepl()`](https://cli.r-lib.org/reference/ansi_grep.md) :

  Like [`base::grep()`](https://rdrr.io/r/base/grep.html) and
  [`base::grepl()`](https://rdrr.io/r/base/grep.html), but for ANSI
  strings

- [`ansi_has_any()`](https://cli.r-lib.org/reference/ansi_has_any.md) :
  Check if a string has some ANSI styling

- [`ansi_html()`](https://cli.r-lib.org/reference/ansi_html.md) :
  Convert ANSI styled text to HTML

- [`ansi_html_style()`](https://cli.r-lib.org/reference/ansi_html_style.md)
  :

  CSS styles for the output of
  [`ansi_html()`](https://cli.r-lib.org/reference/ansi_html.md)

- [`ansi_nchar()`](https://cli.r-lib.org/reference/ansi_nchar.md) :
  Count number of characters in an ANSI colored string

- [`ansi_nzchar()`](https://cli.r-lib.org/reference/ansi_nzchar.md) :

  Like [`base::nzchar()`](https://rdrr.io/r/base/nchar.html), but for
  ANSI strings

- [`ansi_regex()`](https://cli.r-lib.org/reference/ansi_regex.md) : Perl
  compatible regular expression that matches ANSI escape sequences

- [`ansi_simplify()`](https://cli.r-lib.org/reference/ansi_simplify.md)
  : Simplify ANSI styling tags

- [`ansi_string()`](https://cli.r-lib.org/reference/ansi_string.md) :
  Labels a character vector as containing ANSI control codes.

- [`ansi_strip()`](https://cli.r-lib.org/reference/ansi_strip.md) :
  Remove ANSI escape sequences from a string

- [`ansi_strsplit()`](https://cli.r-lib.org/reference/ansi_strsplit.md)
  : Split an ANSI colored string

- [`ansi_strtrim()`](https://cli.r-lib.org/reference/ansi_strtrim.md) :
  Truncate an ANSI string

- [`ansi_strwrap()`](https://cli.r-lib.org/reference/ansi_strwrap.md) :
  Wrap an ANSI styled string to a certain width

- [`ansi_substr()`](https://cli.r-lib.org/reference/ansi_substr.md) :
  Substring(s) of an ANSI colored string

- [`ansi_substring()`](https://cli.r-lib.org/reference/ansi_substring.md)
  : Substring(s) of an ANSI colored string

- [`ansi_toupper()`](https://cli.r-lib.org/reference/ansi_toupper.md)
  [`ansi_tolower()`](https://cli.r-lib.org/reference/ansi_toupper.md)
  [`ansi_chartr()`](https://cli.r-lib.org/reference/ansi_toupper.md) :
  ANSI character translation and case folding

- [`ansi_trimws()`](https://cli.r-lib.org/reference/ansi_trimws.md) :
  Remove leading and/or trailing whitespace from an ANSI string

- [`utf8_graphemes()`](https://cli.r-lib.org/reference/utf8_graphemes.md)
  : Break an UTF-8 character vector into grapheme clusters

- [`utf8_nchar()`](https://cli.r-lib.org/reference/utf8_nchar.md) :
  Count the number of characters in a character vector

- [`utf8_substr()`](https://cli.r-lib.org/reference/utf8_substr.md) :
  Substring of an UTF-8 string

## Raising conditions with formatted cli messages

This section documents cli functions for signalling errors, warnings or
messages using abort(), warn() and inform() from
[rlang](https://rlang.r-lib.org/reference/topic-condition-formatting.html)

- [`cli_abort()`](https://cli.r-lib.org/reference/cli_abort.md)
  [`cli_warn()`](https://cli.r-lib.org/reference/cli_abort.md)
  [`cli_inform()`](https://cli.r-lib.org/reference/cli_abort.md) :
  Signal an error, warning or message with a cli formatted message
- [`format_error()`](https://cli.r-lib.org/reference/format_error.md)
  [`format_warning()`](https://cli.r-lib.org/reference/format_error.md)
  [`format_message()`](https://cli.r-lib.org/reference/format_error.md)
  : Format an error, warning or diagnostic message

## Rules, Boxes, Trees, Spinners, etc.

This section documents cli functions that create various non-semantic
cli output. See the [‘Rules, Boxes and
Trees’](https://cli.r-lib.org/articles/rules-boxes-trees.md) article for
a quick overview of most of them.

- [`list_border_styles()`](https://cli.r-lib.org/reference/boxx.md)
  [`boxx()`](https://cli.r-lib.org/reference/boxx.md) : Draw a
  banner-like box in the console
- [`demo_spinners()`](https://cli.r-lib.org/reference/demo_spinners.md)
  : Show a demo of some (by default all) spinners
- [`get_spinner()`](https://cli.r-lib.org/reference/get_spinner.md) :
  Character vector to put a spinner on the screen
- [`list_spinners()`](https://cli.r-lib.org/reference/list_spinners.md)
  : List all available spinners
- [`symbol`](https://cli.r-lib.org/reference/symbol.md)
  [`list_symbols()`](https://cli.r-lib.org/reference/symbol.md) :
  Various handy symbols to use in a command line UI
- [`make_spinner()`](https://cli.r-lib.org/reference/make_spinner.md) :
  Create a spinner
- [`rule()`](https://cli.r-lib.org/reference/rule.md) : Make a rule with
  one or two text labels
- [`spark_bar()`](https://cli.r-lib.org/reference/spark_bar.md) : Draw a
  sparkline bar graph with unicode block characters
- [`spark_line()`](https://cli.r-lib.org/reference/spark_line.md) : Draw
  a sparkline line graph with Braille characters.
- [`tree()`](https://cli.r-lib.org/reference/tree.md) : Draw a tree

## Syntax Highlighting

- [`code_highlight()`](https://cli.r-lib.org/reference/code_highlight.md)
  : Syntax highlight R code
- [`code_theme_list()`](https://cli.r-lib.org/reference/code_theme_list.md)
  : Syntax highlighting themes
- [`pretty_print_code()`](https://cli.r-lib.org/reference/pretty_print_code.md)
  : Turn on pretty-printing functions at the R console

## ANSI Control Sequences

- [`is_ansi_tty()`](https://cli.r-lib.org/reference/is_ansi_tty.md) :
  Detect if a stream support ANSI escape characters
- [`ansi_hide_cursor()`](https://cli.r-lib.org/reference/ansi_hide_cursor.md)
  [`ansi_show_cursor()`](https://cli.r-lib.org/reference/ansi_hide_cursor.md)
  [`ansi_with_hidden_cursor()`](https://cli.r-lib.org/reference/ansi_hide_cursor.md)
  : Hide/show cursor in a terminal

## Hashing

- [`hash_animal()`](https://cli.r-lib.org/reference/hash_animal.md)
  [`hash_raw_animal()`](https://cli.r-lib.org/reference/hash_animal.md)
  [`hash_obj_animal()`](https://cli.r-lib.org/reference/hash_animal.md)
  : Adjective-animal hash
- [`hash_emoji()`](https://cli.r-lib.org/reference/hash_emoji.md)
  [`hash_raw_emoji()`](https://cli.r-lib.org/reference/hash_emoji.md)
  [`hash_obj_emoji()`](https://cli.r-lib.org/reference/hash_emoji.md) :
  Emoji hash
- [`hash_md5()`](https://cli.r-lib.org/reference/hash_md5.md)
  [`hash_raw_md5()`](https://cli.r-lib.org/reference/hash_md5.md)
  [`hash_obj_md5()`](https://cli.r-lib.org/reference/hash_md5.md)
  [`hash_file_md5()`](https://cli.r-lib.org/reference/hash_md5.md) : MD5
  hash
- [`hash_sha1()`](https://cli.r-lib.org/reference/hash_sha1.md)
  [`hash_raw_sha1()`](https://cli.r-lib.org/reference/hash_sha1.md)
  [`hash_obj_sha1()`](https://cli.r-lib.org/reference/hash_sha1.md)
  [`hash_file_sha1()`](https://cli.r-lib.org/reference/hash_sha1.md) :
  SHA-1 hash
- [`hash_sha256()`](https://cli.r-lib.org/reference/hash_sha256.md)
  [`hash_raw_sha256()`](https://cli.r-lib.org/reference/hash_sha256.md)
  [`hash_obj_sha256()`](https://cli.r-lib.org/reference/hash_sha256.md)
  [`hash_file_sha256()`](https://cli.r-lib.org/reference/hash_sha256.md)
  : SHA-256 hash
- [`hash_xxhash()`](https://cli.r-lib.org/reference/hash_xxhash.md)
  [`hash_raw_xxhash()`](https://cli.r-lib.org/reference/hash_xxhash.md)
  [`hash_obj_xxhash()`](https://cli.r-lib.org/reference/hash_xxhash.md)
  [`hash_file_xxhash()`](https://cli.r-lib.org/reference/hash_xxhash.md)
  [`hash_xxhash64()`](https://cli.r-lib.org/reference/hash_xxhash.md)
  [`hash_raw_xxhash64()`](https://cli.r-lib.org/reference/hash_xxhash.md)
  [`hash_obj_xxhash64()`](https://cli.r-lib.org/reference/hash_xxhash.md)
  [`hash_file_xxhash64()`](https://cli.r-lib.org/reference/hash_xxhash.md)
  : xxHash

## Utilities and Configuration

- [`cat_line()`](https://cli.r-lib.org/reference/cat_line.md)
  [`cat_bullet()`](https://cli.r-lib.org/reference/cat_line.md)
  [`cat_boxx()`](https://cli.r-lib.org/reference/cat_line.md)
  [`cat_rule()`](https://cli.r-lib.org/reference/cat_line.md)
  [`cat_print()`](https://cli.r-lib.org/reference/cat_line.md) :

  [`cat()`](https://rdrr.io/r/base/cat.html) helpers

- [`cli-config`](https://cli.r-lib.org/reference/cli-config.md) : cli
  environment variables and options

- [`cli_debug_doc()`](https://cli.r-lib.org/reference/cli_debug_doc.md)
  : Debug cli internals

- [`cli_fmt()`](https://cli.r-lib.org/reference/cli_fmt.md) : Capture
  the output of cli functions instead of printing it

- [`cli_format_method()`](https://cli.r-lib.org/reference/cli_format_method.md)
  : Create a format method for an object using cli tools

- [`cli_output_connection()`](https://cli.r-lib.org/reference/cli_output_connection.md)
  : The connection option that cli would use

- [`cli_sitrep()`](https://cli.r-lib.org/reference/cli_sitrep.md) : cli
  situation report

- [`console_width()`](https://cli.r-lib.org/reference/console_width.md)
  : Determine the width of the console

- [`start_app()`](https://cli.r-lib.org/reference/start_app.md)
  [`stop_app()`](https://cli.r-lib.org/reference/start_app.md)
  [`default_app()`](https://cli.r-lib.org/reference/start_app.md) :
  Start, stop, query the default cli application

- [`diff_chr()`](https://cli.r-lib.org/reference/diff_chr.md) : Compare
  two character vectors elementwise

- [`diff_str()`](https://cli.r-lib.org/reference/diff_str.md) : Compare
  two character strings, character by character

- [`has_keypress_support()`](https://cli.r-lib.org/reference/has_keypress_support.md)
  : Check if the current platform/terminal supports reading single keys.

- [`is_dynamic_tty()`](https://cli.r-lib.org/reference/is_dynamic_tty.md)
  :

  Detect whether a stream supports `\\r` (Carriage return)

- [`is_utf8_output()`](https://cli.r-lib.org/reference/is_utf8_output.md)
  : Whether cli is emitting UTF-8 characters

- [`keypress()`](https://cli.r-lib.org/reference/keypress.md) : Read a
  single keypress at the terminal

- [`ruler()`](https://cli.r-lib.org/reference/ruler.md) : Print the
  helpful ruler to the screen

- [`test_that_cli()`](https://cli.r-lib.org/reference/test_that_cli.md)
  : Test cli output with testthat

- [`vt_output()`](https://cli.r-lib.org/reference/vt_output.md) :
  Simulate (a subset of) a VT-5xx ANSI terminal

## Superseded functions

- [`cli_process_start()`](https://cli.r-lib.org/reference/cli_process_start.md)
  [`cli_process_done()`](https://cli.r-lib.org/reference/cli_process_start.md)
  [`cli_process_failed()`](https://cli.r-lib.org/reference/cli_process_start.md)
  : Indicate the start and termination of some computation in the status
  bar (superseded)
- [`cli_status()`](https://cli.r-lib.org/reference/cli_status.md) :
  Update the status bar (superseded)
- [`cli_status_clear()`](https://cli.r-lib.org/reference/cli_status_clear.md)
  : Clear the status bar (superseded)
- [`cli_status_update()`](https://cli.r-lib.org/reference/cli_status_update.md)
  : Update the status bar (superseded)
