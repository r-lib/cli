# Syntax highlighting themes

`code_theme_list()` lists the built-in code themes.

## Usage

``` r
code_theme_list()
```

## Value

Character vector of the built-in code theme names.

## Code themes

A theme is a list of character vectors, except for `bracket`, see below.
Each character vector must contain RGB colors (e.g. `"#a9a9a9"`), and
cli styles, e.g. `"bold"`. Entries in the list:

- `reserved`: reserved words

- `number`: numeric literals

- `null`: the `NULL` constant

- `operator`: operators, including assignment

- `call`: function calls

- `string`: character literals

- `comment`: comments

- `bracket`: brackets: `(){}[]` This is a list of character vectors, to
  create "rainbow" brackets. It is recycled for deeply nested lists.

## The default code theme

In RStudio, it matches the current theme of the IDE.

You can use three options to customize the code theme:

- If `cli.code_theme` is set, it is used.

- Otherwise if R is running in RStudio and `cli.code_theme_rstudio` is
  set, then it is used.

- Otherwise if R is not running in RStudio and `cli.code_theme_terminal`
  is set, then it is used.

You can set these options to the name of a built-in theme, or to a list
that specifies a custom theme. See `code_theme_list()` for the list of
the built-in themes.

## See also

Other syntax highlighting:
[`code_highlight()`](https://cli.r-lib.org/reference/code_highlight.md)

## Examples

``` r
code_theme_list()
#>  [1] "Ambiance"              "Chaos"                
#>  [3] "Chrome"                "Clouds"               
#>  [5] "Clouds Midnight"       "Cobalt"               
#>  [7] "Crimson Editor"        "Dawn"                 
#>  [9] "Dracula"               "Dreamweaver"          
#> [11] "Eclipse"               "Idle Fingers"         
#> [13] "Katzenmilch"           "Kr Theme"             
#> [15] "Material"              "Merbivore"            
#> [17] "Merbivore Soft"        "Mono Industrial"      
#> [19] "Monokai"               "Pastel On Dark"       
#> [21] "Solarized Dark"        "Solarized Light"      
#> [23] "Textmate (default)"    "Tomorrow"             
#> [25] "Tomorrow Night"        "Tomorrow Night Blue"  
#> [27] "Tomorrow Night Bright" "Tomorrow Night 80s"   
#> [29] "Twilight"              "Vibrant Ink"          
#> [31] "Xcode"                
code_highlight(deparse(get), code_theme = "Solarized Dark")
#> [1] "\033[38;5;142mfunction\033[39m \033[38;5;178m(\033[39mx, pos = \033[38;5;178m-\033[39m\033[38;5;169m1L\033[39m, envir = \033[1mas.environment\033[22m\033[33m(\033[39mpos\033[33m)\033[39m, mode = \033[38;5;37m\"any\"\033[39m, "
#> [2] "    inherits = \033[38;5;169mTRUE\033[39m\033[38;5;178m)\033[39m "                                                                                                                                                                
#> [3] "\033[1m.Internal\033[22m\033[38;5;178m(\033[39m\033[1mget\033[22m\033[33m(\033[39mx, envir, mode, inherits\033[33m)\033[39m\033[38;5;178m)\033[39m"                                                                               
```
