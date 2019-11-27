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
-   Create CLI elements in subprocesses, using the
    [callr](https://github.com/r-lib/callr) package.
-   All CLI text can contain interpreted string literals, via the
    [glue](https://github.com/tidyverse/glue) package.

Installation
============

Install the stable version from CRAN:

``` r
install.packages("cli")
```

Usage
-----

TODO

License
=======

MIT © RStudio
