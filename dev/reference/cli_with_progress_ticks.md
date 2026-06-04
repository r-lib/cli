# Evaluate an expression with forcing all progress bar updates enabled

Evaluates `expr` while redrawing the progress bar for every progress bar
update. This function is meant to be used in test cases, when
specifically testing the progress bar output.

## Usage

``` r
cli_with_progress_ticks(expr)
```

## Arguments

- expr:

  Expression to evaluate.

## Value

The value of `expr`.
