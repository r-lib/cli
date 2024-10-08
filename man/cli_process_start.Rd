% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/status-bar.R
\name{cli_process_start}
\alias{cli_process_start}
\alias{cli_process_done}
\alias{cli_process_failed}
\title{Indicate the start and termination of some computation in the status bar
(superseded)}
\usage{
cli_process_start(
  msg,
  msg_done = paste(msg, "... done"),
  msg_failed = paste(msg, "... failed"),
  on_exit = c("auto", "failed", "done"),
  msg_class = "alert-info",
  done_class = "alert-success",
  failed_class = "alert-danger",
  .auto_close = TRUE,
  .envir = parent.frame()
)

cli_process_done(
  id = NULL,
  msg_done = NULL,
  .envir = parent.frame(),
  done_class = "alert-success"
)

cli_process_failed(
  id = NULL,
  msg = NULL,
  msg_failed = NULL,
  .envir = parent.frame(),
  failed_class = "alert-danger"
)
}
\arguments{
\item{msg}{The message to show to indicate the start of the process or
computation. It will be collapsed into a single string, and the first
line is kept and cut to \code{\link[=console_width]{console_width()}}.}

\item{msg_done}{The message to use for successful termination.}

\item{msg_failed}{The message to use for unsuccessful termination.}

\item{on_exit}{Whether this process should fail or terminate
successfully when the calling function (or the environment in \code{.envir})
exits.}

\item{msg_class}{The style class to add to the message. Use an empty
string to suppress styling.}

\item{done_class}{The style class to add to the successful termination
message. Use an empty string to suppress styling.a}

\item{failed_class}{The style class to add to the unsuccessful
termination message. Use an empty string to suppress styling.a}

\item{.auto_close}{Whether to clear the status bar when the calling
function finishes (or \code{.envir} is removed from the stack, if
specified).}

\item{.envir}{Environment to evaluate the glue expressions in. It is
also used to auto-clear the status bar if \code{.auto_close} is \code{TRUE}.}

\item{id}{Id of the status bar container to clear. If \code{id} is not the id
of the current status bar (because it was overwritten by another
status bar container), then the status bar is not cleared. If \code{NULL}
(the default) then the status bar is always cleared.}
}
\value{
Id of the status bar container.
}
\description{
\strong{The \verb{cli_process_*()} functions are superseded by
the \code{\link[=cli_progress_message]{cli_progress_message()}} and \code{\link[=cli_progress_step]{cli_progress_step()}} functions,
because they have a better default behavior.}

Typically you call \code{cli_process_start()} to start the process, and then
\code{cli_process_done()} when it is done. If an error happens before
\code{cli_process_done()} is called, then cli automatically shows the message
for unsuccessful termination.
}
\details{
If you handle the errors of the process or computation, then you can do
the opposite: call \code{cli_process_start()} with \code{on_exit = "done"}, and
in the error handler call \code{cli_process_failed()}. cli will automatically
call \code{cli_process_done()} on successful termination, when the calling
function finishes.

See examples below.
}
\examples{

## Failure by default
fun <- function() {
  cli_process_start("Calculating")
  if (interactive()) Sys.sleep(1)
  if (runif(1) < 0.5) stop("Failed")
  cli_process_done()
}
tryCatch(fun(), error = function(err) err)

## Success by default
fun2 <- function() {
  cli_process_start("Calculating", on_exit = "done")
  tryCatch({
    if (interactive()) Sys.sleep(1)
    if (runif(1) < 0.5) stop("Failed")
  }, error = function(err) cli_process_failed())
}
fun2()
}
\seealso{
This function supports \link[=inline-markup]{inline markup}.

The \code{\link[=cli_progress_message]{cli_progress_message()}} and \code{\link[=cli_progress_step]{cli_progress_step()}}
functions, for a superior API.

Other status bar: 
\code{\link{cli_status}()},
\code{\link{cli_status_clear}()},
\code{\link{cli_status_update}()}

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
\code{\link{cli_progress_along}()},
\code{\link{cli_progress_bar}()},
\code{\link{cli_progress_message}()},
\code{\link{cli_progress_output}()},
\code{\link{cli_progress_step}()},
\code{\link{cli_rule}},
\code{\link{cli_status}()},
\code{\link{cli_status_update}()},
\code{\link{cli_text}()},
\code{\link{cli_ul}()},
\code{\link{format_error}()},
\code{\link{format_inline}()}
}
\concept{functions supporting inline markup}
\concept{status bar}
