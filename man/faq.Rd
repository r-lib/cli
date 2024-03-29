% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/docs.R
\name{faq}
\alias{faq}
\title{Frequently Asked Questions}
\description{
Frequently Asked Questions
}
\details{
\subsection{My platform supports ANSI colors, why does cli not use them?}{

It is probably a mistake in the ANSI support detection algorithm. Please
open an issue at \url{https://github.com/r-lib/cli/issues} and do not forget
to tell us the details of your platform and terminal or GUI.
}

\subsection{How do I turn off ANSI colors and styles?}{

Set the \code{NO_COLOR} environment variable to a non-empty value. You can do
this in your \code{.Renviron} file (use \code{usethis::edit_r_environ()}).

If you want to do this for testthat tests, then consider using the 3rd
edition on testthat, which does turn off ANSI styling automatically
inside \code{test_that()}.
}

\subsection{cli does not show the output before \code{file.choose()}}{

Try calling \code{flush.console()} to flush the console, before
\code{file.choose()}. If flushing does not work and you are in RStudio, then
it is probably this RStudio bug:
\url{https://github.com/rstudio/rstudio/issues/8040} See more details at
\url{https://github.com/r-lib/cli/issues/151}
}

\subsection{Why are heading separators wider than my screen in RStudio?}{

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
output, by setting the \code{cli.unicode} option:

\if{html}{\out{<div class="sourceCode r">}}\preformatted{options(cli.unicode = FALSE)
}\if{html}{\out{</div>}}

A related issue: \url{https://github.com/r-lib/cli/issues/320}
}

\subsection{Is there a suggested font to use with cli?}{

In modern terminals, cli output usually looks good.

If you see too wide heading separators in RStudio, then see the previous
question: Why are heading separators wider than my screen in RStudio?.

If some output is garbled, then cli probably misdetected Unicode support
for your terminal or font. You can try choosing a different font. In our
experience output looks good with Menlo, Fira Code and Source Code Pro.
Alternatively you can turn off Unicode output:

\if{html}{\out{<div class="sourceCode r">}}\preformatted{options(cli.unicode = FALSE)
}\if{html}{\out{</div>}}

If you think this is our fault, then please also file an issue at
\url{https://github.com/r-lib/cli/issues}
}
}
