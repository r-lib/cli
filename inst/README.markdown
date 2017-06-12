


# boxes

> Draw Boxes in the R Console

[![Linux Build Status](https://travis-ci.org/r-lib/boxes.svg?branch=master)](https://travis-ci.org/r-lib/boxes)
[![Windows Build status](https://ci.appveyor.com/api/projects/status/github/r-lib/boxes?svg=true)](https://ci.appveyor.com/project/gaborcsardi/boxes)
[![](http://www.r-pkg.org/badges/version/boxes)](http://www.r-pkg.org/pkg/boxes)
[![CRAN RStudio mirror downloads](http://cranlogs.r-pkg.org/badges/boxes)](http://www.r-pkg.org/pkg/boxes)
[![Coverage Status](https://img.shields.io/codecov/c/github/r-lib/boxes/master.svg)](https://codecov.io/github/r-lib/boxes?branch=master)

It integrates well with `crayon` for coloring the boxes or their content,
and `clisymbols` to include Unicode characters in the boxes. It can also
draw rules to make headers or footers in console output.

## Installation

```r
devtools::install_github("r-lib/boxes")
```

## Usage


```r
library(boxes)
```



### Rules

Simple rule


```r
rule()
```

![plot of chunk rule](inst/figure/rule-1.png)

Double rule


```r
rule(line = 2)
```

![plot of chunk rule-double](inst/figure/rule-double-1.png)

Bars


```r
rule(line = "bar2")
```

![plot of chunk rule-bars](inst/figure/rule-bars-1.png)

```r
rule(line = "bar5")
```

![plot of chunk rule-bars](inst/figure/rule-bars-2.png)

Left label


```r
rule(left = "Results")
```

![plot of chunk rule-left](inst/figure/rule-left-1.png)

Centered label


```r
rule(center = " * RESULTS * ")
```

![plot of chunk rule-center](inst/figure/rule-center-1.png)

Colored labels


```r
rule(center = crayon::red(" * RESULTS * "))
```

![plot of chunk rule-color](inst/figure/rule-color-1.png)

Colored line


```r
rule(center = crayon::red(" * RESULTS * "), line_color = "red")
```

![plot of chunk rule-color-line](inst/figure/rule-color-line-1.png)

Custom line


```r
rule(center = "TITLE", line = "~")
```

![plot of chunk rule-line-custom](inst/figure/rule-line-custom-1.png)

More custom line


```r
rule(center = "TITLE", line = crayon::blue("~-"))
```

![plot of chunk rule-line-custom-2](inst/figure/rule-line-custom-2-1.png)
Even more custom line


```r
rule(center = crayon::bgRed(" ", clisymbols::symbol$star, "TITLE",
  clisymbols::symbol$star, " "),
  line = "\u2582",
  line_color = "orange")
```

![plot of chunk rule-line-custom-3](inst/figure/rule-line-custom-3-1.png)

### Boxes

Default box


```r
boxx("Hello there!")
```

![plot of chunk box](inst/figure/box-1.png)

Change border style


```r
boxx("Hello there!", border_style = "double")
```

![plot of chunk box-border-style](inst/figure/box-border-style-1.png)

Multiple lines


```r
boxx(c("Hello", "there!"), padding = 1)
```

![plot of chunk box-lines](inst/figure/box-lines-1.png)

Padding


```r
boxx("Hello there!", padding = 1)
```

![plot of chunk box-padding](inst/figure/box-padding-1.png)

```r
boxx("Hello there!", padding = c(1, 5, 1, 5))
```

![plot of chunk box-padding](inst/figure/box-padding-2.png)

Margin


```r
boxx("Hello there!", margin = 1)
```

![plot of chunk box-margin](inst/figure/box-margin-1.png)

```r
boxx("Hello there!", margin = c(1, 5, 1, 5))
```

![plot of chunk box-margin](inst/figure/box-margin-2.png)

```r
boxx("Hello there!", padding = 1, margin = c(1, 5, 1, 5))
```

![plot of chunk box-margin](inst/figure/box-margin-3.png)

Floating


```r
boxx("Hello there!", padding = 1, float = "center")
```

![plot of chunk box-floating](inst/figure/box-floating-1.png)

```r
boxx("Hello there!", padding = 1, float = "right")
```

![plot of chunk box-floating](inst/figure/box-floating-2.png)

Text color


```r
boxx(crayon::cyan("Hello there!"), padding = 1, float = "center")
```

![plot of chunk box-color](inst/figure/box-color-1.png)

Backgorund color


```r
boxx("Hello there!", padding = 1, background_color = "brown")
```

![plot of chunk box-bgcolor](inst/figure/box-bgcolor-1.png)

```r
boxx("Hello there!", padding = 1, background_color = crayon::bgRed)
```

![plot of chunk box-bgcolor](inst/figure/box-bgcolor-2.png)

Border color


```r
boxx("Hello there!", padding = 1, border_color = "green")
```

![plot of chunk box-border-color](inst/figure/box-border-color-1.png)

```r
boxx("Hello there!", padding = 1, border_color = crayon::red)
```

![plot of chunk box-border-color](inst/figure/box-border-color-2.png)

Label alignment


```r
boxx(c("Hi", "there", "you!"), padding = 1, align = "left")
```

![plot of chunk box-label-align](inst/figure/box-label-align-1.png)

```r
boxx(c("Hi", "there", "you!"), padding = 1, align = "center")
```

![plot of chunk box-label-align](inst/figure/box-label-align-2.png)

```r
boxx(c("Hi", "there", "you!"), padding = 1, align = "right")
```

![plot of chunk box-label-align](inst/figure/box-label-align-3.png)

A very customized box


```r
star <- clisymbols::symbol$star
label <- c(paste(star, "Hello", star), "  there!")
boxx(
  crayon::white(label),
  border_style="round",
  padding = 1,
  float = "center",
  border_color = "tomato3",
  background_color="darkolivegreen"
)
```

![plot of chunk box-customized](inst/figure/box-customized-1.png)

## License

MIT © RStudio
