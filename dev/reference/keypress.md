# Read a single keypress at the terminal

It currently only works at Linux/Unix and OSX terminals, and at the
Windows command line. see
[`has_keypress_support`](https://cli.r-lib.org/dev/reference/has_keypress_support.md).

## Usage

``` r
keypress(block = TRUE)
```

## Arguments

- block:

  Whether to wait for a key press, if there is none available now.

## Value

The key pressed, a character scalar. For non-blocking reads `NA` is
returned if no keys are available.

## Details

The following special keys are supported:

- Arrow keys: 'up', 'down', 'right', 'left'.

- Function keys: from 'f1' to 'f12'.

- Others: 'home', 'end', 'insert', 'delete', 'pageup', 'pagedown',
  'tab', 'enter', 'backspace' (same as 'delete' on OSX keyboards),
  'escape'.

- Control with one of the following keys: 'a', 'b', 'c', 'd', 'e', 'f',
  'h', 'k', 'l', 'n', 'p', 't', 'u', 'w'.

## See also

Other keypress function:
[`has_keypress_support()`](https://cli.r-lib.org/dev/reference/has_keypress_support.md)

## Examples

``` r
if (FALSE) {
x <- keypress()
cat("You pressed key", x, "\n")
}
```
