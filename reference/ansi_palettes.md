# ANSI colors palettes

If your platform supports at least 256 colors, then you can configure
the colors that cli uses for the eight base and the eight bright colors.
(I.e. the colors of
[`col_black()`](https://cli.r-lib.org/reference/ansi-styles.md),
[`col_red()`](https://cli.r-lib.org/reference/ansi-styles.md), and
[`col_br_black()`](https://cli.r-lib.org/reference/ansi-styles.md),
[`col_br_red()`](https://cli.r-lib.org/reference/ansi-styles.md), etc.

## Usage

``` r
truecolor

ansi_palettes

ansi_palette_show(palette = NULL, colors = num_ansi_colors(), rows = 4)
```

## Format

`truecolor` is an integer scalar.

`ansi_palettes` is a data frame with one row for each palette, and one
column for each base ANSI color. `attr(ansi_palettes, "info")` contains
a list with information about each palette.

## Arguments

- palette:

  The palette to show, in the same format as for the `cli.palette`
  option, so it can be the name of a built-in palette, of a list of 16
  colors.

- colors:

  Number of ANSI colors to use the show the palette. If the platform
  does not have sufficient support, the output might have a lower color
  resolution. Without color support it will have no color at all.

- rows:

  The number of colored rows to print.

## Value

`ansi_palette_show` returns a character vector, the rows that are
printed to the screen, invisibly.

## Details

`truecolor` is an integer constant for the number of 24 bit ANSI colors.

To customize the default palette, set the `cli.palette` option to the
name of a built-in palette (see `ansi_palettes()`), or the list of 16
colors. Colors can be specified with RGB colors strings: `#rrggbb` or R
color names (see the output of
[`grDevices::colors()`](https://rdrr.io/r/grDevices/colors.html)).

For example, you can put this in your R profile:

    options(cli.palette = "vscode")

It is currently not possible to configure the background colors
separately, these will be always the same as the foreground colors.

If your platform only has 256 colors, then the colors specified in the
palette have to be interpolated. On true color platforms they RGB values
are used as-is.

`ansi_palettes` is a data frame of the built-in palettes, each row is
one palette.

`ansi_palette_show()` shows the colors of an ANSI palette on the screen.

## Examples

``` r
ansi_palettes
#>                   black     red   green  yellow    blue magenta
#> dichro          #000000 #882255 #117733 #ddcc77 #332288 #aa4499
#> vga             #000000 #aa0000 #00aa00 #aa5500 #0000aa #aa00aa
#> winxp           #000000 #800000 #008000 #808000 #000080 #800080
#> vscode          #000000 #cd3131 #0dbc79 #e5e510 #2472c8 #bc3fbc
#> win10           #0c0c0c #c50f1f #13a10e #c19c00 #0037da #881798
#> macos           #000000 #c23621 #25bc24 #adad27 #492ee1 #d338d3
#> putty           #000000 #bb0000 #00bb00 #bbbb00 #0000bb #bb00bb
#> mirc            #000000 #7f0000 #009300 #fc7f00 #00007f #9c009c
#> xterm           #000000 #cd0000 #00cd00 #cdcd00 #0000ee #cd00cd
#> ubuntu          #010101 #de382b #39b54a #ffc706 #006fb8 #762671
#> eclipse         #000000 #cd0000 #00cd00 #cdcd00 #0000ee #cd00cd
#> iterm           #000000 #c91b00 #00c200 #c7c400 #0225c7 #ca30c7
#> iterm-pastel    #626262 #ff8373 #b4fb73 #fffdc3 #a5d5fe #ff90fe
#> iterm-smoooooth #14191e #b43c2a #00c200 #c7c400 #2744c7 #c040be
#> iterm-snazzy    #000000 #ff5c57 #5af78e #f3f99d #57c7ff #ff6ac1
#> iterm-solarized #073642 #dc322f #859900 #b58900 #268bd2 #d33682
#> iterm-tango     #000000 #d81e00 #5ea702 #cfae00 #427ab3 #89658e
#>                    cyan   white br_black  br_red br_green br_yellow
#> dichro          #88ccee #e5e5e5  #000000 #cc6677  #999933   #ddcc77
#> vga             #00aaaa #aaaaaa  #555555 #ff5555  #55ff55   #ffff55
#> winxp           #008080 #c0c0c0  #808080 #ff0000  #00ff00   #ffff00
#> vscode          #11a8cd #e5e5e5  #666666 #f14c4c  #23d18b   #f5f543
#> win10           #3a96dd #cccccc  #767676 #e74856  #16c60c   #f9f1a5
#> macos           #33bbc8 #cbcccd  #818383 #fc391f  #31e722   #eaec23
#> putty           #00bbbb #bbbbbb  #555555 #ff5555  #55ff55   #ffff55
#> mirc            #009393 #d2d2d2  #7f7f7f #ff0000  #00fc00   #ffff00
#> xterm           #00cdcd #e5e5e5  #7f7f7f #ff0000  #00ff00   #ffff00
#> ubuntu          #2cb5e9 #cccccc  #808080 #ff0000  #00ff00   #ffff00
#> eclipse         #00cdcd #e5e5e5  #000000 #ff0000  #00ff00   #ffff00
#> iterm           #00c5c7 #c7c7c7  #686868 #ff6e67  #5ffa68   #fffc67
#> iterm-pastel    #d1d1fe #f1f1f1  #8f8f8f #ffc4be  #d6fcba   #fffed5
#> iterm-smoooooth #00c5c7 #c7c7c7  #686868 #dd7975  #58e790   #ece100
#> iterm-snazzy    #9aedfe #f1f1f0  #686868 #ff5c57  #5af78e   #f3f99d
#> iterm-solarized #2aa198 #eee8d5  #002b36 #cb4b16  #586e75   #657b83
#> iterm-tango     #00a7aa #dbded8  #686a66 #f54235  #99e343   #fdeb61
#>                 br_blue br_magenta br_cyan br_white
#> dichro          #44aa99    #aa4499 #88ccee  #ffffff
#> vga             #5555ff    #ff55ff #55ffff  #ffffff
#> winxp           #0000ff    #ff00ff #00ffff  #ffffff
#> vscode          #3b8eea    #d670d6 #29b8db  #e5e5e5
#> win10           #3b78ff    #b4009e #61d6d6  #f2f2f2
#> macos           #5833ff    #f935f8 #14f0f0  #e9ebeb
#> putty           #5555ff    #ff55ff #55ffff  #ffffff
#> mirc            #0000fc    #ff00ff #00ffff  #ffffff
#> xterm           #5c5cff    #ff00ff #00ffff  #ffffff
#> ubuntu          #0000ff    #ff00ff #00ffff  #ffffff
#> eclipse         #5c5cff    #ff00ff #00ffff  #ffffff
#> iterm           #6871ff    #ff77ff #60fdff  #ffffff
#> iterm-pastel    #c2e3ff    #ffb2fe #e6e7fe  #ffffff
#> iterm-smoooooth #a7abf2    #e17ee1 #60fdff  #ffffff
#> iterm-snazzy    #57c7ff    #ff6ac1 #9aedfe  #f1f1f0
#> iterm-solarized #839496    #6c71c4 #93a1a1  #fdf6e3
#> iterm-tango     #84b0d8    #bc94b7 #37e6e8  #f1f1f0
ansi_palette_show("dichro", colors = truecolor)
#>                                                      bright variants
#> blck red  grn  yllw blue mgnt cyan whte  blck red  grn  yllw blue mgnt cyan whte
#> 
#> ████ ████ ████ ████ ████ ████ ████ ████  ████ ████ ████ ████ ████ ████ ████ ████
#> ████ ████ ████ ████ ████ ████ ████ ████  ████ ████ ████ ████ ████ ████ ████ ████
#> ████ ████ ████ ████ ████ ████ ████ ████  ████ ████ ████ ████ ████ ████ ████ ████
#> ████ ████ ████ ████ ████ ████ ████ ████  ████ ████ ████ ████ ████ ████ ████ ████
```
