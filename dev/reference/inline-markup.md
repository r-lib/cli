# About inline markup in the semantic cli

To learn how to use cli’s semantic markup, start with the ‘Building a
semantic CLI’ article at <https://cli.r-lib.org>.

## Command substitution

All text emitted by cli supports glue interpolation. Expressions
enclosed by braces will be evaluated as R code. See
[`glue::glue()`](https://glue.tidyverse.org/reference/glue.html) for
details.

In addition to regular glue interpolation, cli can also add classes to
parts of the text, and these classes can be used in themes. For example

    cli_text("This is {.emph important}.")

    #> This is important.

adds a class to the "important" word, class `"emph"`. Note that in this
case the string within the braces is usually not a valid R expression.
If you want to mix classes with interpolation, add another pair of
braces:

    adjective <- "great"
    cli_text("This is {.emph {adjective}}.")

    #> This is great.

An inline class will always create a `span` element internally. So in
themes, you can use the `span.emph` CSS selector to change how inline
text is emphasized:

    cli_div(theme = list(span.emph = list(color = "red")))
    adjective <- "nice and red"
    cli_text("This is {.emph {adjective}}.")

    #> This is nice and red.

## Classes

The default theme defines the following inline classes:

- `arg` for a function argument.

- `cls` for an S3, S4, R6 or other class name.

- `code` for a piece of code.

- `dt` is used for the terms in a definition list
  ([`cli_dl()`](https://cli.r-lib.org/dev/reference/cli_dl.md)).

- `dd` is used for the descriptions in a definition list
  ([`cli_dl()`](https://cli.r-lib.org/dev/reference/cli_dl.md)).

- `email` for an email address. If the terminal supports ANSI hyperlinks
  (e.g. RStudio, iTerm2, etc.), then cli creates a clickable link. See
  [links](https://cli.r-lib.org/dev/reference/links.md) for more
  information about cli hyperlinks.

- `emph` for emphasized text.

- `envvar` for the name of an environment variable.

- `field` for a generic field, e.g. in a named list.

- `file` for a file name. If the terminal supports ANSI hyperlinks (e.g.
  RStudio, iTerm2, etc.), then cli creates a clickable link that opens
  the file in RStudio or with the default app for the file type. See
  [links](https://cli.r-lib.org/dev/reference/links.md) for more
  information about cli hyperlinks.

- `fn` for a function name. If it is in the `package::function_name`
  form, and the terminal supports ANSI hyperlinks (e.g. RStudio, iTerm2,
  etc.), then cli creates a clickable link. See
  [links](https://cli.r-lib.org/dev/reference/links.md) for more
  information about cli hyperlinks.

- `fun` same as `fn`.

- `help` is a help page of a *function*. If the terminal supports ANSI
  hyperlinks to help pages (e.g. RStudio), then cli creates a clickable
  link. It supports link text. See
  [links](https://cli.r-lib.org/dev/reference/links.md) for more
  information about cli hyperlinks.

- `href` creates a hyperlink, potentially with a link text. If the
  terminal supports ANSI hyperlinks (e.g. RStudio, iTerm2, etc.), then
  cli creates a clickable link. See
  [links](https://cli.r-lib.org/dev/reference/links.md) for more
  information about cli hyperlinks.

- `kbd` for a keyboard key.

- `key` same as `kbd`.

- `obj_type_friendly` formats the type of an R object in a readable way,
  and it should be used with [`{}`](https://rdrr.io/r/base/Paren.html),
  see an example below.

- `or` changes the string that separates the last two elements of
  collapsed vectors (see below) from "and" to "or".

- `path` for a path (the same as `file` in the default theme).

- `pkg` for a package name.

- `run` is an R expression, that is potentially clickable if the
  terminal supports ANSI hyperlinks to runnable code (e.g. RStudio). It
  supports link text. See
  [links](https://cli.r-lib.org/dev/reference/links.md) for more
  information about cli hyperlinks.

- `str` for a double quoted string escaped by
  [`base::encodeString()`](https://rdrr.io/r/base/encodeString.html).

- `strong` for strong importance.

- `topic` is a help page of a *topic*. If the terminal supports ANSI
  hyperlinks to help pages (e.g. RStudio), then cli creates a clickable
  link. It supports link text. See
  [links](https://cli.r-lib.org/dev/reference/links.md) for more
  information about cli hyperlinks.

- `type` formats the type of an R object in a readable way, and it
  should be used with [`{}`](https://rdrr.io/r/base/Paren.html), see an
  example below.

- `url` for a URL. If the terminal supports ANSI hyperlinks (e.g.
  RStudio, iTerm2, etc.), then cli creates a clickable link. See
  [links](https://cli.r-lib.org/dev/reference/links.md) for more
  information about cli hyperlinks.

- `var` for a variable name.

- `val` for a generic "value".

- `vignette` is a vignette. If the terminal supports ANSI hyperlinks to
  help pages (e.g. RStudio), then cli creates a clickable link. It
  supports link text. See
  [links](https://cli.r-lib.org/dev/reference/links.md) for more
  information about cli hyperlinks.

    ul <- cli_ul()
    cli_li("{.emph Emphasized} text.")
    cli_li("{.strong Strong} importance.")
    cli_li("A piece of code: {.code sum(a) / length(a)}.")
    cli_li("A package name: {.pkg cli}.")
    cli_li("A function name: {.fn cli_text}.")
    cli_li("A keyboard key: press {.kbd ENTER}.")
    cli_li("A file name: {.file /usr/bin/env}.")
    cli_li("An email address: {.email bugs.bunny@acme.com}.")
    cli_li("A URL: {.url https://example.com}.")
    cli_li("An environment variable: {.envvar R_LIBS}.")
    cli_li("`mtcars` is {.obj_type_friendly {mtcars}}")
    cli_end(ul)

    #> • Emphasized text.
    #> • Strong importance.
    #> • A piece of code: `sum(a) / length(a)`.
    #> • A package name: cli.
    #> • A function name: `cli_text()`.
    #> • A keyboard key: press [ENTER].
    #> • A file name: /usr/bin/env.
    #> • An email address: bugs.bunny@acme.com.
    #> • A URL: <https://example.com>.
    #> • An environment variable: `R_LIBS`.
    #> • `mtcars` is a data frame

You can add new classes by defining them in the theme, and then using
them.

    cli_div(theme = list(
      span.myclass = list(color = "lightgrey"),
      "span.myclass" = list(before = "<<"),
      "span.myclass" = list(after = ">>")))
    cli_text("This is {.myclass in angle brackets}.")
    cli_end()

    #> This is <<in angle brackets>>.

### Highlighting weird-looking values

Often it is useful to highlight a weird file or path name, e.g. one that
starts or ends with space characters. The built-in theme does this for
`.file`, `.path` and `.email` by default. You can highlight any string
inline by adding the `.q` class to it.

The current highlighting algorithm

- adds single quotes to the string if it does not start or end with an
  alphanumeric character, underscore, dot or forward slash.

- Highlights the background colors of leading and trailing spaces on
  terminals that support ANSI colors.

## Collapsing inline vectors

When cli performs inline text formatting, it automatically collapses
glue substitutions, after formatting. This is handy to create lists of
files, packages, etc.

    pkgs <- c("pkg1", "pkg2", "pkg3")
    cli_text("Packages: {pkgs}.")
    cli_text("Packages: {.pkg {pkgs}}.")

    #> Packages: pkg1, pkg2, and pkg3.
    #> Packages: pkg1, pkg2, and pkg3.

Class names are collapsed differently by default

    x <- Sys.time()
    cli_text("Hey, {.var x} has class {.cls {class(x)}}.")

    #> Hey, `x` has class <POSIXct/POSIXt>.

By default cli truncates long vectors. The truncation limit is by
default twenty elements, but you can change it with the `vec-trunc`
style.

    nms <- cli_vec(names(mtcars), list("vec-trunc" = 5))
    cli_text("Column names: {nms}.")

    #> Column names: mpg, cyl, disp, …, gear, and carb.

## Formatting values

The `val` inline class formats values. By default (c.f. the built-in
theme), it calls the
[`cli_format()`](https://cli.r-lib.org/dev/reference/cli_format.md)
generic function, with the current style as the argument. See
[`cli_format()`](https://cli.r-lib.org/dev/reference/cli_format.md) for
examples.

`str` is for formatting strings, it uses
[`base::encodeString()`](https://rdrr.io/r/base/encodeString.html) with
double quotes.

## Escaping `{` and `}`

It might happen that you want to pass a string to `cli_*` functions, and
you do *not* want command substitution in that string, because it might
contain `{` and `}` characters. The simplest solution for this is to
refer to the string from a template:

    msg <- "Error in if (ncol(dat$y)) {: argument is of length zero"
    cli_alert_warning("{msg}")

    #> ! Error in if (ncol(dat$y)) {: argument is of length zero

If you want to explicitly escape `{` and `}` characters, just double
them:

    cli_alert_warning("A warning with {{ braces }}.")

    #> ! A warning with { braces }.

See also examples below.

## Pluralization

All cli commands that emit text support pluralization. Some examples:

    ndirs <- 1
    nfiles <- 13
    pkgs <- c("pkg1", "pkg2", "pkg3")
    cli_alert_info("Found {ndirs} director{?y/ies} and {nfiles} file{?s}.")
    cli_text("Will install {length(pkgs)} package{?s}: {.pkg {pkgs}}")

    #> ℹ Found 1 directory and 13 files.
    #> Will install 3 packages: pkg1, pkg2, and pkg3

See
[pluralization](https://cli.r-lib.org/dev/reference/pluralization.md)
for details.

## Wrapping

Most cli containers wrap the text to width the container's width, while
observing margins requested by the theme.

To avoid a line break, you can use the UTF_8 non-breaking space
character: `\u00a0`. cli will not break a line here.

To force a line break, insert a form feed character: `\f` or `\u000c`.
cli will insert a line break there.
