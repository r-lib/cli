# CSS styles for the output of `ansi_html()`

CSS styles for the output of
[`ansi_html()`](https://cli.r-lib.org/reference/ansi_html.md)

## Usage

``` r
ansi_html_style(
  colors = TRUE,
  palette = c("vscode", "dichro", "vga", "winxp", "win10", "macos", "putty", "mirc",
    "xterm", "ubuntu", "eclipse", "iterm", "iterm-pastel", "iterm-smoooooth",
    "iterm-snazzy", "iterm-solarized", "iterm-tango")
)
```

## Arguments

- colors:

  Whether or not to include colors. `FALSE` will not include colors,
  `TRUE` or `8` will include eight colors (plus their bright variants),
  `256` will include 256 colors.

- palette:

  Character scalar, palette to use for the first eight colors plus their
  bright variants. Terminals define these colors differently, and cli
  includes a couple of examples. Sources of palettes:

  - https://en.wikipedia.org/wiki/ANSI_escape_code#3-bit_and_4-bit

  - iTerm2 builtin palettes

  - <https://github.com/sindresorhus/iterm2-snazzy>

## Value

Named list of CSS declaration blocks, where the names are CSS selectors.
It has a [`format()`](https://rdrr.io/r/base/format.html) and
[`print()`](https://rdrr.io/r/base/print.html) methods, which you can
use to write the output to a CSS or HTML file.

## See also

Other ANSI to HTML conversion:
[`ansi_html()`](https://cli.r-lib.org/reference/ansi_html.md)

## Examples

``` r
ansi_html_style(colors = FALSE)
#> .ansi-bold       { font-weight: bold;             }
#> .ansi-italic     { font-style: italic;            }
#> .ansi-underline  { text-decoration: underline;    }
#> .ansi-blink      { text-decoration: blink;        }
#> .ansi-hide       { visibility: hidden;            }
#> .ansi-crossedout { text-decoration: line-through; }
#> .ansi-link:hover { text-decoration: underline;    }
ansi_html_style(colors = 8, palette = "iterm-snazzy")
#> .ansi-bold        { font-weight: bold;             }
#> .ansi-italic      { font-style: italic;            }
#> .ansi-underline   { text-decoration: underline;    }
#> .ansi-blink       { text-decoration: blink;        }
#> .ansi-hide        { visibility: hidden;            }
#> .ansi-crossedout  { text-decoration: line-through; }
#> .ansi-link:hover  { text-decoration: underline;    }
#> .ansi-color-0     { color: #000000 }
#> .ansi-color-1     { color: #ff5c57 }
#> .ansi-color-2     { color: #5af78e }
#> .ansi-color-3     { color: #f3f99d }
#> .ansi-color-4     { color: #57c7ff }
#> .ansi-color-5     { color: #ff6ac1 }
#> .ansi-color-6     { color: #9aedfe }
#> .ansi-color-7     { color: #f1f1f0 }
#> .ansi-color-8     { color: #686868 }
#> .ansi-color-9     { color: #ff5c57 }
#> .ansi-color-10    { color: #5af78e }
#> .ansi-color-11    { color: #f3f99d }
#> .ansi-color-12    { color: #57c7ff }
#> .ansi-color-13    { color: #ff6ac1 }
#> .ansi-color-14    { color: #9aedfe }
#> .ansi-color-15    { color: #f1f1f0 }
#> .ansi-bg-color-0  { background-color: #000000 }
#> .ansi-bg-color-1  { background-color: #ff5c57 }
#> .ansi-bg-color-2  { background-color: #5af78e }
#> .ansi-bg-color-3  { background-color: #f3f99d }
#> .ansi-bg-color-4  { background-color: #57c7ff }
#> .ansi-bg-color-5  { background-color: #ff6ac1 }
#> .ansi-bg-color-6  { background-color: #9aedfe }
#> .ansi-bg-color-7  { background-color: #f1f1f0 }
#> .ansi-bg-color-8  { background-color: #686868 }
#> .ansi-bg-color-9  { background-color: #ff5c57 }
#> .ansi-bg-color-10 { background-color: #5af78e }
#> .ansi-bg-color-11 { background-color: #f3f99d }
#> .ansi-bg-color-12 { background-color: #57c7ff }
#> .ansi-bg-color-13 { background-color: #ff6ac1 }
#> .ansi-bg-color-14 { background-color: #9aedfe }
#> .ansi-bg-color-15 { background-color: #f1f1f0 }
```
