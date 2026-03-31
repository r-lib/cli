# Create a spinner

Create a spinner

## Usage

``` r
make_spinner(
  which = NULL,
  stream = "auto",
  template = "{spin}",
  static = c("dots", "print", "print_line", "silent")
)
```

## Arguments

- which:

  The name of the chosen spinner. If `NULL`, then the default is used,
  which can be customized via the `cli.spinner_unicode`,
  `cli.spinner_ascii` and `cli.spinner` options. (The latter applies to
  both Unicode and ASCII displays. These options can be set to the name
  of a built-in spinner, or to a list that has an entry called `frames`,
  a character vector of frames.

- stream:

  The stream to use for the spinner. Typically this is standard error,
  or maybe the standard output stream. It can also be a string, one of
  `"auto"`, `"message"`, `"stdout"`, `"stderr"`. `"auto"` will select
  [`stdout()`](https://rdrr.io/r/base/showConnections.html) if the
  session is interactive and there are no sinks, otherwise it will
  select [`stderr()`](https://rdrr.io/r/base/showConnections.html).

- template:

  A template string, that will contain the spinner. The spinner itself
  will be substituted for `{spin}`. See example below.

- static:

  What to do if the terminal does not support dynamic displays:

  - `"dots"`: show a dot for each `$spin()` call.

  - `"print"`: just print the frames of the spinner, one after another.

  - `"print_line"`: print the frames of the spinner, each on its own
    line.

  - `"silent"` do not print anything, just the `template`.

## Value

A `cli_spinner` object, which is a list of functions. See its methods
below.

`cli_spinner` methods:

- `$spin()`: output the next frame of the spinner.

- `$finish()`: terminate the spinner. Depending on terminal capabilities
  this removes the spinner from the screen. Spinners can be reused, you
  can start calling the `$spin()` method again.

All methods return the spinner object itself, invisibly.

The spinner is automatically throttled to its ideal update frequency.

## Examples

### Default spinner

    sp1 <- make_spinner()
    fun_with_spinner <- function() {
      lapply(1:100, function(x) { sp1$spin(); Sys.sleep(0.05) })
      sp1$finish()
    }
    ansi_with_hidden_cursor(fun_with_spinner())

![](figures/make-spinner-default.svg)

### Spinner with a template

    sp2 <- make_spinner(template = "Computing {spin}")
    fun_with_spinner2 <- function() {
      lapply(1:100, function(x) { sp2$spin(); Sys.sleep(0.05) })
      sp2$finish()
    }
    ansi_with_hidden_cursor(fun_with_spinner2())

![](figures/make-spinner-template.svg)

### Custom spinner

    sp3 <- make_spinner("simpleDotsScrolling", template = "Downloading {spin}")
    fun_with_spinner3 <- function() {
      lapply(1:100, function(x) { sp3$spin(); Sys.sleep(0.05) })
      sp3$finish()
    }
    ansi_with_hidden_cursor(fun_with_spinner3())

![](figures/make-spinner-custom.svg)

## See also

Other spinners:
[`demo_spinners()`](https://cli.r-lib.org/dev/reference/demo_spinners.md),
[`get_spinner()`](https://cli.r-lib.org/dev/reference/get_spinner.md),
[`list_spinners()`](https://cli.r-lib.org/dev/reference/list_spinners.md)
