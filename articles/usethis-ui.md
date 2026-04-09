# From usethis::ui functions to cli

## Introduction

``` r
library(cli)
library(usethis)
```

We’ll show how to transition from the `usethis::ui_*` functions to cli
2.0.0.

## How to

### `usethis::ui_code()`

#### Usage

    usethis::ui_code(x)

#### Example

``` r
ui_todo("Redocument with {ui_code('devtools::document()')}")
```

    #> • Redocument with `devtools::document()`                                        

#### With cli

In general inline code formatting can be done with inline styles in cli.
The default theme has a `"code"` class, but it also one for functions,
so this can be either of:

``` r
cli_ul("Redocument with {.code devtools::document()}")
```

    #> • Redocument with `devtools::document()`                                        

``` r
cli_ul("Redocument with {.fun devtools::document}")
```

    #> • Redocument with `devtools::document()`                                        

### `usethis::ui_code_block()`

#### Usage

    usethis::ui_code_block(x, copy = interactive(), .envir = parent.frame())

#### Example

``` r
ui_code_block("{format(cli_code)}")
```

    #>   function (lines = NULL, ..., language = "R", .auto_close = TRUE,              
    #> •       .envir = environment())                                                 
    #> •   {                                                                           
    #> •       lines <- c(lines, unlist(list(...)))                                    
    #> •       id <- cli_div(class = paste("code", language), .auto_close = .auto_close
    #> ,                                                                               
    #> •           .envir = .envir)                                                    
    #> •       cli_verbatim(lines)                                                     
    #> •       invisible(id)                                                           
    #> •   }                                                                           
    #>                                                                                 

#### With cli

