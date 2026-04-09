# List of built-in cli progress styles

The following options are used to select a style:

- `cli_progress_bar_style`

- `cli_progress_bar_style_ascii`

- `cli_progress_bar_style_unicode`

## Usage

``` r
cli_progress_styles()
```

## Value

A named list with sublists containing elements `complete`, `incomplete`
and potentially `current`.

## Details

On Unicode terminals (if
[`is_utf8_output()`](https://cli.r-lib.org/reference/is_utf8_output.md)
is `TRUE`), the `cli_progress_bar_style_unicode` and
`cli_progress_bar_style` options are used.

On ASCII terminals (if
[`is_utf8_output()`](https://cli.r-lib.org/reference/is_utf8_output.md)
is `FALSE`), the `cli_pgoress_bar_style_ascii` and
`cli_progress_bar_style` options are are used.

    for (style in names(cli_progress_styles())) {
      options(cli.progress_bar_style = style)
      label <- ansi_align(paste0("Style '", style, "'"), 20)
      print(cli_progress_demo(label, live = FALSE, at = 66, total = 100))
    }
    options(cli.progress_var_style = NULL)

    #> Style 'classic'      #####################             66% | ETA:  3s
    #> Style 'squares'      ■■■■■■■■■■■■■■■■■■■■■             66% | ETA:  3s
    #> Style 'dot'          ────────────────────●──────────   66% | ETA:  3s
    #> Style 'fillsquares'  ■■■■■■■■■■■■■■■■■■■■■□□□□□□□□□□   66% | ETA:  3s
    #> Style 'bar'          ███████████████████████████████   66% | ETA:  3s

## See also

Other progress bar functions:
[`cli_progress_along()`](https://cli.r-lib.org/reference/cli_progress_along.md),
[`cli_progress_bar()`](https://cli.r-lib.org/reference/cli_progress_bar.md),
[`cli_progress_builtin_handlers()`](https://cli.r-lib.org/reference/cli_progress_builtin_handlers.md),
[`cli_progress_message()`](https://cli.r-lib.org/reference/cli_progress_message.md),
[`cli_progress_num()`](https://cli.r-lib.org/reference/progress-utils.md),
[`cli_progress_output()`](https://cli.r-lib.org/reference/cli_progress_output.md),
[`cli_progress_step()`](https://cli.r-lib.org/reference/cli_progress_step.md),
[`progress-variables`](https://cli.r-lib.org/reference/progress-variables.md)
