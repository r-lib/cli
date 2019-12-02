<!-- README.md is generated from README.Rmd. Please edit that file -->

cli
===

> Helpers for Developing Command Line Interfaces

[![Linux Build
Status](https://api.travis-ci.org/r-lib/cli.svg?branch=master)](https://travis-ci.org/r-lib/cli)
[![Windows Build
status](https://ci.appveyor.com/api/projects/status/github/r-lib/cli?svg=true)](https://ci.appveyor.com/project/gaborcsardi/cli)
[![](http://www.r-pkg.org/badges/version/cli)](http://www.r-pkg.org/pkg/cli)
[![CRAN RStudio mirror
downloads](http://cranlogs.r-pkg.org/badges/cli)](http://www.r-pkg.org/pkg/cli)
[![Coverage
Status](https://img.shields.io/codecov/c/github/r-lib/cli/master.svg)](https://codecov.io/github/r-lib/cli?branch=master)

A suite of tools to build attractive command line interfaces (CLIs),
from semantic elements: headers, lists, alerts, paragraphs, etc.
Supports theming via a CSS-like language. It also contains a number of
lower level CLI elements: rules, boxes, trees, and Unicode symbols with
ASCII alternatives. It integrates with the crayon package to support
ANSI terminal colors.

------------------------------------------------------------------------

Features
========

-   Build a CLI using semantic elements: headings, lists, alerts,
    paragraphs.
-   Theming via a CSS-like language.
-   Terminal colors via the [crayon](https://github.com/r-lib/crayon)
    package.
-   Create cli elements in subprocesses, using the
    [callr](https://github.com/r-lib/callr) package.
-   All cli text can contain interpreted string literals, via the
    [glue](https://github.com/tidyverse/glue) package.
-   Support for pluralized messages.

Installation
============

Install the stable version from CRAN:

``` r
install.packages("cli")
```

Short tour
----------

Some of the more commonly used cli elements, and features.

### Short alert messages

One liner messages to inform or warn.

``` asciicast
pkgs <- c("foo", "bar", "foobar")
cli_alert_success("Downloaded {length(pkgs)} packages.")
```

<img src="man/figures/README/unnamed-chunk-2.svg" width="100%" />

``` asciicast
db_url <- "example.com:port"
cli_alert_info("Reopened database {.url {db_url}}.")
```

<img src="man/figures/README/unnamed-chunk-3.svg" width="100%" />

``` asciicast
cli_alert_warning("Cannot reach GitHub, using local database cache.")
```

<img src="man/figures/README/unnamed-chunk-4.svg" width="100%" />

``` asciicast
cli_alert_danger("Failed to connect to database.")
```

<img src="man/figures/README/unnamed-chunk-5.svg" width="100%" />

``` asciicast
cli_alert("A generic alert")
```

<img src="man/figures/README/unnamed-chunk-6.svg" width="100%" />

### Headings

Three levels of headings.

``` asciicast
cli_h1("Heading 1")
```

<img src="man/figures/README/unnamed-chunk-7.svg" width="100%" />

``` asciicast
cli_h2("Heading 2")
```

<img src="man/figures/README/unnamed-chunk-8.svg" width="100%" />

``` asciicast
cli_h3("Heading 3")
```

<img src="man/figures/README/unnamed-chunk-9.svg" width="100%" />

### Lists

Ordered, unordered and description lists, that can be nested.

``` asciicast
fun <- function() {
  cli_ol()
  cli_li("Item 1")
  ulid <- cli_ul()
  cli_li("Subitem 1")
  cli_li("Subitem 2")
  cli_end(ulid)
  cli_li("Item 2")
  cli_end()
}
fun()
```

<img src="man/figures/README/unnamed-chunk-10.svg" width="100%" />

### Themes

Theming via a CSS-like language.

``` asciicast
fun <- function() {
  cli_div(theme = list(span.emph = list(color = "orange")))
  cli_text("This is very {.emph important}")
  cli_end()
  cli_text("Back to the {.emph previous theme}")
}
fun()
```

<img src="man/figures/README/unnamed-chunk-11.svg" width="100%" />

### Command substitution

Automatic command substitution via the
[glue](https://github.com/tidyverse/glue) package.

``` asciicast
size <- 123143123
dt <- 1.3454
cli_alert_info(c(
  "Downloaded {prettyunits::pretty_bytes(size)} in ",
  "{prettyunits::pretty_sec(dt)}"))
```

<img src="man/figures/README/unnamed-chunk-12.svg" width="100%" />

### Pluralization

Pluralization support.

``` asciicast
nfiles <- 3
ndirs <- 1
cli_alert_info("Found {nfiles} file{?s} and {ndirs} director{?y/ies}.")
```

<img src="man/figures/README/unnamed-chunk-13.svg" width="100%" />

Documentation
-------------

See at <https://cli.r-lib.org/> and also in the installed package:
`?"inline-markup"`, `?containers`, `?themes`, `?pluralization`.

License
=======

MIT © RStudio
