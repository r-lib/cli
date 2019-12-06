---
title: "From usethis::ui functions to cli"
author: "Gábor Csárdi"
date: "2019-12-06"
output:
  rmarkdown::html_vignette:
    keep_md: true
    toc: true
    toc_depth: 2
vignette: >
  %\VignetteIndexEntry{From usethis::ui functions to cli}
  %\VignetteEngine{cli::lazyrmd}
  %\VignetteEncoding{UTF-8}
---




```r
library(cli)
library(usethis)
```

# Introduction

We'll show how to transition from the `usethis::ui_*` functions to
cli 2.0.0.

# How to 

## `usethis::ui_code()`

```
usethis::ui_code(x)
```


```asciicast
ui_todo("Redocument with {ui_code('devtools::document()')}")
```


<img src="usethis-ui_files/figure-html//unnamed-chunk-2.svg" width="100%" />

In general inline code formatting can be done with inline styles in cli.
The default theme has a `"code"` class, but it also one for functions,
so this can be either of:


```asciicast
cli_ul("Redocument with {.code devtools::document()}")
```


<img src="usethis-ui_files/figure-html//unnamed-chunk-3.svg" width="100%" />


```asciicast
cli_ul("Redocument with {.fun devtools::document}")
```


<img src="usethis-ui_files/figure-html//unnamed-chunk-4.svg" width="100%" />

## `usethis::ui_code_block()`

```
usethis::ui_code_block(x, copy = interactive(), .envir = parent.frame())
```


```asciicast
ui_code_block("{format(cli_code)}")
```


<img src="usethis-ui_files/figure-html//unnamed-chunk-5.svg" width="100%" />

`cli_code()` produces similar output and it also syntax highlight R code:


```asciicast
cli_code(format(cli_code))
```


<img src="usethis-ui_files/figure-html//unnamed-chunk-6.svg" width="100%" />

However, cli does not copy stuff to the clipboard, so this has to be done
separately.

Another difference is that it also does not run glue substitutions on
the code text, so if you want that to happen you'll need to do that
before the cli call.

## `usethis::ui_done()`

```
usethis::ui_done(x, .envir = parent.frame())
```


```asciicast
name <- "VignetteBuilder"
value <- "knitr, rmarkdown"
ui_done("Setting {ui_field(name)} field in DESCRIPTION to {ui_value(value)}")
```


<img src="usethis-ui_files/figure-html//unnamed-chunk-7.svg" width="100%" />

This is probably closest to `cli_alert_success()`:


```asciicast
cli_alert_success("Setting {.field {name}} field in DESCRIPTION to {.val {value}}")
```


<img src="usethis-ui_files/figure-html//unnamed-chunk-8.svg" width="100%" />

If you want to handle success and failure, then maybe the `cli_process_*()`
functions are a better fit:


```asciicast
tryCatch({
    cli_process_start("Setting {.field {name}} field in DESCRIPTION to {.val {value}}")
    Sys.sleep(1) # <- do the task here, we just sleep
    cli_process_done() },
  error = function(err) {
    cli_process_failed()
    cli_alert_danger("Failed to ...")
  }
)
```


<img src="usethis-ui_files/figure-html//unnamed-chunk-9.svg" width="100%" />

## `usethis::ui_field()`

```
usethis::ui_field(x)
```


```asciicast
name <- "VignetteBuilder"
value <- "knitr, rmarkdown"
ui_done("Setting {ui_field(name)} field in DESCRIPTION to {ui_value(value)}")
```


<img src="usethis-ui_files/figure-html//unnamed-chunk-10.svg" width="100%" />

cli has a `"field"` class for inline styling:


```asciicast
cli_alert_success("Setting {.field {name}} field in DESCRIPTION to {.val {value}}")
```


<img src="usethis-ui_files/figure-html//unnamed-chunk-11.svg" width="100%" />

Just like `usethis::ui_field()` and similar usethis functions, cli collapses
inline vectors, before styling:


```asciicast
name <- c("Depends", "Imports", "Suggests")
ui_done("Setting the {ui_field(name)} field(s) in DESCRIPTION")
```


<img src="usethis-ui_files/figure-html//unnamed-chunk-12.svg" width="100%" />


```asciicast
cli_alert_success("Setting the {.field {name}} field{?s} in DESCRIPTION")
```


<img src="usethis-ui_files/figure-html//unnamed-chunk-13.svg" width="100%" />

