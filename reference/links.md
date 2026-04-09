# cli hyperlinks

Certain cli styles create clickable links, if your IDE or terminal
supports them.

## Note: hyperlinks are currently experimental

The details of the styles that create hyperlinks will prrobably change
in the near future, based on user feedback.

## About the links in this manual page

The hyperlinks that are included in this manual are demonstrative only,
except for the `https:` links. They look like a hyperlink, and you can
click on them, but they do nothing. I.e. a `.run` link will not run the
linked expression if you click on it.

## Hyperlink Support

As of today, the latest release of RStudio (version v2022.07.0+548)
supports all hyperlink types discussed here. Certain terminals, e.g.
iTerm on macOS, Linux terminals based on VTE (GNOME terminal) support
`.href`, `.email` and `.file` links.

You can use
[`ansi_has_hyperlink_support()`](https://cli.r-lib.org/reference/style_hyperlink.md)
to check if your terminal or IDE has hyperlink support in general, and
[`ansi_hyperlink_types()`](https://cli.r-lib.org/reference/style_hyperlink.md)
to check if various types of hyperlinks are supported.

If your hyperlink support is not detected properly in your IDE or
terminal, please open a cli issue at
<https://github.com/r-lib/cli/issues>.

## Link text

Before we delve into the various types of hyperlinks, a general comment
about link texts. Some link styles support a custom link text:

- `.href`

- `.help`

- `.topic`

- `.vignette`

- `.run`

Others, i.e. `.email`, `.file`, `.fun` and `.url` do not support custom
link text.

The generic syntax for link text is the same as for Markdown hyperlinks:

    {.style [link text](url)}

### Vectorization

Note that it is not possible to add link text to a vector of URLs. E.g.
this will create a list of three URLs, all clickable:

    urls <- paste0("https://httpbin.org/status/", c(200, 403, 404))
    cli::cli_text("Some httpbin URLs: {.url {urls}}.")

    #> Some httpbin URLs: <https://httpbin.org/status/200>,
    #> <https://httpbin.org/status/403>, and
    #> <https://httpbin.org/status/404>.

But it is not possible to use a different link text for them.

### What if hyperlinks are not available?

If ANSI hyperlinks are not available, then the link text for of these
styles outputs both the link text and the URL in a (hopefully) helpful
way. See examples below.

## URLs

There are two cli styles to link to generic URLs. `.url` does not allow
custom link text, but `\href` does.

    cli_text(
      "See the cli homepage at {.url https://cli.r-lib.org} for details."
    )

    #> See the cli homepage at <https://cli.r-lib.org> for details.

    cli_text(
      "See the {.href [cli homepage](https://cli.r-lib.org)} for details."
    )

    #> See the cli homepage for details.

### Without hyperlink support

This is how these links look without hyperlink support:

    local({
      withr::local_options(cli.hyperlink = FALSE)
      cli_text(
        "See the cli homepage at {.url https://cli.r-lib.org} for details."
      )
      cli_text(
        "See the {.href [cli homepage](https://cli.r-lib.org)} for details."
      )
    })

    #> See the cli homepage at <https://cli.r-lib.org> for details.
    #> See the cli homepage (<https://cli.r-lib.org>) for details.

### URL encoding

Note that cli does not encode the url, so you might need to call
[`utils::URLencode()`](https://rdrr.io/r/utils/URLencode.html) on it,
especially, if it is substituted in via
[`{}`](https://rdrr.io/r/base/Paren.html).

    weirdurl <- utils::URLencode("https://example.com/has some spaces")
    cli_text("See more at {.url {weirdurl}}.")

    #> See more at <https://example.com/has%20some%20spaces>.

## Files

The `.file` style now automatically creates a `file:` hyperlink. Because
`file:` hyperlinks must contain an absolute path, cli tries to convert
relative paths, and paths starting with `~` to absolute path.

    cli_text("... edit your {.file ~/.Rprofile} file.")

    #> ... edit your ~/.Rprofile file.

### Link text

`.file` cannot use a custom link text. If you custom link text, then you
can use `.href` with a `file:` URL.

    prof <- path.expand("~/.Rprofile")
    cli_text("... edit your {.href [R profile](file://{prof})}.")

    #> ... edit your R profile.

### Line and column numbers

You may add a line number to a file name, separated by `:`. Handlers
typically place the cursor at that line after opening the file. You may
also add a column number, after the line number, separated by another
`:`.

    cli_text("... see line 5 in {.file ~/.Rprofile:5}.")

    #> ... see line 5 in ~/.Rprofile:5.

### Default handler

In RStudio `file:` URLs open within RStudio. If you click on a file link
outside of RStudio, typically the operating system is consulted for the
application to open it.

### Without hyperlink support

One issue with using `.href` file files is that it does not look great
if hyperlinks are not available. This will be improved in the future:

    local({
      withr::local_options(cli.hyperlink = FALSE)
      prof <- path.expand("~/.Rprofile")
      cli_text("... edit your {.href [R profile](file://{prof})}.")
    })

    #> ... edit your R profile (<file:///Users/gaborcsardi/.Rprofile>).

## Links to the manual

`.fun` automatically creates links to the manual page of the function,
provided the function name is in the `packagename::functionname` form:

    cli::cli_text("... see {.fun stats::lm} to learn more.")

    #> ... see `stats::lm()` to learn more.

### Link text

For a custom link text, use `.help` instead of `.fun`.

    cli::cli_text("... see {.help [{.fun lm}](stats::lm)} to learn more.")

    #> ... see `lm()` to learn more.

### Without hyperlink support

The same message without hyperlink support looks like this:

    local({
      withr::local_options(cli.hyperlink = FALSE)
      cli::cli_text("... see {.help [{.fun lm}](stats::lm)} to learn more.")
    })

    #> ... see `lm()` (`?stats::lm()`) to learn more.

### Topics

To link to a help topic that is not a function, use `.topic`:

    cli::cli_text("... the tibble options at {.topic tibble::tibble_options}.")

    #> ... the tibble options at tibble::tibble_options.

`.topic` support link text.

### Vignettes

To link to a vignette, use `.vignette`:

    cli::cli_text("... see the {.vignette tibble::types} vignette.")

    #> ... see the tibble::types vignette.

## Click to run code

RStudio also supports a special link type that runs R code in the
current R session upon clicking.

You can create these links with `.run`:

    cli::cli_text("Run {.run testthat::snapshot_review()} to review")

    #> Run testthat::snapshot_review() to review

### Link text

Sometimes you want to show a slightly different expression in the link,
than the one that is evaluated. E.g. the evaluated expression probably
needs to qualify packages with `::`, but you might not want to show
this:

    cli::cli_text(
      "Run {.run [snapshot_review()](testthat::snapshot_review())} to review"
    )

    #> Run snapshot_review() to review

### Security considerations

To make `.run` hyperlinks more secure, RStudio will not run code

- that is not in the `pkg::fun(args)` form,

- if `args` contains `(`, `)` or `;`,

- if it calls a core package (base, stats, etc.),

- if it calls a package that is not loaded, and it is not one of
  testthat, devtools, usethis, rlang, pkgload, or pkgdown which are
  explicitly allowed.

When RStudio does not run a `.run` hyperlink, then it shows the code and
the user can copy and paste it to the console, if they consider it safe
to run.

Note that depending on your version of RStudio, the behavior can change.
