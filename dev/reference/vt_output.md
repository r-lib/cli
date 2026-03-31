# Simulate (a subset of) a VT-5xx ANSI terminal

This is utility function that calculates the state of a VT-5xx screen
after a certain set of output.

## Usage

``` r
vt_output(output, width = 80L, height = 25L)
```

## Arguments

- output:

  Character vector or raw vector. Character vectors are collapsed
  (without a separator), and converted to a raw vector using
  [`base::charToRaw()`](https://rdrr.io/r/base/rawConversion.html).

- width:

  Terminal width.

- height:

  Terminal height.

## Value

Data frame with columns `lineno`, `segmentno`, `segment`, `attributes`.

## Details

Currently it supports:

- configurable terminal width and height

- ASCII printable characters.

- `\n`, `\r`.

- ANSI SGR colors, 8 color mode, 256 color mode and true color mode.

- Other ANSI SGR features: bold, italic, underline, strikethrough,
  blink, inverse.

It does *not* currently supports other features, mode notably:

- Other ANSI control sequences and features. Other control sequences are
  silently ignored.

- Wide Unicode characters. Their width is not taken into account
  correctly.

- Unicode graphemes.

## Note

This function is experimental, and the virtual terminal API will likely
change in future versions of cli.
