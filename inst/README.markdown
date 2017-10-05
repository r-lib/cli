


# boxes

> Draw Boxes, Rules, Trees in the R Console

[![Linux Build Status](https://travis-ci.org/r-lib/boxes.svg?branch=master)](https://travis-ci.org/r-lib/boxes)
[![Windows Build status](https://ci.appveyor.com/api/projects/status/github/r-lib/boxes?svg=true)](https://ci.appveyor.com/project/gaborcsardi/boxes)
[![](http://www.r-pkg.org/badges/version/boxes)](http://www.r-pkg.org/pkg/boxes)
[![CRAN RStudio mirror downloads](http://cranlogs.r-pkg.org/badges/boxes)](http://www.r-pkg.org/pkg/boxes)
[![Coverage Status](https://img.shields.io/codecov/c/github/r-lib/boxes/master.svg)](https://codecov.io/github/r-lib/boxes?branch=master)

It integrates well with `crayon` for coloring the boxes or their content,
and `clisymbols` to include Unicode characters in the boxes. It can also
draw rules to make headers or footers in console output, and tree
structures.

## Installation

```r
devtools::install_github("r-lib/boxes")
```

## Usage


```r
library(boxes)
```




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

![plot of chunk tree](inst/figure/tree-1.png)

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

![plot of chunk tree-color](inst/figure/tree-color-1.png)

## License

MIT © RStudio
