# Capture the output of cli functions instead of printing it

Capture the output of cli functions instead of printing it

## Usage

``` r
cli_fmt(expr, collapse = FALSE, strip_newline = FALSE)
```

## Arguments

- expr:

  Expression to evaluate, containing `cli_*()` calls, typically.

- collapse:

  Whether to collapse the output into a single character scalar, or
  return a character vector with one element for each line.

- strip_newline:

  Whether to strip the trailing newline.

## Examples

``` r
cli_fmt({
  cli_alert_info("Loading data file")
  cli_alert_success("Loaded data file")
})
#> [1] "\033[36mℹ\033[39m Loading data file"
#> [2] "\033[32m✔\033[39m Loaded data file" 
```
