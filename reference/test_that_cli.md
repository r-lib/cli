# Test cli output with testthat

Use this function in your testthat test files, to test cli output. It
requires testthat edition 3, and works best with snapshot tests.

## Usage

``` r
test_that_cli(
  desc,
  code,
  configs = c("plain", "ansi", "unicode", "fancy"),
  links = NULL
)
```

## Arguments

- desc:

  Test description, passed to
  [`testthat::test_that()`](https://testthat.r-lib.org/reference/test_that.html),
  after appending the name of the cli configuration to it.

- code:

  Test code, it is modified to set up the cli config, and then passed to
  [`testthat::test_that()`](https://testthat.r-lib.org/reference/test_that.html)

- configs:

  cli configurations to test `code` with. The default is `NULL`, which
  includes all possible configurations. It can also be a character
  vector, to restrict the tests to some configurations only. See
  available configurations below.

- links:

  Whether to run the code with various hyperlinks allowed. If `NULL`
  then hyperlinks are turned off. Otherwise it can be a character vector
  with possible hyperlink configurations:

  - `"all"`: turn on all hyperlinks,

  - `"none"`: turn off all hyperlinks.

## Details

`test_that_cli()` calls
[`testthat::test_that()`](https://testthat.r-lib.org/reference/test_that.html)
multiple times, with different cli configurations. This makes it simple
to test cli output with and without ANSI colors, with and without
Unicode characters.

Currently available configurations:

- `plain`: no ANSI colors, ASCII characters only.

- `ansi`: ANSI colors, ASCII characters only.

- `unicode`: no ANSI colors, Unicode characters.

- `fancy`; ANSI colors, Unicode characters.

See examples below and in cli's own tests, e.g. in
<https://github.com/r-lib/cli/tree/main/tests/testthat> and the
corresponding snapshots at
<https://github.com/r-lib/cli/tree/main/tests/testthat/_snaps>

### Important note regarding Windows

Because of base R's limitation to record Unicode characters on Windows,
we suggest that you record your snapshots on Unix, or you restrict your
tests to ASCII configurations.

Unicode tests on Windows are automatically skipped by testthat
currently.

## Examples

``` r
# testthat cannot record or compare snapshots when you run these
# examples interactively, so you might want to copy them into a test
# file

# Default configurations
cli::test_that_cli("success", {
  testthat::local_edition(3)
  testthat::expect_snapshot({
    cli::cli_alert_success("wow")
  })
})
#> ── Snapshot ───────────────────────────────────────────────────────────
#> ℹ Can't save or compare to reference when testing interactively.
#> Code
#>   cli::cli_alert_success("wow")
#> Message
#>   v wow
#> ───────────────────────────────────────────────────────────────────────
#> ── Skip: success [plain] ──────────────────────────────────────────────
#> Reason: empty test
#> ── Snapshot ───────────────────────────────────────────────────────────
#> ℹ Can't save or compare to reference when testing interactively.
#> Code
#>   cli::cli_alert_success("wow")
#> Message
#>   v wow
#> ───────────────────────────────────────────────────────────────────────
#> ── Skip: success [ansi] ───────────────────────────────────────────────
#> Reason: empty test
#> ── Snapshot ───────────────────────────────────────────────────────────
#> ℹ Can't save or compare to reference when testing interactively.
#> Code
#>   cli::cli_alert_success("wow")
#> Message
#>   ✔ wow
#> ───────────────────────────────────────────────────────────────────────
#> ── Skip: success [unicode] ────────────────────────────────────────────
#> Reason: empty test
#> ── Snapshot ───────────────────────────────────────────────────────────
#> ℹ Can't save or compare to reference when testing interactively.
#> Code
#>   cli::cli_alert_success("wow")
#> Message
#>   ✔ wow
#> ───────────────────────────────────────────────────────────────────────
#> ── Skip: success [fancy] ──────────────────────────────────────────────
#> Reason: empty test
#> [[1]]
#> [1] FALSE
#> 
#> [[2]]
#> [1] FALSE
#> 
#> [[3]]
#> [1] FALSE
#> 
#> [[4]]
#> [1] FALSE
#> 
#> [[5]]
#> NULL
#> 
#> [[6]]
#> NULL
#> 
#> [[7]]
#> NULL
#> 
#> [[8]]
#> NULL
#> 
#> [[9]]
#> NULL
#> 
#> [[10]]
#> NULL
#> 
#> [[11]]
#> NULL
#> 
#> [[12]]
#> NULL
#> 

# Only use two configurations, because this output does not have colors
cli::test_that_cli(configs = c("plain", "unicode"), "cat_bullet", {
  testthat::local_edition(3)
  testthat::expect_snapshot({
    cli::cat_bullet(letters[1:5])
  })
})
#> ── Snapshot ───────────────────────────────────────────────────────────
#> ℹ Can't save or compare to reference when testing interactively.
#> Code
#>   cli::cat_bullet(letters[1:5])
#> Output
#>   * a
#>   * b
#>   * c
#>   * d
#>   * e
#> ───────────────────────────────────────────────────────────────────────
#> ── Skip: cat_bullet [plain] ───────────────────────────────────────────
#> Reason: empty test
#> ── Snapshot ───────────────────────────────────────────────────────────
#> ℹ Can't save or compare to reference when testing interactively.
#> Code
#>   cli::cat_bullet(letters[1:5])
#> Output
#>   • a
#>   • b
#>   • c
#>   • d
#>   • e
#> ───────────────────────────────────────────────────────────────────────
#> ── Skip: cat_bullet [unicode] ─────────────────────────────────────────
#> Reason: empty test
#> [[1]]
#> [1] FALSE
#> 
#> [[2]]
#> NULL
#> 
#> [[3]]
#> [1] FALSE
#> 
#> [[4]]
#> NULL
#> 
#> [[5]]
#> NULL
#> 
#> [[6]]
#> NULL
#> 
#> [[7]]
#> NULL
#> 
#> [[8]]
#> NULL
#> 
#> [[9]]
#> NULL
#> 
#> [[10]]
#> NULL
#> 
#> [[11]]
#> NULL
#> 
#> [[12]]
#> NULL
#> 

# You often need to evaluate all cli calls of a test case in the same
# environment. Use `local()` to do that:
cli::test_that_cli("theming", {
  testthat::local_edition(3)
  testthat::expect_snapshot(local({
    cli::cli_div(theme = list(".alert" = list(before = "!!! ")))
    cli::cli_alert("wow")
  }))
})
#> ── Snapshot ───────────────────────────────────────────────────────────
#> ℹ Can't save or compare to reference when testing interactively.
#> Code
#>   local({
#>     cli::cli_div(theme = list(.alert = list(before = "!!! ")))
#>     cli::cli_alert("wow")
#>   })
#> Message
#>   !!! wow
#> ───────────────────────────────────────────────────────────────────────
#> ── Skip: theming [plain] ──────────────────────────────────────────────
#> Reason: empty test
#> ── Snapshot ───────────────────────────────────────────────────────────
#> ℹ Can't save or compare to reference when testing interactively.
#> Code
#>   local({
#>     cli::cli_div(theme = list(.alert = list(before = "!!! ")))
#>     cli::cli_alert("wow")
#>   })
#> Message
#>   !!! wow
#> ───────────────────────────────────────────────────────────────────────
#> ── Skip: theming [ansi] ───────────────────────────────────────────────
#> Reason: empty test
#> ── Snapshot ───────────────────────────────────────────────────────────
#> ℹ Can't save or compare to reference when testing interactively.
#> Code
#>   local({
#>     cli::cli_div(theme = list(.alert = list(before = "!!! ")))
#>     cli::cli_alert("wow")
#>   })
#> Message
#>   !!! wow
#> ───────────────────────────────────────────────────────────────────────
#> ── Skip: theming [unicode] ────────────────────────────────────────────
#> Reason: empty test
#> ── Snapshot ───────────────────────────────────────────────────────────
#> ℹ Can't save or compare to reference when testing interactively.
#> Code
#>   local({
#>     cli::cli_div(theme = list(.alert = list(before = "!!! ")))
#>     cli::cli_alert("wow")
#>   })
#> Message
#>   !!! wow
#> ───────────────────────────────────────────────────────────────────────
#> ── Skip: theming [fancy] ──────────────────────────────────────────────
#> Reason: empty test
#> [[1]]
#> [1] FALSE
#> 
#> [[2]]
#> [1] FALSE
#> 
#> [[3]]
#> [1] FALSE
#> 
#> [[4]]
#> [1] FALSE
#> 
#> [[5]]
#> NULL
#> 
#> [[6]]
#> NULL
#> 
#> [[7]]
#> NULL
#> 
#> [[8]]
#> NULL
#> 
#> [[9]]
#> NULL
#> 
#> [[10]]
#> NULL
#> 
#> [[11]]
#> NULL
#> 
#> [[12]]
#> NULL
#> 
```
