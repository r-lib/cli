# Syntax highlight R code

Syntax highlight R code

## Usage

``` r
code_highlight(code, code_theme = NULL, envir = NULL)
```

## Arguments

- code:

  Character vector, each element is one line of code.

- code_theme:

  Theme see
  [`code_theme_list()`](https://cli.r-lib.org/dev/reference/code_theme_list.md).

- envir:

  Environment to look up function calls for hyperlinks. If `NULL`, then
  the global search path is used.

## Value

Character vector, the highlighted code.

## Details

See
[`code_theme_list()`](https://cli.r-lib.org/dev/reference/code_theme_list.md)
for the default syntax highlighting theme and how to change it.

If `code` does not parse, then it is returned unchanged and a
`cli_parse_failure` condition is thrown. Note that this is not an error,
and the condition is ignored, unless explicitly caught.

## See also

Other syntax highlighting:
[`code_theme_list()`](https://cli.r-lib.org/dev/reference/code_theme_list.md)

## Examples

``` r
code_highlight(deparse(ls))
#>  [1] "\033[38;5;142mfunction\033[39m \033[38;5;178m(\033[39mname, pos = \033[38;5;178m-\033[39m\033[38;5;169m1L\033[39m, envir = \033[1mas.environment\033[22m\033[33m(\033[39mpos\033[33m)\033[39m, all.names = \033[38;5;169mFALSE\033[39m, "                                                                                                 
#>  [2] "    pattern, sorted = \033[38;5;169mTRUE\033[39m\033[38;5;178m)\033[39m "                                                                                                                                                                                                                                                                 
#>  [3] "\033[38;5;178m{\033[39m"                                                                                                                                                                                                                                                                                                                  
#>  [4] "    \033[38;5;142mif\033[39m \033[33m(\033[39m\033[38;5;178m!\033[39m\033[1mmissing\033[22m\033[34m(\033[39mname\033[34m)\033[39m\033[33m)\033[39m \033[33m{\033[39m"                                                                                                                                                                     
#>  [5] "        pos \033[38;5;178m<-\033[39m \033[1mtryCatch\033[22m\033[34m(\033[39mname, error = \033[38;5;142mfunction\033[39m\033[36m(\033[39me\033[36m)\033[39m e\033[34m)\033[39m"                                                                                                                                                          
#>  [6] "        \033[38;5;142mif\033[39m \033[34m(\033[39m\033[1minherits\033[22m\033[36m(\033[39mpos, \033[38;5;37m\"error\"\033[39m\033[36m)\033[39m\033[34m)\033[39m \033[34m{\033[39m"                                                                                                                                                        
#>  [7] "            name \033[38;5;178m<-\033[39m \033[1msubstitute\033[22m\033[36m(\033[39mname\033[36m)\033[39m"                                                                                                                                                                                                                                
#>  [8] "            \033[38;5;142mif\033[39m \033[36m(\033[39m\033[38;5;178m!\033[39m\033[1mis.character\033[22m\033[38;5;178m(\033[39mname\033[38;5;178m)\033[39m\033[36m)\033[39m "                                                                                                                                                             
#>  [9] "                name \033[38;5;178m<-\033[39m \033[1mdeparse\033[22m\033[36m(\033[39mname\033[36m)\033[39m"                                                                                                                                                                                                                               
#> [10] "            \033[1mwarning\033[22m\033[36m(\033[39m\033[1mgettextf\033[22m\033[38;5;178m(\033[39m\033[38;5;37m\"%s converted to character string\"\033[39m, "                                                                                                                                                                             
#> [11] "                \033[1msQuote\033[22m\033[33m(\033[39mname\033[33m)\033[39m\033[38;5;178m)\033[39m, domain = \033[38;5;169mNA\033[39m\033[36m)\033[39m"                                                                                                                                                                                   
#> [12] "            pos \033[38;5;178m<-\033[39m name"                                                                                                                                                                                                                                                                                            
#> [13] "        \033[34m}\033[39m"                                                                                                                                                                                                                                                                                                                
#> [14] "    \033[33m}\033[39m"                                                                                                                                                                                                                                                                                                                    
#> [15] "    all.names \033[38;5;178m<-\033[39m \033[1m.Internal\033[22m\033[33m(\033[39m\033[1mls\033[22m\033[34m(\033[39menvir, all.names, sorted\033[34m)\033[39m\033[33m)\033[39m"                                                                                                                                                             
#> [16] "    \033[38;5;142mif\033[39m \033[33m(\033[39m\033[38;5;178m!\033[39m\033[1mmissing\033[22m\033[34m(\033[39mpattern\033[34m)\033[39m\033[33m)\033[39m \033[33m{\033[39m"                                                                                                                                                                  
#> [17] "        \033[38;5;142mif\033[39m \033[34m(\033[39m\033[36m(\033[39mll \033[38;5;178m<-\033[39m \033[1mlength\033[22m\033[38;5;178m(\033[39m\033[1mgrep\033[22m\033[33m(\033[39m\033[38;5;37m\"[\"\033[39m, pattern, fixed = \033[38;5;169mTRUE\033[39m\033[33m)\033[39m\033[38;5;178m)\033[39m\033[36m)\033[39m \033[38;5;178m&&\033[39m "
#> [18] "            ll != \033[1mlength\033[22m\033[36m(\033[39m\033[1mgrep\033[22m\033[38;5;178m(\033[39m\033[38;5;37m\"]\"\033[39m, pattern, fixed = \033[38;5;169mTRUE\033[39m\033[38;5;178m)\033[39m\033[36m)\033[39m\033[34m)\033[39m \033[34m{\033[39m"                                                                                     
#> [19] "            \033[38;5;142mif\033[39m \033[36m(\033[39mpattern \033[38;5;178m==\033[39m \033[38;5;37m\"[\"\033[39m\033[36m)\033[39m \033[36m{\033[39m"                                                                                                                                                                                     
#> [20] "                pattern \033[38;5;178m<-\033[39m \033[38;5;37m\"\\\\[\"\033[39m"                                                                                                                                                                                                                                                          
#> [21] "                \033[1mwarning\033[22m\033[38;5;178m(\033[39m\033[38;5;37m\"replaced regular expression pattern '[' by  '\\\\\\\\['\"\033[39m\033[38;5;178m)\033[39m"                                                                                                                                                                     
#> [22] "            \033[36m}\033[39m"                                                                                                                                                                                                                                                                                                            
#> [23] "            \033[38;5;142melse\033[39m \033[38;5;142mif\033[39m \033[36m(\033[39m\033[1mlength\033[22m\033[38;5;178m(\033[39m\033[1mgrep\033[22m\033[33m(\033[39m\033[38;5;37m\"[^\\\\\\\\]\\\\[<-\"\033[39m, pattern\033[33m)\033[39m\033[38;5;178m)\033[39m\033[36m)\033[39m \033[36m{\033[39m"                                         
#> [24] "                pattern \033[38;5;178m<-\033[39m \033[1msub\033[22m\033[38;5;178m(\033[39m\033[38;5;37m\"\\\\[<-\"\033[39m, \033[38;5;37m\"\\\\\\\\\\\\[<-\"\033[39m, pattern\033[38;5;178m)\033[39m"                                                                                                                                     
#> [25] "                \033[1mwarning\033[22m\033[38;5;178m(\033[39m\033[38;5;37m\"replaced '[<-' by '\\\\\\\\[<-' in regular expression pattern\"\033[39m\033[38;5;178m)\033[39m"                                                                                                                                                               
#> [26] "            \033[36m}\033[39m"                                                                                                                                                                                                                                                                                                            
#> [27] "        \033[34m}\033[39m"                                                                                                                                                                                                                                                                                                                
#> [28] "        \033[1mgrep\033[22m\033[34m(\033[39mpattern, all.names, value = \033[38;5;169mTRUE\033[39m\033[34m)\033[39m"                                                                                                                                                                                                                      
#> [29] "    \033[33m}\033[39m"                                                                                                                                                                                                                                                                                                                    
#> [30] "    \033[38;5;142melse\033[39m all.names"                                                                                                                                                                                                                                                                                                 
#> [31] "\033[38;5;178m}\033[39m"                                                                                                                                                                                                                                                                                                                  
cat(code_highlight(deparse(ls)), sep = "\n")
#> function (name, pos = -1L, envir = as.environment(pos), all.names = FALSE, 
#>     pattern, sorted = TRUE) 
#> {
#>     if (!missing(name)) {
#>         pos <- tryCatch(name, error = function(e) e)
#>         if (inherits(pos, "error")) {
#>             name <- substitute(name)
#>             if (!is.character(name)) 
#>                 name <- deparse(name)
#>             warning(gettextf("%s converted to character string", 
#>                 sQuote(name)), domain = NA)
#>             pos <- name
#>         }
#>     }
#>     all.names <- .Internal(ls(envir, all.names, sorted))
#>     if (!missing(pattern)) {
#>         if ((ll <- length(grep("[", pattern, fixed = TRUE))) && 
#>             ll != length(grep("]", pattern, fixed = TRUE))) {
#>             if (pattern == "[") {
#>                 pattern <- "\\["
#>                 warning("replaced regular expression pattern '[' by  '\\\\['")
#>             }
#>             else if (length(grep("[^\\\\]\\[<-", pattern))) {
#>                 pattern <- sub("\\[<-", "\\\\\\[<-", pattern)
#>                 warning("replaced '[<-' by '\\\\[<-' in regular expression pattern")
#>             }
#>         }
#>         grep(pattern, all.names, value = TRUE)
#>     }
#>     else all.names
#> }
```
