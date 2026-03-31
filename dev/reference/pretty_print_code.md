# Turn on pretty-printing functions at the R console

Defines a print method for functions, in the current session, that
supports syntax highlighting.

## Usage

``` r
pretty_print_code()
```

## Details

The new print method takes priority over the built-in one. Use
[`base::suppressMessages()`](https://rdrr.io/r/base/message.html) to
suppress the alert message.
