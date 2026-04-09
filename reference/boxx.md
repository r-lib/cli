# Draw a banner-like box in the console

Draw a banner-like box in the console

## Usage

``` r
list_border_styles()

boxx(
  label,
  header = "",
  footer = "",
  border_style = "single",
  padding = 1,
  margin = 0,
  float = c("left", "center", "right"),
  col = NULL,
  background_col = NULL,
  border_col = col,
  align = c("left", "center", "right"),
  width = console_width()
)
```

## Arguments

- label:

  Label to show, a character vector. Each element will be in a new line.
  You can color it using the `col_*`, `bg_*` and `style_*` functions,
  see [ANSI styles](https://cli.r-lib.org/reference/ansi-styles.md) and
  the examples below.

- header:

  Text to show on top border of the box. If too long, it will be cut.

- footer:

  Text to show on the bottom border of the box. If too long, it will be
  cut.

- border_style:

  String that specifies the border style. `list_border_styles` lists all
  current styles.

- padding:

  Padding within the box. Either an integer vector of four numbers
  (bottom, left, top, right), or a single number `x`, which is
  interpreted as `c(x, 3*x, x, 3*x)`.

- margin:

  Margin around the box. Either an integer vector of four numbers
  (bottom, left, top, right), or a single number `x`, which is
  interpreted as `c(x, 3*x, x, 3*x)`.

- float:

  Whether to display the box on the `"left"`, `"center"`, or the
  `"right"` of the screen.

- col:

  Color of text, and default border color. Either a style function (see
  [ANSI styles](https://cli.r-lib.org/reference/ansi-styles.md)) or a
  color name that is passed to
  [`make_ansi_style()`](https://cli.r-lib.org/reference/make_ansi_style.md).

- background_col:

  Background color of the inside of the box. Either a style function
  (see [ANSI styles](https://cli.r-lib.org/reference/ansi-styles.md)),
  or a color name which will be used in
  [`make_ansi_style()`](https://cli.r-lib.org/reference/make_ansi_style.md)
  to create a *background* style (i.e. `bg = TRUE` is used).

- border_col:

  Color of the border. Either a style function (see [ANSI
  styles](https://cli.r-lib.org/reference/ansi-styles.md)) or a color
  name that is passed to
  [`make_ansi_style()`](https://cli.r-lib.org/reference/make_ansi_style.md).

- align:

  Alignment of the label within the box: `"left"`, `"center"`, or
  `"right"`.

- width:

  Width of the screen, defaults to
  [`console_width()`](https://cli.r-lib.org/reference/console_width.md).

## Details

### Defaults

    boxx("Hello there!")

    #> ┌──────────────────┐
    #> │                  │
    #> │   Hello there!   │
    #> │                  │
    #> └──────────────────┘

### Change border style

    boxx("Hello there!", border_style = "double")

    #> ╔══════════════════╗
    #> ║                  ║
    #> ║   Hello there!   ║
    #> ║                  ║
    #> ╚══════════════════╝

### Multiple lines

    boxx(c("Hello", "there!"), padding = 1)

    #> ┌────────────┐
    #> │            │
    #> │   Hello    │
    #> │   there!   │
    #> │            │
    #> └────────────┘

### Padding

    boxx("Hello there!", padding = 1)
    boxx("Hello there!", padding = c(1, 5, 1, 5))

    #> ┌──────────────────┐
    #> │                  │
    #> │   Hello there!   │
    #> │                  │
    #> └──────────────────┘
    #> ┌──────────────────────┐
    #> │                      │
    #> │     Hello there!     │
    #> │                      │
    #> └──────────────────────┘

### Floating

    boxx("Hello there!", padding = 1, float = "center")
    boxx("Hello there!", padding = 1, float = "right")

    #>                           ┌──────────────────┐
    #>                           │                  │
    #>                           │   Hello there!   │
    #>                           │                  │
    #>                           └──────────────────┘
    #>                                                   ┌──────────────────┐
    #>                                                   │                  │
    #>                                                   │   Hello there!   │
    #>                                                   │                  │
    #>                                                   └──────────────────┘

### Text color

    boxx(col_cyan("Hello there!"), padding = 1, float = "center")

    #>                           ┌──────────────────┐
    #>                           │                  │
    #>                           │   Hello there!   │
    #>                           │                  │
    #>                           └──────────────────┘

### Background color

    boxx("Hello there!", padding = 1, background_col = "brown")
    boxx("Hello there!", padding = 1, background_col = bg_red)

    #> ┌──────────────────┐
    #> │                  │
    #> │   Hello there!   │
    #> │                  │
    #> └──────────────────┘
    #> ┌──────────────────┐
    #> │                  │
    #> │   Hello there!   │
    #> │                  │
    #> └──────────────────┘

### Border color

    boxx("Hello there!", padding = 1, border_col = "green")
    boxx("Hello there!", padding = 1, border_col = col_red)

    #> ┌──────────────────┐
    #> │                  │
    #> │   Hello there!   │
    #> │                  │
    #> └──────────────────┘
    #> ┌──────────────────┐
    #> │                  │
    #> │   Hello there!   │
    #> │                  │
    #> └──────────────────┘

### Label alignment

    boxx(c("Hi", "there", "you!"), padding = 1, align = "left")
    boxx(c("Hi", "there", "you!"), padding = 1, align = "center")
    boxx(c("Hi", "there", "you!"), padding = 1, align = "right")

    #> ┌───────────┐
    #> │           │
    #> │   Hi      │
    #> │   there   │
    #> │   you!    │
    #> │           │
    #> └───────────┘
    #> ┌───────────┐
    #> │           │
    #> │     Hi    │
    #> │   there   │
    #> │    you!   │
    #> │           │
    #> └───────────┘
    #> ┌───────────┐
    #> │           │
    #> │      Hi   │
    #> │   there   │
    #> │    you!   │
    #> │           │
    #> └───────────┘

### A very customized box

    star <- symbol$star
    label <- c(paste(star, "Hello", star), "  there!")
    boxx(
      col_white(label),
      border_style="round",
      padding = 1,
      float = "center",
      border_col = "tomato3",
      background_col="darkolivegreen"
    )

    #>                            ╭───────────────╮
    #>                            │               │
    #>                            │   ★ Hello ★   │
    #>                            │     there!    │
    #>                            │               │
    #>                            ╰───────────────╯

## About fonts and terminal settings

The boxes might or might not look great in your terminal, depending on
the box style you use and the font the terminal uses. We found that the
Menlo font looks nice in most terminals an also in Emacs.

RStudio currently has a line height greater than one for console output,
which makes the boxes ugly.
