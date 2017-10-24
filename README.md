
# cli

> Draw Boxes, Rules, Trees in the R Console

[![Linux Build Status](https://api.travis-ci.org/r-lib/cli.svg?branch=master)](https://travis-ci.org/r-lib/cli)
[![Windows Build status](https://ci.appveyor.com/api/projects/status/github/r-lib/cli?svg=true)](https://ci.appveyor.com/project/gaborcsardi/cli)
[![](http://www.r-pkg.org/badges/version/cli)](http://www.r-pkg.org/pkg/cli)
[![CRAN RStudio mirror downloads](http://cranlogs.r-pkg.org/badges/cli)](http://www.r-pkg.org/pkg/cli)
[![Coverage status](https://coveralls.io/repos/github/r-lib/cli/badge.svg)](https://coveralls.io/r/r-lib/cli?branch=master)

It integrates well with `crayon` for coloring the boxes or their content,
and `clisymbols` to include Unicode characters in the boxes. It can also
draw rules to make headers or footers in console output, and tree
structures.

## Installation

```r
devtools::install_github("r-lib/cli")
```

## Usage


```r
library(cli)
```



### Rules

Simple rule


```r
rule()
```

![plot of chunk rule](man/figures/rule-1.png)

Double rule


```r
rule(line = 2)
```

![plot of chunk rule-double](man/figures/rule-double-1.png)

Bars


```r
rule(line = "bar2")
```

![plot of chunk rule-bars](man/figures/rule-bars-1.png)

```r
rule(line = "bar5")
```

![plot of chunk rule-bars](man/figures/rule-bars-2.png)

Left label


```r
rule(left = "Results")
```

![plot of chunk rule-left](man/figures/rule-left-1.png)

Centered label


```r
rule(center = " * RESULTS * ")
```

![plot of chunk rule-center](man/figures/rule-center-1.png)

Colored labels


```r
rule(center = crayon::red(" * RESULTS * "))
```

![plot of chunk rule-color](man/figures/rule-color-1.png)

Colored line


```r
rule(center = crayon::red(" * RESULTS * "), line_color = "red")
```

![plot of chunk rule-color-line](man/figures/rule-color-line-1.png)

Custom line


```r
rule(center = "TITLE", line = "~")
```

![plot of chunk rule-line-custom](man/figures/rule-line-custom-1.png)

More custom line


```r
rule(center = "TITLE", line = crayon::blue("~-"))
```

![plot of chunk rule-line-custom-2](man/figures/rule-line-custom-2-1.png)
Even more custom line


```r
rule(center = crayon::bgRed(" ", clisymbols::symbol$star, "TITLE",
  clisymbols::symbol$star, " "),
  line = "\u2582",
  line_color = "orange")
```

![plot of chunk rule-line-custom-3](man/figures/rule-line-custom-3-1.png)

### Boxes

Default box


```r
boxx("Hello there!")
```

![plot of chunk box](man/figures/box-1.png)

Change border style


```r
boxx("Hello there!", border_style = "double")
```

![plot of chunk box-border-style](man/figures/box-border-style-1.png)

Multiple lines


```r
boxx(c("Hello", "there!"), padding = 1)
```

![plot of chunk box-lines](man/figures/box-lines-1.png)

Padding


```r
boxx("Hello there!", padding = 1)
```

![plot of chunk box-padding](man/figures/box-padding-1.png)

```r
boxx("Hello there!", padding = c(1, 5, 1, 5))
```

![plot of chunk box-padding](man/figures/box-padding-2.png)

Margin


```r
boxx("Hello there!", margin = 1)
```

![plot of chunk box-margin](man/figures/box-margin-1.png)

```r
boxx("Hello there!", margin = c(1, 5, 1, 5))
```

![plot of chunk box-margin](man/figures/box-margin-2.png)

```r
boxx("Hello there!", padding = 1, margin = c(1, 5, 1, 5))
```

![plot of chunk box-margin](man/figures/box-margin-3.png)

Floating


```r
boxx("Hello there!", padding = 1, float = "center")
```

![plot of chunk box-floating](man/figures/box-floating-1.png)

```r
boxx("Hello there!", padding = 1, float = "right")
```

![plot of chunk box-floating](man/figures/box-floating-2.png)

Text color


```r
boxx(crayon::cyan("Hello there!"), padding = 1, float = "center")
```

![plot of chunk box-color](man/figures/box-color-1.png)

Backgorund color


```r
boxx("Hello there!", padding = 1, background_color = "brown")
```

![plot of chunk box-bgcolor](man/figures/box-bgcolor-1.png)

```r
boxx("Hello there!", padding = 1, background_color = crayon::bgRed)
```

![plot of chunk box-bgcolor](man/figures/box-bgcolor-2.png)

Border color


```r
boxx("Hello there!", padding = 1, border_color = "green")
```

![plot of chunk box-border-color](man/figures/box-border-color-1.png)

```r
boxx("Hello there!", padding = 1, border_color = crayon::red)
```

![plot of chunk box-border-color](man/figures/box-border-color-2.png)

Label alignment


```r
boxx(c("Hi", "there", "you!"), padding = 1, align = "left")
```

![plot of chunk box-label-align](man/figures/box-label-align-1.png)

```r
boxx(c("Hi", "there", "you!"), padding = 1, align = "center")
```

![plot of chunk box-label-align](man/figures/box-label-align-2.png)

```r
boxx(c("Hi", "there", "you!"), padding = 1, align = "right")
```

![plot of chunk box-label-align](man/figures/box-label-align-3.png)

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

![plot of chunk box-customized](man/figures/box-customized-1.png)

### Trees

You can specify the tree with a two column data frame, containing the
node ids/labels, and the list of their children.


```r
data <- data.frame(
  stringsAsFactors = FALSE,
  package = c("processx", "backports", "assertthat", "Matrix",
    "magrittr", "rprojroot", "clisymbols", "prettyunits", "withr",
    "desc", "igraph", "R6", "crayon", "debugme", "digest", "irlba",
    "rcmdcheck", "callr", "pkgconfig", "lattice"),
  dependencies = I(list(
    c("assertthat", "crayon", "debugme", "R6"), character(0),
    character(0), "lattice", character(0), "backports", character(0),
    c("magrittr", "assertthat"), character(0),
    c("assertthat", "R6", "crayon", "rprojroot"),
    c("irlba", "magrittr", "Matrix", "pkgconfig"), character(0),
    character(0), "crayon", character(0), "Matrix",
    c("callr", "clisymbols", "crayon", "desc", "digest", "prettyunits",
      "R6", "rprojroot", "withr"),
    c("processx", "R6"), character(0), character(0)
  ))
)
tree(data, root = "rcmdcheck")
```

![plot of chunk tree](man/figures/tree-1.png)

An optional third column may contain custom labels. These can be colored
as well:


```r
data$label <- paste(data$package,
  crayon::blurred(paste0("(", c("2.0.0.1", "1.1.1", "0.2.0", "1.2-11",
    "1.5", "1.2", "1.2.0", "1.0.2", "2.0.0", "1.1.1.9000", "1.1.2",
    "2.2.2", "1.3.4", "1.0.2", "0.6.12", "2.2.1", "1.2.1.9002",
    "1.0.0.9000", "2.0.1", "0.20-35"), ")"))
  )
roots <- ! data$package %in% unlist(data$dependencies)
data$label[roots] <- crayon::cyan(crayon::italic(data$label[roots]))
tree(data, root = "rcmdcheck")
```

![plot of chunk tree-color](man/figures/tree-color-1.png)

## License

MIT © RStudio
