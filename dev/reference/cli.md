# Compose multiple cli functions

`cli()` will record all `cli_*` calls in `expr`, and emit them together
in a single message. This is useful if you want to built a larger piece
of output from multiple `cli_*` calls.

## Usage

``` r
cli(expr)
```

## Arguments

- expr:

  Expression that contains `cli_*` calls. Their output is collected and
  sent as a single message.

## Value

Nothing.

## Details

Use this function to build a more complex piece of CLI that would not
make sense to show in pieces.

    cli({
      cli_h1("Title")
      cli_h2("Subtitle")
      cli_ul(c("this", "that", "end"))
    })

    #>
    #> ── Title ─────────────────────────────────────────────────────────────
    #>
    #> ── Subtitle ──
    #>
    #> • this
    #> • that
    #> • end
