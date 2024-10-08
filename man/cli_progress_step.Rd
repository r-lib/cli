% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/progress-client.R
\name{cli_progress_step}
\alias{cli_progress_step}
\title{Simplified cli progress messages, with styling}
\usage{
cli_progress_step(
  msg,
  msg_done = msg,
  msg_failed = msg,
  spinner = FALSE,
  class = if (!spinner) ".alert-info",
  current = TRUE,
  .auto_close = TRUE,
  .envir = parent.frame(),
  ...
)
}
\arguments{
\item{msg}{Message to show. It may contain glue substitution and cli
styling. It can be updated via \code{\link[=cli_progress_update]{cli_progress_update()}}, as usual.
It is style as a cli info alert (see \code{\link[=cli_alert_info]{cli_alert_info()}}).}

\item{msg_done}{Message to show on successful termination. By default
this it is the same as \code{msg} and it is styled as a cli success alert
(see \code{\link[=cli_alert_success]{cli_alert_success()}}).}

\item{msg_failed}{Message to show on unsuccessful termination. By
default it is the same as \code{msg} and it is styled as a cli danger alert
(see \code{\link[=cli_alert_danger]{cli_alert_danger()}}).}

\item{spinner}{Whether to show a spinner at the beginning of the line.
To make the spinner spin, you'll need to call \code{cli_progress_update()}
regularly.}

\item{class}{cli class to add to the message. By default there is no
class for steps with a spinner.}

\item{current}{Passed to \code{\link[=cli_progress_bar]{cli_progress_bar()}}.}

\item{.auto_close}{Passed to \code{\link[=cli_progress_bar]{cli_progress_bar()}}.}

\item{.envir}{Passed to \code{\link[=cli_progress_bar]{cli_progress_bar()}}.}

\item{...}{Passed to \code{\link[=cli_progress_bar]{cli_progress_bar()}}.}
}
\description{
This is a simplified progress bar, a single (dynamic)
message, without progress units.
}
\details{
\code{cli_progress_step()} always shows the progress message,
even if no update is due.
\subsection{Basic use}{

\if{html}{\out{<div class="sourceCode r">}}\preformatted{f <- function() \{
  cli_progress_step("Downloading data")
  Sys.sleep(2)
  cli_progress_step("Importing data")
  Sys.sleep(1)
  cli_progress_step("Cleaning data")
  Sys.sleep(2)
  cli_progress_step("Fitting model")
  Sys.sleep(3)
\}
f()
}\if{html}{\out{</div>}}

\if{html}{\figure{progress-step.svg}}
}

\subsection{Spinner}{

You can add a spinner to some or all steps with \code{spinner = TRUE},
but note that this will only work if you call \code{\link[=cli_progress_update]{cli_progress_update()}}
regularly.

\if{html}{\out{<div class="sourceCode r">}}\preformatted{f <- function() \{
  cli_progress_step("Downloading data", spinner = TRUE)
  for (i in 1:100) \{ Sys.sleep(2/100); cli_progress_update() \}
  cli_progress_step("Importing data")
  Sys.sleep(1)
  cli_progress_step("Cleaning data")
  Sys.sleep(2)
  cli_progress_step("Fitting model", spinner = TRUE)
  for (i in 1:100) \{ Sys.sleep(3/100); cli_progress_update() \}
\}
f()
}\if{html}{\out{</div>}}

\if{html}{\figure{progress-step-spin.svg}}
}

\subsection{Dynamic messages}{

You can make the step messages dynamic, using glue templates.
Since \code{cli_progress_step()} show that message immediately, we need
to initialize \code{msg} first.

\if{html}{\out{<div class="sourceCode r">}}\preformatted{f <- function() \{
  msg <- ""
  cli_progress_step("Downloading data\{msg\}", spinner = TRUE)
  for (i in 1:100) \{
    Sys.sleep(2/100)
    msg <- glue::glue(", got file \{i\}/100")
    cli_progress_update()
  \}
  cli_progress_step("Importing data")
  Sys.sleep(1)
  cli_progress_step("Cleaning data")
  Sys.sleep(2)
  cli_progress_step("Fitting model", spinner = TRUE)
  for (i in 1:100) \{ Sys.sleep(3/100); cli_progress_update() \}
\}
f()
}\if{html}{\out{</div>}}

\if{html}{\figure{progress-step-dynamic.svg}}
}

\subsection{Termination messages}{

You can specify a different message for successful and/or
unsuccessful termination:

\if{html}{\out{<div class="sourceCode r">}}\preformatted{f <- function() \{
  size <- 0L
  cli_progress_step(
    "Downloading data.",
    msg_done = "Downloaded \{prettyunits::pretty_bytes(size)\}.",
    spinner = TRUE
  )
  for (i in 1:100) \{
    Sys.sleep(3/100)
    size <- size + 8192
    cli_progress_update()
  \}
\}
f()
}\if{html}{\out{</div>}}

\if{html}{\figure{progress-step-msg.svg}}
}
}
\seealso{
This function supports \link[=inline-markup]{inline markup}.

Other progress bar functions: 
\code{\link{cli_progress_along}()},
\code{\link{cli_progress_bar}()},
\code{\link{cli_progress_builtin_handlers}()},
\code{\link{cli_progress_message}()},
\code{\link{cli_progress_num}()},
\code{\link{cli_progress_output}()},
\code{\link{cli_progress_styles}()},
\code{\link{progress-variables}}

Other functions supporting inline markup: 
\code{\link{cli_abort}()},
\code{\link{cli_alert}()},
\code{\link{cli_blockquote}()},
\code{\link{cli_bullets}()},
\code{\link{cli_bullets_raw}()},
\code{\link{cli_dl}()},
\code{\link{cli_h1}()},
\code{\link{cli_li}()},
\code{\link{cli_ol}()},
\code{\link{cli_process_start}()},
\code{\link{cli_progress_along}()},
\code{\link{cli_progress_bar}()},
\code{\link{cli_progress_message}()},
\code{\link{cli_progress_output}()},
\code{\link{cli_rule}},
\code{\link{cli_status}()},
\code{\link{cli_status_update}()},
\code{\link{cli_text}()},
\code{\link{cli_ul}()},
\code{\link{format_error}()},
\code{\link{format_inline}()}
}
\concept{functions supporting inline markup}
\concept{progress bar functions}
