# Frequently Asked Questions

Frequently Asked Questions

## Details

### My platform supports ANSI colors, why does cli not use them?

It is probably a mistake in the ANSI support detection algorithm. Please
open an issue at <https://github.com/r-lib/cli/issues> and do not forget
to tell us the details of your platform and terminal or GUI.

### How do I turn off ANSI colors and styles?

Set the `NO_COLOR` environment variable to a non-empty value. You can do
this in your `.Renviron` file (use
[`usethis::edit_r_environ()`](https://usethis.r-lib.org/reference/edit.html)).

If you want to do this for testthat tests, then consider using the 3rd
edition on testthat, which does turn off ANSI styling automatically
inside `test_that()`.

### cli does not show the output before [`file.choose()`](https://rdrr.io/r/base/file.choose.html)

Try calling
[`flush.console()`](https://rdrr.io/r/utils/flush.console.html) to flush
the console, before
[`file.choose()`](https://rdrr.io/r/base/file.choose.html). If flushing
does not work and you are in RStudio, then it is probably this RStudio
bug: <https://github.com/rstudio/rstudio/issues/8040> See more details
at <https://github.com/r-lib/cli/issues/151>

### Why are heading separators wider than my screen in RStudio?

The display width of some Unicode characters ambiguous in the Unicode
standard. Some software treats them as narrow (one column on the
screen), other as wide (two columns). In some terminal emulators (for
example iTerm2), you can configure the preferred behavior.

Unfortunately the box drawing characters that cli uses also have
ambiguous width.

In RStudio the behavior depends on the font. In particular, Consolas,
Courier and Inconsolata treats them as wide characters, so cli output
will not look great with these. Some good, modern fonts that look good
include Menlo, Fira Code and Source Code Pro.

If you do not want to change your font, you can also turn off Unicode
output, by setting the `cli.unicode` option:

    options(cli.unicode = FALSE)

A related issue: <https://github.com/r-lib/cli/issues/320>

### Is there a suggested font to use with cli?

In modern terminals, cli output usually looks good.

If you see too wide heading separators in RStudio, then see the previous
question: Why are heading separators wider than my screen in RStudio?.

If some output is garbled, then cli probably misdetected Unicode support
for your terminal or font. You can try choosing a different font. In our
experience output looks good with Menlo, Fira Code and Source Code Pro.
Alternatively you can turn off Unicode output:

    options(cli.unicode = FALSE)

If you think this is our fault, then please also file an issue at
<https://github.com/r-lib/cli/issues>
