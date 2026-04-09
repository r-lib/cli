# Create a format method for an object using cli tools

This method can be typically used in
[`format()`](https://rdrr.io/r/base/format.html) S3 methods. Then the
[`print()`](https://rdrr.io/r/base/print.html) method of the class can
be easily defined in terms of such a
[`format()`](https://rdrr.io/r/base/format.html) method. See examples
below.

## Usage

``` r
cli_format_method(expr, theme = getOption("cli.theme"))
```

## Arguments

- expr:

  Expression that calls `cli_*` methods,
  [`base::cat()`](https://rdrr.io/r/base/cat.html) or
  [`base::print()`](https://rdrr.io/r/base/print.html) to format an
  object's printout.

- theme:

  Theme to use for the formatting.

## Value

Character vector, one element for each line of the printout.

## Examples

``` r
# Let's create format and print methods for a new S3 class that
# represents the an installed R package: `r_package`

# An `r_package` will contain the DESCRIPTION metadata of the package
# and also its installation path.
new_r_package <- function(pkg) {
  tryCatch(
    desc <- packageDescription(pkg),
    warning = function(e) stop("Cannot find R package `", pkg, "`")
  )
  file <- dirname(attr(desc, "file"))
  if (basename(file) != pkg) file <- dirname(file)
  structure(
    list(desc = unclass(desc), lib = dirname(file)),
    class = "r_package"
  )
}

format.r_package <- function(x, ...) {
  cli_format_method({
    cli_h1("{.pkg {x$desc$Package}} {cli::symbol$line} {x$desc$Title}")
    cli_text("{x$desc$Description}")
    cli_ul(c(
      "Version: {x$desc$Version}",
      if (!is.null(x$desc$Maintainer)) "Maintainer: {x$desc$Maintainer}",
      "License: {x$desc$License}"
    ))
    if (!is.na(x$desc$URL)) cli_text("See more at {.url {x$desc$URL}}")
  })
}

# Now the print method is easy:
print.r_package <- function(x, ...) {
  cat(format(x, ...), sep = "\n")
}

# Try it out
new_r_package("cli")
#> $desc
#> $desc$Package
#> [1] "cli"
#> 
#> $desc$Title
#> [1] "Helpers for Developing Command Line Interfaces"
#> 
#> $desc$Version
#> [1] "3.6.6"
#> 
#> $desc$`Authors@R`
#> [1] "c(\n    person(\"Gábor\", \"Csárdi\", , \"gabor@posit.co\", role = c(\"aut\", \"cre\")),\n    person(\"Hadley\", \"Wickham\", role = \"ctb\"),\n    person(\"Kirill\", \"Müller\", role = \"ctb\"),\n    person(\"Salim\", \"Brüggemann\", , \"salim-b@pm.me\", role = \"ctb\",\n           comment = c(ORCID = \"0000-0002-5329-5987\")),\n    person(\"Posit Software, PBC\", role = c(\"cph\", \"fnd\"),\n           comment = c(ROR = \"03wc8by49\"))\n  )"
#> 
#> $desc$Description
#> [1] "A suite of tools to build attractive command line interfaces\n    ('CLIs'), from semantic elements: headings, lists, alerts, paragraphs,\n    etc. Supports custom themes via a 'CSS'-like language. It also\n    contains a number of lower level 'CLI' elements: rules, boxes, trees,\n    and 'Unicode' symbols with 'ASCII' alternatives. It support ANSI\n    colors and text styles as well."
#> 
#> $desc$License
#> [1] "MIT + file LICENSE"
#> 
#> $desc$URL
#> [1] "https://cli.r-lib.org, https://github.com/r-lib/cli"
#> 
#> $desc$BugReports
#> [1] "https://github.com/r-lib/cli/issues"
#> 
#> $desc$Depends
#> [1] "R (>= 3.4)"
#> 
#> $desc$Imports
#> [1] "utils"
#> 
#> $desc$Suggests
#> [1] "callr, covr, crayon, digest, glue (>= 1.6.0), grDevices,\nhtmltools, htmlwidgets, knitr, methods, processx, ps (>=\n1.3.4.9000), rlang (>= 1.0.2.9003), rmarkdown, rprojroot,\nrstudioapi, testthat (>= 3.2.0), tibble, whoami, withr"
#> 
#> $desc$`Config/Needs/website`
#> [1] "r-lib/asciicast, bench, brio, cpp11, decor, desc,\nfansi, prettyunits, sessioninfo, tidyverse/tidytemplate,\nusethis, vctrs"
#> 
#> $desc$`Config/testthat/edition`
#> [1] "3"
#> 
#> $desc$`Config/usethis/last-upkeep`
#> [1] "2025-04-25"
#> 
#> $desc$Encoding
#> [1] "UTF-8"
#> 
#> $desc$RoxygenNote
#> [1] "7.3.2.9000"
#> 
#> $desc$RemotePkgRef
#> [1] "local::."
#> 
#> $desc$RemoteType
#> [1] "local"
#> 
#> $desc$NeedsCompilation
#> [1] "yes"
#> 
#> $desc$Packaged
#> [1] "2026-04-09 15:23:14 UTC; runner"
#> 
#> $desc$Author
#> [1] "Gábor Csárdi [aut, cre],\n  Hadley Wickham [ctb],\n  Kirill Müller [ctb],\n  Salim Brüggemann [ctb] (ORCID: <https://orcid.org/0000-0002-5329-5987>),\n  Posit Software, PBC [cph, fnd] (ROR: <https://ror.org/03wc8by49>)"
#> 
#> $desc$Maintainer
#> [1] "Gábor Csárdi <gabor@posit.co>"
#> 
#> $desc$Built
#> [1] "R 4.5.3; x86_64-pc-linux-gnu; 2026-04-09 15:23:16 UTC; unix"
#> 
#> attr(,"file")
#> [1] "/home/runner/work/_temp/Library/cli/Meta/package.rds"
#> 
#> $lib
#> [1] "/home/runner/work/_temp/Library"
#> 
#> attr(,"class")
#> [1] "r_package"

# The formatting of the output depends on the current theme:
opt <- options(cli.theme = simple_theme())
print(new_r_package("cli"))
#> 
#> ── cli ─ Helpers for Developing Command Line Interfaces ───────────────
#> A suite of tools to build attractive command line interfaces ('CLIs'),
#> from semantic elements: headings, lists, alerts, paragraphs, etc.
#> Supports custom themes via a 'CSS'-like language. It also contains a
#> number of lower level 'CLI' elements: rules, boxes, trees, and
#> 'Unicode' symbols with 'ASCII' alternatives. It support ANSI colors
#> and text styles as well.
#> • Version: 3.6.6
#> • Maintainer: Gábor Csárdi <gabor@posit.co>
#> • License: MIT + file LICENSE
#> See more at <https://cli.r-lib.org, https://github.com/r-lib/cli>
options(opt)  # <- restore theme
```
