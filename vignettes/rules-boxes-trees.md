---
title: "Rules, Boxes and Trees"
author: "Gábor Csárdi"
date: "2019-12-05"
output:
  rmarkdown::html_vignette:
    keep_md: true
    toc: true
    toc_depth: 2
vignette: >
  %\VignetteIndexEntry{Rules, Boxes and Trees}
  %\VignetteEngine{cli::lazyrmd}
  %\VignetteEncoding{UTF-8}
---




```r
library(cli)
```

# Introduction

These are non-semantic functions to format or output content to the
console. They do not use the cli theme.

# Rules

`rule()` creates a horizontal rule, potentially with labels.
If you are building a semantic CLI, then consider using `cli_rule()`
instead.

## Simple rule, double rule, bars


```asciicast
rule()
```


<img src="rules-boxes-trees_files/figure-html//unnamed-chunk-2.svg" width="100%" />


```asciicast
rule(line = 2)
```


<img src="rules-boxes-trees_files/figure-html//unnamed-chunk-3.svg" width="100%" />


```asciicast
rule(line = "bar2")
```


<img src="rules-boxes-trees_files/figure-html//unnamed-chunk-4.svg" width="100%" />


```asciicast
rule(line = "bar5")
```


<img src="rules-boxes-trees_files/figure-html//unnamed-chunk-5.svg" width="100%" />


```asciicast
rule(center = "TITLE", line = "~")
```


<img src="rules-boxes-trees_files/figure-html//unnamed-chunk-6.svg" width="100%" />

## Labels


```asciicast
rule(left = "Results")
```


<img src="rules-boxes-trees_files/figure-html//unnamed-chunk-7.svg" width="100%" />


```asciicast
rule(center = " * RESULTS * ")
```


<img src="rules-boxes-trees_files/figure-html//unnamed-chunk-8.svg" width="100%" />

## Colors


```asciicast
rule(center = col_red(" * RESULTS * "))
```


<img src="rules-boxes-trees_files/figure-html//unnamed-chunk-9.svg" width="100%" />


```asciicast
rule(center = " * RESULTS * ", col = "red")
```


<img src="rules-boxes-trees_files/figure-html//unnamed-chunk-10.svg" width="100%" />


```asciicast
rule(center = " * RESULTS * ", line_col = "red")
```


<img src="rules-boxes-trees_files/figure-html//unnamed-chunk-11.svg" width="100%" />


```asciicast
rule(center = "TITLE", line = "~-", line_col = "blue")
```


<img src="rules-boxes-trees_files/figure-html//unnamed-chunk-12.svg" width="100%" />


```asciicast
rule(center = bg_red(" ", symbol$star, "TITLE", symbol$star, " "),
  line = "\u2582", line_col = "orange")
```


<img src="rules-boxes-trees_files/figure-html//unnamed-chunk-13.svg" width="100%" />

# Boxes


```asciicast
boxx("Hello there!")
```


<img src="rules-boxes-trees_files/figure-html//unnamed-chunk-14.svg" width="100%" />

## Change border style


```asciicast
boxx("Hello there!", border_style = "double")
```


<img src="rules-boxes-trees_files/figure-html//unnamed-chunk-15.svg" width="100%" />

## Multiple lines of text


```asciicast
boxx(c("Hello", "there!"), padding = 1)
```


<img src="rules-boxes-trees_files/figure-html//unnamed-chunk-16.svg" width="100%" />

## Padding and margin


```asciicast
boxx("Hello there!", padding = 1)
```


<img src="rules-boxes-trees_files/figure-html//unnamed-chunk-17.svg" width="100%" />


```asciicast
boxx("Hello there!", padding = c(1, 5, 1, 5))
```


<img src="rules-boxes-trees_files/figure-html//unnamed-chunk-18.svg" width="100%" />


```asciicast
boxx("Hello there!", margin = 1)
```


<img src="rules-boxes-trees_files/figure-html//unnamed-chunk-19.svg" width="100%" />


```asciicast
boxx("Hello there!", margin = c(1, 5, 1, 5))
```


<img src="rules-boxes-trees_files/figure-html//unnamed-chunk-20.svg" width="100%" />

## Floating


```asciicast
boxx("Hello there!", padding = 1, float = "center")
```


<img src="rules-boxes-trees_files/figure-html//unnamed-chunk-21.svg" width="100%" />


```asciicast
boxx("Hello there!", padding = 1, float = "right")
```


<img src="rules-boxes-trees_files/figure-html//unnamed-chunk-22.svg" width="100%" />

## Colors


```asciicast
boxx(col_cyan("Hello there!"), padding = 1, float = "center")
```


<img src="rules-boxes-trees_files/figure-html//unnamed-chunk-23.svg" width="100%" />


```asciicast
boxx("Hello there!", padding = 1, background_col = "brown")
```


<img src="rules-boxes-trees_files/figure-html//unnamed-chunk-24.svg" width="100%" />


```asciicast
boxx("Hello there!", padding = 1, background_col = bg_red)
```


<img src="rules-boxes-trees_files/figure-html//unnamed-chunk-25.svg" width="100%" />


```asciicast
boxx("Hello there!", padding = 1, border_col = "green")
```


<img src="rules-boxes-trees_files/figure-html//unnamed-chunk-26.svg" width="100%" />


```asciicast
boxx("Hello there!", padding = 1, border_col = col_red)
```


<img src="rules-boxes-trees_files/figure-html//unnamed-chunk-27.svg" width="100%" />

## Label alignment


```asciicast
boxx(c("Hi", "there", "you!"), padding = 1, align = "left")
```


<img src="rules-boxes-trees_files/figure-html//unnamed-chunk-28.svg" width="100%" />


```asciicast
boxx(c("Hi", "there", "you!"), padding = 1, align = "center")
```


<img src="rules-boxes-trees_files/figure-html//unnamed-chunk-29.svg" width="100%" />


```asciicast
boxx(c("Hi", "there", "you!"), padding = 1, align = "right")
```


<img src="rules-boxes-trees_files/figure-html//unnamed-chunk-30.svg" width="100%" />

## A very customized box


```asciicast
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
```


<img src="rules-boxes-trees_files/figure-html//unnamed-chunk-31.svg" width="100%" />

# Trees

You can specify the tree with a two column data frame, containing the
node ids/labels, and the list of their children.


```asciicast
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


<img src="rules-boxes-trees_files/figure-html//unnamed-chunk-32.svg" width="100%" />

An optional third column may contain custom labels. These can be colored
as well:


```asciicast
data$label <- paste(data$package,
  col_grey(paste0("(", c("2.0.0.1", "1.1.1", "0.2.0", "1.2-11",
    "1.5", "1.2", "1.2.0", "1.0.2", "2.0.0", "1.1.1.9000", "1.1.2",
    "2.2.2", "1.3.4", "1.0.2", "0.6.12", "2.2.1", "1.2.1.9002",
    "1.0.0.9000", "2.0.1", "0.20-35"), ")"))
  )
roots <- ! data$package %in% unlist(data$dependencies)
data$label[roots] <- col_cyan(style_italic(data$label[roots]))
tree(data, root = "rcmdcheck")
```


<img src="rules-boxes-trees_files/figure-html//unnamed-chunk-33.svg" width="100%" />
