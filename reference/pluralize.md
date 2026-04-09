# String templating with pluralization

`pluralize()` is similar to
[`glue::glue()`](https://glue.tidyverse.org/reference/glue.html), with
two differences:

- It supports cli's
  [pluralization](https://cli.r-lib.org/reference/pluralization.md)
  syntax, using `{?}` markers.

- It collapses substituted vectors into a comma separated string.

## Usage

``` r
pluralize(
  ...,
  .envir = parent.frame(),
  .transformer = glue::identity_transformer
)
```

## Arguments

- ..., .envir, .transformer:

  All arguments are passed to
  [`glue::glue()`](https://glue.tidyverse.org/reference/glue.html).

## Details

See [pluralization](https://cli.r-lib.org/reference/pluralization.md)
and some examples below.

You need to install the glue package to use this function.

## See also

Other pluralization:
[`no()`](https://cli.r-lib.org/reference/pluralization-helpers.md),
[`pluralization`](https://cli.r-lib.org/reference/pluralization.md)

## Examples

``` r
# Regular plurals
nfile <- 0; pluralize("Found {nfile} file{?s}.")
#> Found 0 files.
nfile <- 1; pluralize("Found {nfile} file{?s}.")
#> Found 1 file.
nfile <- 2; pluralize("Found {nfile} file{?s}.")
#> Found 2 files.

# Irregular plurals
ndir <- 1; pluralize("Found {ndir} director{?y/ies}.")
#> Found 1 directory.
ndir <- 5; pluralize("Found {ndir} director{?y/ies}.")
#> Found 5 directories.

# Use 'no' instead of zero
nfile <- 0; pluralize("Found {no(nfile)} file{?s}.")
#> Found no files.
nfile <- 1; pluralize("Found {no(nfile)} file{?s}.")
#> Found 1 file.
nfile <- 2; pluralize("Found {no(nfile)} file{?s}.")
#> Found 2 files.

# Use the length of character vectors
pkgs <- "pkg1"
pluralize("Will remove the {pkgs} package{?s}.")
#> Will remove the pkg1 package.
pkgs <- c("pkg1", "pkg2", "pkg3")
pluralize("Will remove the {pkgs} package{?s}.")
#> Will remove the pkg1, pkg2, and pkg3 packages.

pkgs <- character()
pluralize("Will remove {?no/the/the} {pkgs} package{?s}.")
#> Will remove no  packages.
pkgs <- c("pkg1", "pkg2", "pkg3")
pluralize("Will remove {?no/the/the} {pkgs} package{?s}.")
#> Will remove the pkg1, pkg2, and pkg3 packages.

# Multiple quantities
nfiles <- 3; ndirs <- 1
pluralize("Found {nfiles} file{?s} and {ndirs} director{?y/ies}")
#> Found 3 files and 1 directory

# Explicit quantities
nupd <- 3; ntotal <- 10
cli_text("{nupd}/{ntotal} {qty(nupd)} file{?s} {?needs/need} updates")
#> 3/10 files need updates
```
