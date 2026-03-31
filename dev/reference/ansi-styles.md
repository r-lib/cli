# ANSI colored text

cli has a number of functions to color and style text at the command
line. They provide a more modern interface than the crayon package.

## Usage

``` r
bg_black(...)

bg_blue(...)

bg_cyan(...)

bg_green(...)

bg_magenta(...)

bg_red(...)

bg_white(...)

bg_yellow(...)

bg_none(...)

bg_br_black(...)

bg_br_blue(...)

bg_br_cyan(...)

bg_br_green(...)

bg_br_magenta(...)

bg_br_red(...)

bg_br_white(...)

bg_br_yellow(...)

col_black(...)

col_blue(...)

col_cyan(...)

col_green(...)

col_magenta(...)

col_red(...)

col_white(...)

col_yellow(...)

col_grey(...)

col_silver(...)

col_none(...)

col_br_black(...)

col_br_blue(...)

col_br_cyan(...)

col_br_green(...)

col_br_magenta(...)

col_br_red(...)

col_br_white(...)

col_br_yellow(...)

style_dim(...)

style_blurred(...)

style_bold(...)

style_hidden(...)

style_inverse(...)

style_italic(...)

style_reset(...)

style_strikethrough(...)

style_underline(...)

style_no_bold(...)

style_no_blurred(...)

style_no_dim(...)

style_no_italic(...)

style_no_underline(...)

style_no_inverse(...)

style_no_hidden(...)

style_no_strikethrough(...)

style_no_color(...)

style_no_bg_color(...)
```

## Arguments

- ...:

  Character strings, they will be pasted together with
  [`paste0()`](https://rdrr.io/r/base/paste.html), before applying the
  style function.

## Value

An ANSI string (class `cli_ansi_string`), that contains ANSI sequences,
if the current platform supports them. You can simply use
[`cat()`](https://rdrr.io/r/base/cat.html) to print them to the
terminal.

## Details

The `col_*` functions change the (foreground) color to the text. These
are the eight original ANSI colors. Note that in some terminals, they
might actually look differently, as terminals have their own settings
for how to show them. `col_none()` is the default color, this is useful
in a substring of a colored string.

The `col_br_*` functions are bright versions of the eight ANSI colors.
Note that on some terminal configurations and themes they might be the
same as the non-bright colors.

The `bg_*` functions change the background color of the text. These are
the eight original ANSI background colors. These, too, can vary in
appearance, depending on terminal settings. `bg_none()` the the default
background color, this is useful in a substring of a background-colored
string.

The `bg_br_*` functions are the bright versions of the eight ANSI
background colors. Note that on some terminal configurations and themes
they might be the same as the non-bright colors.

The `style_*` functions apply other styling to the text. The currently
supported styling functions are:

- `style_reset()` to remove any style, including color,

- `style_bold()` for boldface / strong text, although some terminals
  show a bright, high intensity text instead,

- `style_dim()` (or `style_blurred()` reduced intensity text.

- `style_italic()` (not widely supported).

- `style_underline()`,

- `style_inverse()`,

- `style_hidden()`,

- `style_strikethrough()` (not widely supported).

The style functions take any number of character vectors as arguments,
and they concatenate them using
[`paste0()`](https://rdrr.io/r/base/paste.html) before adding the style.

Styles can also be nested, and then inner style takes precedence, see
examples below.

Sometimes you want to revert back to the default text color, in the
middle of colored text, or you want to have a normal font in the middle
of italic text. You can use the `style_no_*` functions for this. Every
`style_*()` function has a `style_no_*()` pair, which defends its
argument from taking on the style. See examples below.

## See also

Other ANSI styling:
[`combine_ansi_styles()`](https://cli.r-lib.org/dev/reference/combine_ansi_styles.md),
[`make_ansi_style()`](https://cli.r-lib.org/dev/reference/make_ansi_style.md),
[`num_ansi_colors()`](https://cli.r-lib.org/dev/reference/num_ansi_colors.md)

## Examples

``` r
col_blue("Hello ", "world!")
#> <cli_ansi_string>
#> [1] Hello world!
cat(col_blue("Hello ", "world!"))
#> Hello world!

cat("... to highlight the", col_red("search term"),
    "in a block of text\n")
#> ... to highlight the search term in a block of text

## Style stack properly
cat(col_green(
 "I am a green line ",
 col_blue(style_underline(style_bold("with a blue substring"))),
 " that becomes green again!"
))
#> I am a green line with a blue substring that becomes green again!

error <- combine_ansi_styles("red", "bold")
warn <- combine_ansi_styles("magenta", "underline")
note <- col_cyan
cat(error("Error: subscript out of bounds!\n"))
#> Error: subscript out of bounds!
#> 
cat(warn("Warning: shorter argument was recycled.\n"))
#> Warning: shorter argument was recycled.
#> 
cat(note("Note: no such directory.\n"))
#> Note: no such directory.
#> 

# style_no_* functions, note that the color is not removed
style_italic(col_green(paste0(
  "italic before, ",
  style_no_italic("normal here, "),
  "italic after"
)))
#> <cli_ansi_string>
#> [1] italic before, normal here, italic after

# avoiding  color for substring
style_italic(col_red(paste(
  "red before",
  col_none("not red between"),
  "red after"
)))
#> <cli_ansi_string>
#> [1] red before not red between red after
```
