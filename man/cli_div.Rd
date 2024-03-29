% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/cli.R
\name{cli_div}
\alias{cli_div}
\title{Generic CLI container}
\usage{
cli_div(
  id = NULL,
  class = NULL,
  theme = NULL,
  .auto_close = TRUE,
  .envir = parent.frame()
)
}
\arguments{
\item{id}{Element id, a string. If \code{NULL}, then a new id is generated
and returned.}

\item{class}{Class name, sting. Can be used in themes.}

\item{theme}{A custom theme for the container. See \link{themes}.}

\item{.auto_close}{Whether to close the container, when the calling
function finishes (or \code{.envir} is removed, if specified).}

\item{.envir}{Environment to evaluate the glue expressions in. It is
also used to auto-close the container if \code{.auto_close} is \code{TRUE}.}
}
\value{
The id of the new container element, invisibly.
}
\description{
See \link{containers}. A \code{cli_div} container is special, because it may
add new themes, that are valid within the container.
}
\details{
\subsection{Custom themes}{

\if{html}{\out{<div class="sourceCode r">}}\preformatted{d <- cli_div(theme = list(h1 = list(color = "cyan",
                                    "font-weight" = "bold")))
cli_h1("Custom title")
cli_end(d)
}\if{html}{\out{</div>}}\if{html}{\out{
<div class="asciicast" style="color: #172431;font-family: 'Fira Code',Monaco,Consolas,Menlo,'Bitstream Vera Sans Mono','Powerline Symbols',monospace;line-height: 1.300000"><pre>
#>                                                                                 
#> <span style="font-weight: bold;color: #2AA198;">Custom title</span>                                                                    
</pre></div>
}}

}

\subsection{Auto-closing}{

By default a \code{cli_div()} is closed automatically when the calling
frame exits.

\if{html}{\out{<div class="sourceCode r">}}\preformatted{div <- function() \{
  cli_div(class = "tmp", theme = list(.tmp = list(color = "yellow")))
  cli_text("This is yellow")
\}
div()
cli_text("This is not yellow any more")
}\if{html}{\out{</div>}}\if{html}{\out{
<div class="asciicast" style="color: #172431;font-family: 'Fira Code',Monaco,Consolas,Menlo,'Bitstream Vera Sans Mono','Powerline Symbols',monospace;line-height: 1.300000"><pre>
#> <span style="color: #B58900;">This is yellow</span>                                                                  
#> This is not yellow any more                                                     
</pre></div>
}}

}
}
