# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

`cli` is an R package for building command line interfaces: semantic elements (headings, lists, alerts, paragraphs), CSS-like theming, ANSI colors/styles, progress bars, rich error/warning messages, and pluralization. It has both an R layer and a C layer (`src/`), and is a foundational dependency for much of the R ecosystem, so backward compatibility and correctness matter a lot.

## Development commands

This package has compiled C code, so you must recompile after editing anything in `src/`. Use the `uncovr` helpers (they handle compilation + instrumentation):

```r
uncovr::reload()      # compile C code and (re)load the package
uncovr::test()        # run the test suite (testthat, edition 3)
uncovr::document()    # regenerate roxygen2 docs (man/*.Rd and NAMESPACE)
```

To run R CMD check (set `NOT_CRAN` so tests that are skipped on CRAN still run):

```r
withr::with_envvar(c(NOT_CRAN = "true", DISPLAY = ""), rcmdcheck::rcmdcheck())
```

Running a single test file or a single test:

```r
uncovr::test(filter = "keypress")          # run tests/testthat/test-keypress.R
```

Code is formatted with [air](https://posit-dev.github.io/air/) (see `air.toml`). A GitHub Action suggests formatting fixes on PRs.

## Architecture

### R / C split

The semantic CLI, theming, and most formatting logic live in R (`R/`). Performance-sensitive and OS-level primitives live in C (`src/`):

- ANSI/UTF-8/string-width handling (`ansi.c`, `utf8.c`, `width.c`-related, `charwidth.h`)
- the VT100 parser (`vt.c`, `vtparse*.c`) used to interpret/strip terminal control sequences
- the progress bar engine (`progress.c`, `progress-altrep.c`) — progress state is shared with R via an ALTREP
- keypress reading (`keypress*.c`, split into `keypress-unix.c` / `keypress-win.c`)
- hashing (`md5.c`, `sha1.c`, `sha256.c`, `xxhash*.c`) and `diff.c`, `glue.c`

C entry points are registered in `src/init.c` via `.Call`. `RCC(...)` registers functions that use the **cleancall** mechanism (`cleancall.c/.h`) for C-level resource cleanup; plain `R_CallMethodDef` entries (e.g. `cli_keypress`) are registered the normal way. When you add a C function callable from R, register it in `init.c`. Header `inst/include/cli/progress.h` is the public C API other packages link against — treat changes to it as part of the package's external contract.

### The "app" model

CLI output flows through a stack of **app** objects, not direct printing. `start_app()` / `stop_app()` / `default_app()` (in `R/app.R`) manage a global app stack in `cliappenv$stack`. An app (`R/cliapp.R`) is a closure-based object (via `new_class`) holding the active themes, container stack, and output connection. The user-facing `cli_*` functions (e.g. `cli_h1`, `cli_alert`, `cli_ul`) emit a *condition* (a `cliMessage`) that the default app formats and prints. The internal counterparts are named `clii_*` (app methods) and `clii__*` (lower-level helpers).

`cli({ ... })` (in `R/cli.R`) records multiple `cli_*` calls and emits them as one combined message, using the `cli.record` option and the `cli_recorded` registry. Themes are CSS-like selector/style rules matched against the container tree (`R/themes.R`, `R/simple-theme.R`, `R/containers.R`).

### Inline markup and glue

cli text supports interpreted string literals via glue, plus inline classes like `{.url ...}`, `{.file ...}`, `{.emph ...}`. Inline span handling is in `R/inline.R`; glue integration in `R/glue.R`; pluralization (`{?s}`, `{qty()}`) in `R/pluralize.R`.

### Loading & global state

`R/onload.R` sets up package-level mutable state in the `clienv` environment (PID, timers, progress/status registries, load time). Note the `.onLoad` cursor-restore finalizer and task callback. Timing is configurable via env vars (`CLI_TICK_TIME`, `CLI_SPEED_TIME`, `R_CLI_HIDE_CURSOR`).

## Testing conventions

- testthat edition 3 with snapshot tests. Snapshots live in `tests/testthat/_snaps/`. After an intentional output change, review `testthat::snapshot_review()` / accept with `testthat::snapshot_accept()`.
- `tests/testthat/setup.R` flushes gcov coverage data on teardown (`clic__gcov_flush`) and cleans `.gcda` files — this supports the coverage-instrumented test runs.
- `tests/testthat/helper.R` defines capture helpers central to testing output: `capture_msgs()`, `capture_cli_messages()` (catches `cliMessage` conditions), `capt()`, and `local_cli_config()`. Use these rather than asserting on raw printed output.
- `progresstest/` and `progresstestcpp/` are small embedded test packages exercising the C progress API from C and C++.
- Many tests are environment-sensitive (terminal width, number of ANSI colors, UTF-8 support, TTY detection). Tests pin these via `local_cli_config()` / options so they are reproducible off a real terminal.

## Documentation

- Roxygen2 (version 8.0.0) generates `man/` and `NAMESPACE` — never edit those by hand; edit the roxygen comments and run `uncovr::document()`.
- Many `.Rd` examples use **asciicast** ` ```{asciicast ...} ` code chunks (rendered to SVG for the website) rather than plain `\examples`. Match the surrounding style when adding examples.
- `README.md` is generated from `README.Rmd` (via `make` / `Makefile`) — edit the `.Rmd`.
- Update `NEWS.md` for user-facing changes.
