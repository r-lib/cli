# The built-in CLI theme

This theme is always active, and it is at the bottom of the theme stack.
See [themes](https://cli.r-lib.org/reference/themes.md).

## Usage

``` r
builtin_theme(dark = getOption("cli.theme_dark", "auto"))
```

## Arguments

- dark:

  Whether to use a dark theme. The `cli.theme_dark` option can be used
  to request a dark theme explicitly. If this is not set, or set to
  `"auto"`, then cli tries to detect a dark theme, this works in recent
  RStudio versions and in iTerm on macOS.

## Value

A named list, a CLI theme.

## Showcase

    cli_h1("Heading 1")
    cli_h2("Heading 2")
    cli_h3("Heading 3")

    cli_par()
    cli_alert_danger("Danger alert")
    cli_alert_warning("Warning alert")
    cli_alert_info("Info alert")
    cli_alert_success("Success alert")
    cli_alert("Alert for starting a process or computation",
      class = "alert-start")
    cli_end()

    cli_text("Packages and versions: {.pkg cli} {.version 1.0.0}.")
    cli_text("Time intervals: {.timestamp 3.4s}")

    cli_text("{.emph Emphasis} and  {.strong strong emphasis}")

    cli_text("This is a piece of code: {.code sum(x) / length(x)}")
    cli_text("Function names: {.fn cli::simple_theme}")

    cli_text("Files: {.file /usr/bin/env}")
    cli_text("URLs: {.url https://r-project.org}")

    cli_h2("Longer code chunk")
    cli_par(class = "code R")
    cli_verbatim(
      '# window functions are useful for grouped mutates',
      'mtcars |>',
      '  group_by(cyl) |>',
      '  mutate(rank = min_rank(desc(mpg)))')

    #> ── Heading 1 ─────────────────────────────────────────────────────────
    #>
    #> ── Heading 2 ──
    #>
    #> ── Heading 3
    #> ✖ Danger alert
    #> ! Warning alert
    #> ℹ Info alert
    #> ✔ Success alert
    #> → Alert for starting a process or computation
    #>
    #> Packages and versions: cli 1.0.0.
    #> Time intervals: [3.4s]
    #> Emphasis and strong emphasis
    #> This is a piece of code: `sum(x) / length(x)`
    #> Function names: `cli::simple_theme()`
    #> Files: /usr/bin/env
    #> URLs: <https://r-project.org>
    #>
    #> ── Longer code chunk ──
    #>
    #> # window functions are useful for grouped mutates
    #> mtcars |>
    #>   group_by(cyl) |>
    #>   mutate(rank = min_rank(desc(mpg)))

## See also

[themes](https://cli.r-lib.org/reference/themes.md),
[`simple_theme()`](https://cli.r-lib.org/reference/simple_theme.md).
