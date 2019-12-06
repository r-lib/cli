---
title: "CLI pluralization"
author: "Gábor Csárdi"
date: "2019-12-06"
output:
  rmarkdown::html_vignette:
    keep_md: true
vignette: >
  %\VignetteIndexEntry{CLI pluralization}
  %\VignetteEngine{cli::lazyrmd}
  %\VignetteEncoding{UTF-8}
---





# Introduction

cli has tools to create messages that are printed correctly in singular
and plural forms. This usually requires minimal extra work, and increases
the quality of the messages greatly. In this document we first show some
pluralization examples that you can use as guidelines. Hopefully these
are intuitive enough, so that they can be used without knowing the exact
cli pluralization rules.

# Examples

## Pluralization markup

In the simplest case the message contains a single `{}` glue substitution,
which specifies the quantity that is used to select between the singular
and plural forms. Pluralization uses markup that is similar to glue, but
uses the `{?` and `}` delimiters:


```r
library(cli)
nfile <- 0; cli_text("Found {nfile} file{?s}.")
```

```
#> Found 0 files.
```

```r
nfile <- 1; cli_text("Found {nfile} file{?s}.")
```

```
#> Found 1 file.
```

```r
nfile <- 2; cli_text("Found {nfile} file{?s}.")
```

```
#> Found 2 files.
```

Here the value of `nfile` is used to decide whether the singular or plural
form of `file` is used. This is the most common case for English messages.

## Irregular plurals

If the plural form is more difficult than a simple `s` suffix, then the
singular and plural forms can be given, separated with a forward slash:


```r
ndir <- 1; cli_text("Found {ndir} director{?y/ies}.")
```

```
#> Found 1 directory.
```

```r
ndir <- 5; cli_text("Found {ndir} director{?y/ies}.")
```

```
#> Found 5 directories.
```

## Use "no" instead of zero

For readability, it is better to use the `no()` helper function to
include a count in a message. `no()` prints the word "no" if the count is
zero, and prints the numeric count otherwise:


```r
nfile <- 0; cli_text("Found {no(nfile)} file{?s}.")
```

```
#> Found no files.
```

```r
nfile <- 1; cli_text("Found {no(nfile)} file{?s}.")
```

```
#> Found 1 file.
```

```r
nfile <- 2; cli_text("Found {no(nfile)} file{?s}.")
```

```
#> Found 2 files.
```

## Use the length of character vectors

With the auto-collapsing feature of cli it is easy to include a list of
objects in a message. When cli interprets a character vector as a
pluralization quantity, it takes the length of the vector:


```r
pkgs <- "pkg1"
cli_text("Will remove the {.pkg {pkgs}} package{?s}.")
```

```
#> Will remove the pkg1 package.
```

```r
pkgs <- c("pkg1", "pkg2", "pkg3")
cli_text("Will remove the {.pkg {pkgs}} package{?s}.")
```

```
#> Will remove the pkg1, pkg2 and pkg3 packages.
```

Note that the length is only used for non-numeric vectors (when
`is.numeric(x)` return `FALSE`). If you want to use the length of a numeric
vector, convert it to character via `as.character()`.

You can combine collapsed vectors with "no", like this:


```r
pkgs <- character()
cli_text("Will remove {?no/the/the} {.pkg {pkgs}} package{?s}.")
```

```
#> Will remove no packages.
```

```r
pkgs <- c("pkg1", "pkg2", "pkg3")
cli_text("Will remove {?no/the/the} {.pkg {pkgs}} package{?s}.")
```

```
#> Will remove the pkg1, pkg2 and pkg3 packages.
```

When the pluralization markup contains three alternatives, like above,
the first one is used for zero, the second for one, and the third one
for larger quantities.

## Choosing the right quantity

When the text contains multiple glue `{}` substitutions, the one right
before the pluralization markup is used. For example:


```r
nfiles <- 3; ndirs <- 1
cli_text("Found {nfiles} file{?s} and {ndirs} director{?y/ies}")
```

```
#> Found 3 files and 1 directory
```

This is sometimes not the the correct one. You can explicitly specify
the correct quantity using the `qty()` function. This sets that quantity
without printing anything:


```r
nupd <- 3; ntotal <- 10
cli_text("{nupd}/{ntotal} {qty(nupd)} file{?s} {?needs/need} updates")
```

```
#> 3/10 files need updates
```

Note that if the message only contains a single `{}` substitution, then
this may appear before or after the pluralization markup. If the message
contains multiple `{}` substitutions _after_ pluralization markup, an
error is thrown.

Similarly, if the message contains no `{}` substituions at all, but
has pluralization markup, and error is thrown.

# Rules

The exact rules of cli's pluralization. There are two sets of rules.
The first set specifies how a quantity is associated with a `{?}`
pluralization markup. The second set describes how the `{?}` is parsed and
interpreted.

## Quantities

1. `{}` substitutions define quantities. If the value of a `{}` substitution
is numeric (i.e. `is.numeric(x)` holds), then it has to have length one to
define a quantity. This is only enforced if the `{}` substitution is used
for pluralization. The quantity is defined as the value of `{}` then,
rounded with `as.integer()`. If the value of `{}` is not numeric, then
its quantity is defined as its length.

1. If a message has `{?}` markup but no `{}` substitution, an error is
thrown.

1. If a message has exactly one `{}` substitution, its value is used as the
pluralization quantity for all `{?}` markup in the message.

1. If a message has multiple `{}` substitutions, then for each `{?}` markup
cli uses the quantity of the `{}` substitution that precedes it.

1. If a message has multiple `{}` substitutions and has pluralization
markup with a preceding `{}` substitution, and error is thrown.

## Pluralization markup

1. Pluralization markup start with `{?` and ends with `}`. It may not
contain `{` and `}` characters, so it may not contains `{}` substitutions
either.

1. Alternative words or suffixes are separated by `/`.

1. If there is a single alternative, then _nothing_ is used if
   `quantity == 1` and this single alternative is used if `quantity != 1`.

1. If there are two alternatives, the first one is used for `quantity == 1`,
   the second one for `quantity != 1` (include 0).

1. If there are three alternatives, the first one is used for
  `quantity == 0`, the second for `quantity == 1`, and the third otherwise.
