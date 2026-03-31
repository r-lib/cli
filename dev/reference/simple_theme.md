# A simple CLI theme

To use this theme, you can set it as the `cli.theme` option. Note that
this is in addition to the builtin theme, which is still in effect.

## Usage

``` r
simple_theme(dark = getOption("cli.theme_dark", "auto"))
```

## Arguments

- dark:

  Whether the theme should be optimized for a dark background. If
  `"auto"`, then cli will try to detect this. Detection usually works in
  recent RStudio versions, and in iTerm on macOS, but not on other
  platforms.

## Details

    options(cli.theme = cli::simple_theme())

and then CLI apps started after this will use it as the default theme.
You can also use it temporarily, in a div element:

    cli_div(theme = cli::simple_theme())

## Showcase

    show <- cli_div(theme = cli::simple_theme())

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

    cli_end(show)

    #>
    #> ── Heading 1 ─────────────────────────────────────────────────────────
    #>
    #> ─ Heading 2 ──
    #>
    #> Heading 3
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
    #> Function names: `cli::simple_theme()`()
    #> Files: /usr/bin/env
    #> URLs: <https://r-project.org>
    #>
    #> ─ Longer code chunk ──
    #> # window functions are useful for grouped mutates
    #> mtcars |>
    #>   group_by(cyl) |>
    #>   mutate(rank = min_rank(desc(mpg)))
    #>

## See also

[themes](https://cli.r-lib.org/dev/reference/themes.md),
[`builtin_theme()`](https://cli.r-lib.org/dev/reference/builtin_theme.md).
