# About cli pluralization

About cli pluralization

## Introduction

cli has tools to create messages that are printed correctly in singular
and plural forms. This usually requires minimal extra work, and
increases the quality of the messages greatly. In this document we first
show some pluralization examples that you can use as guidelines.
Hopefully these are intuitive enough, so that they can be used without
knowing the exact cli pluralization rules.

If you need pluralization without the semantic cli functions, see the
[`pluralize()`](https://cli.r-lib.org/reference/pluralize.md) function.

## Examples

### Pluralization markup

In the simplest case the message contains a single
[`{}`](https://rdrr.io/r/base/Paren.html) glue substitution, which
specifies the quantity that is used to select between the singular and
plural forms. Pluralization uses markup that is similar to glue, but
uses the `{?` and `}` delimiters:

    library(cli)
    nfile <- 0; cli_text("Found {nfile} file{?s}.")

    #> Found 0 files.

    nfile <- 1; cli_text("Found {nfile} file{?s}.")

    #> Found 1 file.

    nfile <- 2; cli_text("Found {nfile} file{?s}.")

    #> Found 2 files.

Here the value of `nfile` is used to decide whether the singular or
plural form of `file` is used. This is the most common case for English
messages.

### Irregular plurals

If the plural form is more difficult than a simple `s` suffix, then the
singular and plural forms can be given, separated with a forward slash:

    ndir <- 1; cli_text("Found {ndir} director{?y/ies}.")

    #> Found 1 directory.

    ndir <- 5; cli_text("Found {ndir} director{?y/ies}.")

    #> Found 5 directories.

### Use `"no"` instead of zero

For readability, it is better to use the
[`no()`](https://cli.r-lib.org/reference/pluralization-helpers.md)
helper function to include a count in a message.
[`no()`](https://cli.r-lib.org/reference/pluralization-helpers.md)
prints the word `"no"` if the count is zero, and prints the numeric
count otherwise:

    nfile <- 0; cli_text("Found {no(nfile)} file{?s}.")

    #> Found no files.

    nfile <- 1; cli_text("Found {no(nfile)} file{?s}.")

    #> Found 1 file.

    nfile <- 2; cli_text("Found {no(nfile)} file{?s}.")

    #> Found 2 files.

### Use the length of character vectors

With the auto-collapsing feature of cli it is easy to include a list of
objects in a message. When cli interprets a character vector as a
pluralization quantity, it takes the length of the vector:

    pkgs <- "pkg1"
    cli_text("Will remove the {.pkg {pkgs}} package{?s}.")

    #> Will remove the pkg1 package.

    pkgs <- c("pkg1", "pkg2", "pkg3")
    cli_text("Will remove the {.pkg {pkgs}} package{?s}.")

    #> Will remove the pkg1, pkg2, and pkg3 packages.

Note that the length is only used for non-numeric vectors (when
`is.numeric(x)` return `FALSE`). If you want to use the length of a
numeric vector, convert it to character via
[`as.character()`](https://rdrr.io/r/base/character.html).

You can combine collapsed vectors with `"no"`, like this:

    pkgs <- character()
    cli_text("Will remove {?no/the/the} {.pkg {pkgs}} package{?s}.")

    #> Will remove no packages.

    pkgs <- c("pkg1", "pkg2", "pkg3")
    cli_text("Will remove {?no/the/the} {.pkg {pkgs}} package{?s}.")

    #> Will remove the pkg1, pkg2, and pkg3 packages.

When the pluralization markup contains three alternatives, like above,
the first one is used for zero, the second for one, and the third one
for larger quantities.

### Choosing the right quantity

When the text contains multiple glue
[`{}`](https://rdrr.io/r/base/Paren.html) substitutions, the one right
before the pluralization markup is used. For example:

    nfiles <- 3; ndirs <- 1
    cli_text("Found {nfiles} file{?s} and {ndirs} director{?y/ies}")

    #> Found 3 files and 1 directory

This is sometimes not the the correct one. You can explicitly specify
the correct quantity using the
[`qty()`](https://cli.r-lib.org/reference/pluralization-helpers.md)
function. This sets that quantity without printing anything:

    nupd <- 3; ntotal <- 10
    cli_text("{nupd}/{ntotal} {qty(nupd)} file{?s} {?needs/need} updates")

    #> 3/10 files need updates

Note that if the message only contains a single
[`{}`](https://rdrr.io/r/base/Paren.html) substitution, then this may
appear before or after the pluralization markup. If the message contains
multiple [`{}`](https://rdrr.io/r/base/Paren.html) substitutions *after*
pluralization markup, an error is thrown.

Similarly, if the message contains no
[`{}`](https://rdrr.io/r/base/Paren.html) substitutions at all, but has
pluralization markup, an error is thrown.

## Rules

The exact rules of cli pluralization. There are two sets of rules. The
first set specifies how a quantity is associated with a `{?}`
pluralization markup. The second set describes how the `{?}` is parsed
and interpreted.

### Quantities

1.  [`{}`](https://rdrr.io/r/base/Paren.html) substitutions define
    quantities. If the value of a
    [`{}`](https://rdrr.io/r/base/Paren.html) substitution is numeric
    (when `is.numeric(x)` holds), then it has to have length one to
    define a quantity. This is only enforced if the
    [`{}`](https://rdrr.io/r/base/Paren.html) substitution is used for
    pluralization. The quantity is defined as the value of
    [`{}`](https://rdrr.io/r/base/Paren.html) then, rounded with
    [`as.integer()`](https://rdrr.io/r/base/integer.html). If the value
    of [`{}`](https://rdrr.io/r/base/Paren.html) is not numeric, then
    its quantity is defined as its length.

2.  If a message has `{?}` markup but no
    [`{}`](https://rdrr.io/r/base/Paren.html) substitution, an error is
    thrown.

3.  If a message has exactly one
    [`{}`](https://rdrr.io/r/base/Paren.html) substitution, its value is
    used as the pluralization quantity for all `{?}` markup in the
    message.

4.  If a message has multiple [`{}`](https://rdrr.io/r/base/Paren.html)
    substitutions, then for each `{?}` markup cli uses the quantity of
    the [`{}`](https://rdrr.io/r/base/Paren.html) substitution that
    precedes it.

5.  If a message has multiple [`{}`](https://rdrr.io/r/base/Paren.html)
    substitutions and has pluralization markup without a preceding
    [`{}`](https://rdrr.io/r/base/Paren.html) substitution, an error is
    thrown.

### Pluralization markup

1.  Pluralization markup starts with `{?` and ends with `}`. It may not
    contain `{` and `}` characters, so it may not contain
    [`{}`](https://rdrr.io/r/base/Paren.html) substitutions either.

2.  Alternative words or suffixes are separated by `/`.

3.  If there is a single alternative, then *nothing* is used if
    `quantity == 1` and this single alternative is used if
    `quantity != 1`.

4.  If there are two alternatives, the first one is used for
    `quantity == 1`, the second one for `quantity != 1` (including
    \``quantity == 0`).

5.  If there are three alternatives, the first one is used for
    `quantity == 0`, the second one for `quantity == 1`, and the third
    one otherwise.

## See also

Other pluralization:
[`no()`](https://cli.r-lib.org/reference/pluralization-helpers.md),
[`pluralize()`](https://cli.r-lib.org/reference/pluralize.md)