[`cli_code()`](https://cli.r-lib.org/reference/cli_code.md) produces
similar output and it also syntax highlight R code:

``` r
cli_code(format(cli_code))
```

    #> function (lines = NULL, ..., language = "R", .auto_close = TRUE,                
    #>     .envir = environment())                                                     
    #> {                                                                               
    #>     lines <- c(lines, unlist(list(...)))                                        
    #>     id <- cli_div(class = paste("code", language), .auto_close = .auto_close,   
    #>         .envir = .envir)                                                        
    #>     cli_verbatim(lines)                                                         
    #>     invisible(id)                                                               
    #> }                                                                               

However, cli does not copy stuff to the clipboard, so this has to be
done separately.

Another difference is that it also does not run glue substitutions on
the code text, so if you want that to happen you’ll need to do that
before the cli call.

### `usethis::ui_done()`

#### Usage

    usethis::ui_done(x, .envir = parent.frame())

#### Example

``` r
name <- "VignetteBuilder"
value <- "knitr, rmarkdown"
ui_done("Setting {ui_field(name)} field in DESCRIPTION to {ui_value(value)}")
```

    #> ✔ Setting VignetteBuilder field in DESCRIPTION to 'knitr, rmarkdown'            

#### With cli

This is probably closest to
[`cli_alert_success()`](https://cli.r-lib.org/reference/cli_alert.md):

``` r
cli_alert_success("Setting {.field {name}} field in DESCRIPTION to {.val {value}}")
```

    #> ✔ Setting VignetteBuilder field in DESCRIPTION to "knitr, rmarkdown"            

If you want to handle success and failure, then maybe the
`cli_process_*()` functions are a better fit:

``` r
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

![First shows the task ('Setting...') in an 'i' (info) line. Then, when
the task is done, the 'i' is replaced with a tick mark and 'done' added
to the end of the line.](usethis-ui_files/figure-html/process.svg)

### `usethis::ui_field()`

#### Usage

    usethis::ui_field(x)

#### Example

``` r
name <- "VignetteBuilder"
value <- "knitr, rmarkdown"
ui_done("Setting {ui_field(name)} field in DESCRIPTION to {ui_value(value)}")
```

    #> ✔ Setting VignetteBuilder field in DESCRIPTION to 'knitr, rmarkdown'            

#### With cli

cli has a `"field"` class for inline styling:

``` r
cli_alert_success("Setting {.field {name}} field in DESCRIPTION to {.val {value}}")
```

    #> ✔ Setting VignetteBuilder field in DESCRIPTION to "knitr, rmarkdown"            

Just like
[`usethis::ui_field()`](https://usethis.r-lib.org/reference/ui-legacy-functions.html)
and similar usethis functions, cli collapses inline vectors, before
styling:

``` r
name <- c("Depends", "Imports", "Suggests")
ui_done("Setting the {ui_field(name)} field(s) in DESCRIPTION")
```

    #> ✔ Setting the Depends, Imports, Suggests field(s) in DESCRIPTION                

``` r
cli_alert_success("Setting the {.field {name}} field{?s} in DESCRIPTION")
```

    #> ✔ Setting the Depends, Imports, and Suggests fields in DESCRIPTION              

cli also helps you with the correct pluralization:

``` r
name <- "Depends"
cli_alert_success("Setting the {.field {name}} field{?s} in DESCRIPTION")
```

    #> ✔ Setting the Depends field in DESCRIPTION                                      

### `usethis::ui_info()`

#### Usage

    usethis::ui_info((x, .envir = parent.frame())

#### Example

``` r
ui_info("No labels need renaming")
```

    #> ℹ No labels need renaming                                                       

#### With cli

This is simply
[`cli_alert_info()`](https://cli.r-lib.org/reference/cli_alert.md):

``` r
cli_alert_info("No labels need renaming")
```

    #> ℹ No labels need renaming                                                       

### `usethis::ui_line()`

#### Usage

    usethis::ui_line(x, .envir = parent.frame())

#### Example

``` r
ui_line("No matching issues/PRs found.")
```

    #> No matching issues/PRs found.                                                   

#### With cli

This is just a line of text, so
[`cli_text()`](https://cli.r-lib.org/reference/cli_text.md) is fine for
this. One difference is that
[`cli_text()`](https://cli.r-lib.org/reference/cli_text.md) will
automatically wrap the long lines.

``` r
cli_text("No matching issues/PRs found.")
```

    #> No matching issues/PRs found.                                                   

### `usethis::ui_nope()`

#### Usage

    ui_nope(x, .envir = parent.frame())

#### With cli

cli does not support user input currently, so this has to stay in
usethis.

### `usethis::ui_oops()`

#### Usage

    usethis::ui_oops(x, .envir = parent.frame())

#### Example

``` r
ui_oops("Can't validate token. Is the network reachable?")
```

    #> ✖ Can't validate token. Is the network reachable?                               

#### With cli

This is mostly just
[`cli_alert_danger()`](https://cli.r-lib.org/reference/cli_alert.md),
but for see also the `cli_process_*()` alternatives at
[`usethis::ui_done()`](https://usethis.r-lib.org/reference/ui-legacy-functions.html).

### `usethis::ui_path()`

#### Usage

    usethis::ui_path(x, base = NULL)

#### Example

[`ui_path()`](https://usethis.r-lib.org/reference/ui-legacy-functions.html)
formats paths as relative to the project or the supplied base directory,
and also appends a `/` to directories.

``` r
logo_path <- file.path("man", "figures", "logo.svg")
img <- "/tmp/some-image.svg"
ui_done("Copied {ui_path(img)} to {ui_path(logo_path)}")
```

    #> ✔ Copied '/tmp/some-image.svg' to 'man/figures/logo.svg'                        

#### With cli

cli does not do any of these, but it does have inline markup for files
and paths:

``` r
cli_alert_success("Copied {.file {img}} to {.file {logo_path}}")
```

    #> ✔ Copied /tmp/some-image.svg to man/figures/logo.svg                            

### `usethis::ui_stop()`

#### Usage

    usethis::ui_stop(x, .envir = parent.frame())

#### Example

[`ui_stop()`](https://usethis.r-lib.org/reference/ui-legacy-functions.html)
does glue substitution on the string, and then calls
[`stop()`](https://rdrr.io/r/base/stop.html) to throw an error.

``` r
ui_stop("Could not copy {ui_path(img)} to  {ui_path(logo_path)}, file already exists")
```

    #> Error: Could not copy '/tmp/some-image.svg' to  'man/figures/logo.svg', file alr
    #> eady exists                                                                     

#### With cli

[`cli_abort()`](https://cli.r-lib.org/reference/cli_abort.md) does the
same and is formatted using
[`cli_bullets()`](https://cli.r-lib.org/reference/cli_bullets.md).

``` r
cli_abort(c(
  "Could not copy {.file {img}} to {.file {logo_path}}, file already exists",
  "i" = "You can set {.arg overwrite = TRUE} to avoid this error"
  ))
```

    #> Error:                                                                          
    #> ! Could not copy /tmp/some-image.svg to man/figures/logo.svg, file              
    #>   already exists                                                                
    #> ℹ You can set `overwrite = TRUE` to avoid this error                            
    #> Run `rlang::last_trace()` to see where the error occurred.                      

### `usethis::ui_todo()`

#### Usage

    usethis::ui_todo(x, .envir = parent.frame())

#### Example

``` r
ui_todo("Redocument with {ui_code('devtools::document()')}")
```

    #> • Redocument with `devtools::document()`                                        

#### With cli

This is a bullet, so either
[`cli_ul()`](https://cli.r-lib.org/reference/cli_ul.md) or
[`cli_alert_info()`](https://cli.r-lib.org/reference/cli_alert.md)
should be appropriate:

``` r
cli_ul("Redocument with {.fun devtools::document}")
```

    #> • Redocument with `devtools::document()`                                        

### `usethis::ui_value()`

#### Usage

    usethis::ui_value(x)

#### Example

``` r
name <- "VignetteBuilder"
value <- "knitr, rmarkdown"
ui_done("Setting {ui_field(name)} field in DESCRIPTION to {ui_value(value)}")
```

    #> ✔ Setting VignetteBuilder field in DESCRIPTION to 'knitr, rmarkdown'            

#### With cli

The `"value"` inline class is appropriate for this.

``` r
cli_alert_success("Setting {.field {name}} field in DESCRIPTION to {.val {value}}")
```

    #> ✔ Setting VignetteBuilder field in DESCRIPTION to "knitr, rmarkdown"            

### `usethis::ui_warn()`

#### Usage

    usethis::ui_warn(x, .envir = parent.frame())

#### Example

[`ui_warn()`](https://usethis.r-lib.org/reference/ui-legacy-functions.html)
does glue substitution on the string, and then calls
[`warning()`](https://rdrr.io/r/base/warning.html) to throw a warning.

``` r
ui_warn("Could not copy {ui_path(img)} to  {ui_path(logo_path)}, file already exists")
```

    #> Warning: Could not copy '/tmp/some-image.svg' to  'man/figures/logo.svg', file a
    #> lready exists                                                                   

#### With cli

[`cli_warn()`](https://cli.r-lib.org/reference/cli_abort.md) does the
same and is formatted using
[`cli_bullets()`](https://cli.r-lib.org/reference/cli_bullets.md).

``` r
cli_warn(c(
  "Could not copy {.file {img}} to {.file {logo_path}}, file already exists",
  "i" = "You can set {.arg overwrite = TRUE} to avoid this warning"
  ))
```

    #> Warning message:                                                                
    #> Could not copy /tmp/some-image.svg to man/figures/logo.svg, file already exists 
    #> ℹ You can set `overwrite = TRUE` to avoid this warning                          

### `usethis::ui_yeah()`

#### Usage

    ui_yeah(x, .envir = parent.frame())

#### With cli

cli does not support user input currently, so this has to stay in
usethis.