cli also helps you with the correct pluralization:


```asciicast
name <- "Depends"
cli_alert_success("Setting the {.field {name}} field{?s} in DESCRIPTION")
```


<img src="usethis-ui_files/figure-html//unnamed-chunk-14.svg" width="100%" />

## `usethis::ui_info()`

```
usethis::ui_info((x, .envir = parent.frame())
```


```asciicast
ui_info("No labels need renaming")
```


<img src="usethis-ui_files/figure-html//unnamed-chunk-15.svg" width="100%" />

This is simply `cli_alert_info()`:


```asciicast
cli_alert_info("No labels need renaming")
```


<img src="usethis-ui_files/figure-html//unnamed-chunk-16.svg" width="100%" />

## `usethis::ui_line()`

```
usethis::ui_line(x, .envir = parent.frame())
```


```asciicast
ui_line("No matching issues/PRs found.")
```


<img src="usethis-ui_files/figure-html//unnamed-chunk-17.svg" width="100%" />

This is just a line of text, so `cli_text()` is fine for this. One difference
is that `cli_text()` will automatically wrap the long lines.



```asciicast
cli_text("No matching issues/PRs found.")
```


<img src="usethis-ui_files/figure-html//unnamed-chunk-18.svg" width="100%" />

## `usethis::ui_nope()`

```
ui_nope(x, .envir = parent.frame())
```

cli does not support user input currently, so this has to stay in usethis.

## `usethis::ui_oops()`

```
usethis::ui_oops(x, .envir = parent.frame())
```


```asciicast
ui_oops("Can't validate token. Is the network reachable?")
```


<img src="usethis-ui_files/figure-html//unnamed-chunk-19.svg" width="100%" />

This is mostly just `cli_alert_danger()`, but for see also the
`cli_process_*()` alternatives at `usethis::ui_done()`.

## `usethis::ui_path()`

```
usethis::ui_path(x, base = NULL)
```

`ui_path()` formats paths as relative to the project or the supplied
base directory, and also appends a `/` to directories. cli does not do
any of these, but it does have inline markup for files and paths:



```asciicast
logo_path <- file.path("man", "figures", "logo.svg")
img <- "/tmp/some-image.svg"
ui_done("Copied {ui_path(img)} to {ui_path(logo_path)}")
```


<img src="usethis-ui_files/figure-html//unnamed-chunk-20.svg" width="100%" />


```asciicast
cli_alert_success("Copied {.file {img}} to {.file {logo_path}}")
```


<img src="usethis-ui_files/figure-html//unnamed-chunk-21.svg" width="100%" />

## `usethis::ui_stop()`

```
usethis::ui_stop(x, .envir = parent.frame())
```

`ui_stop()` does glue substitution on the string, and then calls `stop()`
to throw an error.

cli does not have any tools to throw errors currently.

## `usethis::ui_todo()`

```
usethis::ui_todo(x, .envir = parent.frame())
```

This is a bullet, so either `cli_ul()` or `cli_alert_info()` should be
appropriate:


```asciicast
ui_todo("Redocument with {ui_code('devtools::document()')}")
```


<img src="usethis-ui_files/figure-html//unnamed-chunk-22.svg" width="100%" />


```asciicast
cli_ul("Redocument with {.fun devtools::document}")
```


<img src="usethis-ui_files/figure-html//unnamed-chunk-23.svg" width="100%" />

## `usethis::ui_value()`

```
usethis::ui_value(x)
```

The `"value"` inline class is appropriate for this.


```asciicast
name <- "VignetteBuilder"
value <- "knitr, rmarkdown"
ui_done("Setting {ui_field(name)} field in DESCRIPTION to {ui_value(value)}")
```


<img src="usethis-ui_files/figure-html//unnamed-chunk-24.svg" width="100%" />


```asciicast
cli_alert_success("Setting {.field {name}} field in DESCRIPTION to {.val {value}}")
```


<img src="usethis-ui_files/figure-html//unnamed-chunk-25.svg" width="100%" />

## `usethis::ui_warn()`

```
usethis::ui_warn(x, .envir = parent.frame())
```

`ui_warn()` does glue substitution on the string, and then calls `warning()`
to throw a warning.

cli does not have any tools to throw warnings currently.

## `usethis::ui_yeah()`

```
ui_yeah(x, .envir = parent.frame())
```

cli does not support user input currently, so this has to stay in usethis.
