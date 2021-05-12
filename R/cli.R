
#' Compose multiple cli functions
#'
#' `cli()` will record all `cli_*` calls in `expr`, and emit them together
#' in a single message. This is useful if you want to built a larger
#' piece of output from multiple `cli_*` calls.
#'
#' Use this function to build a more complex piece of CLI that would not
#' make sense to show in pieces.
#'
#' @param expr Expression that contains `cli_*` calls. Their output is
#' collected and sent as a single message.
#' @return Nothing.
#'
#' @export
#' @examples
#' cli({
#'   cli_h1("Title")
#'   cli_h2("Subtitle")
#'   cli_ul(c("this", "that", "end"))
#' })

cli <- function(expr) {
  cond <- cli__message_create("meta", cli__rec(expr))
  cli__message_emit(cond)
  invisible()
}

cli__rec <- function(expr) {
  id <- new_uuid()
  cli_recorded[[id]] <- list()
  on.exit(rm(list = id, envir = cli_recorded), add = TRUE)
  old <- options(cli.record = id)
  on.exit(options(old), add = TRUE)
  expr
  cli_recorded[[id]]
}

cli__fmt <- function(record, collapse = FALSE, strip_newline = FALSE,
                     app = NULL) {
  app <- app %||% default_app() %||% start_app(.auto_close = FALSE)

  old <- app$output
  on.exit(app$output <- old, add = TRUE)
  on.exit(app$signal <- NULL, add = TRUE)
  out <- rawConnection(raw(1000), open = "w")
  on.exit(close(out), add = TRUE)
  app$output <- out
  app$signal <- FALSE

  for (msg in record) {
    do.call(app[[msg$type]], msg$args)
  }

  txt <- rawToChar(rawConnectionValue(out))
  if (!collapse) {
    txt <- unlist(strsplit(txt, "\n", fixed = TRUE))
  } else if (strip_newline) {
    txt <- substr(txt, 1, nchar(txt) - 1L)
  }
  txt
}

# cli__rec + cli__fmt

fmt <- function(expr, collapse = FALSE, strip_newline = FALSE, app = NULL) {
  rec <- cli__rec(expr)
  cli__fmt(rec, collapse, strip_newline, app)
}

#' CLI text
#'
#' It is wrapped to the screen width automatically. It may contain inline
#' markup. (See [inline-markup].)
#'
#' @param ... The text to show, in character vectors. They will be
#'   concatenated into a single string. Newlines are _not_ preserved.
#' @param .envir Environment to evaluate the glue expressions in.
#'
#' @export
#' @examples
#' cli_text("Hello world!")
#' cli_text(packageDescription("cli")$Description)
#'
#' ## Arguments are concatenated
#' cli_text("this", "that")
#'
#' ## Command substitution
#' greeting <- "Hello"
#' subject <- "world"
#' cli_text("{greeting} {subject}!")
#'
#' ## Inline theming
#' cli_text("The {.fn cli_text} function in the {.pkg cli} package")
#'
#' ## Use within container elements
#' ul <- cli_ul()
#' cli_li()
#' cli_text("{.emph First} item")
#' cli_li()
#' cli_text("{.emph Second} item")
#' cli_end(ul)

cli_text <- function(..., .envir = parent.frame()) {
  cli__message("text", list(text = glue_cmd(..., .envir = .envir)))
}

#' CLI verbatim text
#'
#' It is not wrapped, but printed as is.
#'
#' @param ... The text to show, in character vectors. Each element is
#'   printed on a new line.
#' @param .envir Environment to evaluate the glue expressions in.
#'
#' @export
#' @examples
#' cli_verbatim("This has\nthree", "lines")

cli_verbatim <- function(..., .envir = parent.frame()) {
  cli__message("verbatim", c(list(...), list(.envir = .envir)))
}

#' CLI headings
#'
#' @param text Text of the heading. It can contain inline markup.
#' @param id Id of the heading element, string. It can be used in themes.
#' @param class Class of the heading element, string. It can be used in
#'   themes.
#' @param .envir Environment to evaluate the glue expressions in.
#'
#' @export
#' @examples
#' cli_h1("Main title")
#' cli_h2("Subtitle")
#' cli_text("And some regular text....")

cli_h1 <- function(text, id = NULL, class = NULL, .envir = parent.frame()) {
  cli__message("h1", list(text = glue_cmd(text, .envir = .envir), id = id,
                          class = class))
}

#' @rdname cli_h1
#' @export

cli_h2 <- function(text, id = NULL, class = NULL, .envir = parent.frame()) {
  cli__message("h2", list(text = glue_cmd(text, .envir = .envir), id = id,
                          class = class))
}

#' @rdname cli_h1
#' @export

cli_h3 <- function(text, id = NULL, class = NULL, .envir = parent.frame()) {
  cli__message("h3", list(text = glue_cmd(text, .envir = .envir), id = id,
                          class = class))
}

#' Generic CLI container
#'
#' See [containers]. A `cli_div` container is special, because it may
#' add new themes, that are valid within the container.
#'
#' @param id Element id, a string. If `NULL`, then a new id is generated
#'   and returned.
#' @param class Class name, sting. Can be used in themes.
#' @param theme A custom theme for the container. See [themes].
#' @param .auto_close Whether to close the container, when the calling
#'   function finishes (or `.envir` is removed, if specified).
#' @param .envir Environment to evaluate the glue expressions in. It is
#'   also used to auto-close the container if `.auto_close` is `TRUE`.
#' @return The id of the new container element, invisibly.
#'
#' @export
#' @examples
#' ## div with custom theme
#' d <- cli_div(theme = list(h1 = list(color = "blue",
#'                                     "font-weight" = "bold")))
#' cli_h1("Custom title")
#' cli_end(d)
#'
#' ## Close automatically
#' div <- function() {
#'   cli_div(class = "tmp", theme = list(.tmp = list(color = "yellow")))
#'   cli_text("This is yellow")
#' }
#' div()
#' cli_text("This is not yellow any more")

cli_div <- function(id = NULL, class = NULL, theme = NULL,
                    .auto_close = TRUE, .envir = parent.frame()) {
  cli__message("div", list(id = id, class = class, theme = theme),
               .auto_close = .auto_close, .envir = .envir)
}

#' CLI paragraph
#'
#' See [containers].
#'
#' @param id Element id, a string. If `NULL`, then a new id is generated
#'   and returned.
#' @param class Class name, sting. Can be used in themes.
#' @inheritParams cli_div
#' @return The id of the new container element, invisibly.
#'
#' @export
#' @examples
#' id <- cli_par()
#' cli_text("First paragraph")
#' cli_end(id)
#' id <- cli_par()
#' cli_text("Second paragraph")
#' cli_end(id)

cli_par <- function(id = NULL, class = NULL, .auto_close = TRUE,
                    .envir = parent.frame()) {
  cli__message("par", list(id = id, class = class),
               .auto_close = .auto_close, .envir = .envir)
}

#' Close a CLI container
#'
#' @param id Id of the container to close. If missing, the current
#' container is closed, if any.
#'
#' @export
#' @examples
#' ## If id is omitted
#' cli_par()
#' cli_text("First paragraph")
#' cli_end()
#' cli_par()
#' cli_text("Second paragraph")
#' cli_end()

cli_end <- function(id = NULL) {
  cli__message("end", list(id = id %||% NA_character_))
}

#' Unordered CLI list
#'
#' An unordered list is a container, see [containers].
#'
#' @param items If not `NULL`, then a character vector. Each element of
#'   the vector will be one list item, and the list container will be
#'   closed by default (see the `.close` argument).
#' @param id Id of the list container. Can be used for closing it with
#'   [cli_end()] or in themes. If `NULL`, then an id is generated and
#'   returned invisibly.
#' @param class Class of the list container. Can be used in themes.
#' @param .close Whether to close the list container if the `items` were
#'   specified. If `FALSE` then new items can be added to the list.
#' @inheritParams cli_div
#' @return The id of the new container element, invisibly.
#'
#' @export
#' @examples
#' ## Specifying the items at the beginning
#' cli_ul(c("one", "two", "three"))
#'
#' ## Adding items one by one
#' cli_ul()
#' cli_li("one")
#' cli_li("two")
#' cli_li("three")
#' cli_end()
#'
#' ## Complex item, added gradually.
#' cli_ul()
#' cli_li()
#' cli_verbatim("Beginning of the {.emph first} item")
#' cli_text("Still the first item")
#' cli_end()
#' cli_li("Second item")
#' cli_end()

cli_ul <- function(items = NULL, id = NULL, class = NULL,
                   .close = TRUE, .auto_close = TRUE,
                   .envir = parent.frame()) {
  cli__message(
    "ul",
    list(
      items = lapply(items, glue_cmd, .envir = .envir), id = id,
      class = class, .close = .close),
    .auto_close = .auto_close, .envir = .envir)
}

#' Ordered CLI list
#'
#' An ordered list is a container, see [containers].
#'
#' @inheritParams cli_ul
#' @return The id of the new container element, invisibly.
#'
#' @export
#' @examples
#' ## Specifying the items at the beginning
#' cli_ol(c("one", "two", "three"))
#'
#' ## Adding items one by one
#' cli_ol()
#' cli_li("one")
#' cli_li("two")
#' cli_li("three")
#' cli_end()
#'
#' ## Nested lists
#' cli_div(theme = list(ol = list("margin-left" = 2)))
#' cli_ul()
#' cli_li("one")
#' cli_ol(c("foo", "bar", "foobar"))
#' cli_li("two")
#' cli_end()
#' cli_end()

cli_ol <- function(items = NULL, id = NULL, class = NULL,
                   .close = TRUE, .auto_close = TRUE,
                   .envir = parent.frame()) {
  cli__message(
    "ol",
    list(
      items = lapply(items, glue_cmd, .envir = .envir), id = id,
      class = class, .close = .close),
    .auto_close = .auto_close, .envir = .envir)
}

#' Definition list
#'
#' A definition list is a container, see [containers].
#'
#' @param items Named character vector, or `NULL`. If not `NULL`, they
#'   are used as list items.
#' @inheritParams cli_ul
#' @return The id of the new container element, invisibly.
#'
#' @export
#' @examples
#' ## Specifying the items at the beginning
#' cli_dl(c(foo = "one", bar = "two", baz = "three"))
#'
#' ## Adding items one by one
#' cli_dl()
#' cli_li(c(foo = "one"))
#' cli_li(c(bar = "two"))
#' cli_li(c(baz = "three"))
#' cli_end()

cli_dl <- function(items = NULL, id = NULL, class = NULL,
                   .close = TRUE, .auto_close = TRUE,
                   .envir = parent.frame()) {
  cli__message(
    "dl",
    list(
      items = lapply(items, glue_cmd, .envir = .envir), id = id,
      class = class, .close = .close),
    .auto_close = .auto_close, .envir = .envir)
}

#' CLI list item(s)
#'
#' A list item is a container, see [containers].
#'
#' @param items Character vector of items, or `NULL`.
#' @param id Id of the new container. Can be used for closing it with
#'   [cli_end()] or in themes. If `NULL`, then an id is generated and
#'   returned invisibly.
#' @param class Class of the item container. Can be used in themes.
#' @inheritParams cli_div
#' @return The id of the new container element, invisibly.
#'
#' @export
#' @examples
#' ## Adding items one by one
#' cli_ul()
#' cli_li("one")
#' cli_li("two")
#' cli_li("three")
#' cli_end()
#'
#' ## Complex item, added gradually.
#' cli_ul()
#' cli_li()
#' cli_verbatim("Beginning of the {.emph first} item")
#' cli_text("Still the first item")
#' cli_end()
#' cli_li("Second item")
#' cli_end()

cli_li <- function(items = NULL, id = NULL, class = NULL,
                   .auto_close = TRUE, .envir = parent.frame()) {
  cli__message(
    "li",
    list(
      items = lapply(items, glue_cmd, .envir = .envir), id = id,
      class = class),
    .auto_close = .auto_close, .envir = .envir)
}

#' CLI alerts
#'
#' Alerts are typically short status messages.
#'
#' @param text Text of the alert.
#' @param id Id of the alert element. Can be used in themes.
#' @param class Class of the alert element. Can be used in themes.
#' @param wrap Whether to auto-wrap the text of the alert.
#' @param .envir Environment to evaluate the glue expressions in.
#'
#' @export
#' @examples
#'
#' cli_alert("Cannot lock package library.")
#' cli_alert_success("Package {.pkg cli} installed successfully.")
#' cli_alert_danger("Could not download {.pkg cli}.")
#' cli_alert_warning("Internet seems to be unreacheable.")
#' cli_alert_info("Downloaded 1.45MiB of data")

cli_alert <- function(text, id = NULL, class = NULL, wrap = FALSE,
                      .envir = parent.frame()) {
  cli__message(
    "alert",
    list(
      text = glue_cmd(text, .envir = .envir),
      id = id,
      class = class,
      wrap = wrap
    )
  )
}

#' @rdname cli_alert
#' @export

cli_alert_success <- function(text, id = NULL, class = NULL, wrap = FALSE,
                              .envir = parent.frame()) {
  cli__message(
    "alert_success",
    list(
      text = glue_cmd(text, .envir = .envir),
      id = id,
      class = class,
      wrap = wrap
    )
  )
}

#' @rdname cli_alert
#' @export

cli_alert_danger <- function(text, id = NULL, class = NULL, wrap = FALSE,
                              .envir = parent.frame()) {
  cli__message(
    "alert_danger",
    list(
      text = glue_cmd(text, .envir = .envir),
      id = id,
      class = class,
      wrap = wrap
    )
  )
}

#' @rdname cli_alert
#' @export

cli_alert_warning <- function(text, id = NULL, class = NULL, wrap = FALSE,
                               .envir = parent.frame()) {
  cli__message(
    "alert_warning",
    list(
      text = glue_cmd(text, .envir = .envir),
      id = id,
      class = class,
      wrap = wrap
    )
  )
}

#' @rdname cli_alert
#' @export

cli_alert_info <- function(text, id = NULL, class = NULL, wrap = FALSE,
                            .envir = parent.frame()) {
  cli__message(
    "alert_info",
    list(
      text = glue_cmd(text, .envir = .envir),
      id = id,
      class = class,
      wrap = wrap
    )
  )
}

#' CLI horizontal rule
#'
#' It can be used to separate parts of the output. The line style of the
#' rule can be changed via the the `line-type` property. Possible values
#' are:
#'
#' * `"single"`: (same as `1`), a single line,
#' * `"double"`: (same as `2`), a double line,
#' * `"bar1"`, `"bar2"`, `"bar3"`, etc., `"bar8"` uses varying height bars.
#'
#' Colors and background colors can similarly changed via a theme, see
#' examples below.
#'
#' @param .envir Environment to evaluate the glue expressions in.
#' @inheritParams rule
#' @inheritParams cli_div
#'
#' @export
#' @examples
#' cli_rule()
#' cli_text(packageDescription("cli")$Description)
#' cli_rule()
#'
#' # Theming
#' d <- cli_div(theme = list(rule = list(
#'   color = "blue",
#'   "background-color" = "darkgrey",
#'   "line-type" = "double")))
#' cli_rule("Left", right = "Right")
#' cli_end(d)
#'
#' # Interpolation
#' cli_rule(left = "One plus one is {1+1}")
#' cli_rule(left = "Package {.pkg mypackage}")

cli_rule <- function(left = "", center = "", right = "", id = NULL,
                     .envir = parent.frame()) {
  cli__message("rule", list(left = glue_cmd(left, .envir = .envir),
                            center = glue_cmd(center, .envir = .envir),
                            right = glue_cmd(right, .envir = .envir),
                            id = id))
}

#' CLI block quote
#'
#' A section that is quoted from another source. It is typically indented.
#'
#' @export
#' @param quote Text of the quotation.
#' @param citation Source of the quotation, typically a link or the name
#'   of a person.
#' @inheritParams cli_div
#' @examples
#' cli_blockquote(cli:::lorem_ipsum(), citation = "Nobody, ever")

cli_blockquote <- function(quote, citation = NULL, id = NULL,
                           class = NULL, .envir = parent.frame()) {
  cli__message(
    "blockquote",
    list(
      quote = glue_cmd(quote, .envir = .envir),
      citation = glue_cmd(citation, .envir = .envir),
      id = id,
      class = class
    )
  )
}

#' A block of code
#'
#' A helper function that creates a `div` with class `code` and then calls
#' `cli_verbatim()` to output code lines. The builtin theme formats these
#' containers specially. In particular, it adds syntax highlighting to
#' valid R code.
#'
#' @param lines Chracter vector, each line will be a line of code, and
#'   newline charactes also create new lines. Note that _no_ glue
#'   substitution is performed on the code.
#' @param ... More character vectors, they are appended to `lines`.
#' @param language Programming language. This is also added as a class,
#'   in addition to `code`.
#' @param .auto_close Passed to `cli_div()` when creating the container of
#'   the code. By default the code container is closed after emitting
#'   `lines` and `...` via `cli_verbatim()`. You can keep that container
#'   open with `.auto_close` and/or `.envir`, and then calling
#'   `cli_verbatim()` to add (more) code. Note that the code will be
#'   formatted and syntax highlighted separately for each `cli_verbatim()`
#'   call.
#' @param .envir Passed to `cli_div()` when creating the container of the
#'   code.
#' @return The id of the container that contains the code.
#'
#' @export
#' @examples
#' cli_code(format(cli::cli_blockquote))

cli_code <- function(lines = NULL, ..., language = "R",
                     .auto_close = TRUE, .envir = environment()) {
  lines <- c(lines, unlist(list(...)))
  id <- cli_div(
    class = paste("code", language),
    .auto_close = .auto_close,
    .envir = .envir
  )
  cli_verbatim(lines)
  invisible(id)
}

cli_recorded <- new.env(parent = emptyenv())

cli__message <- function(type, args, .auto_close = TRUE, .envir = NULL,
                         .auto_result = NULL,
                         record = getOption("cli.record")) {

  if ("id" %in% names(args) && is.null(args$id)) args$id <- new_uuid()

  if (type == "status") args$globalenv <- identical(.envir, .GlobalEnv)

  if (.auto_close && !is.null(.envir) && !identical(.envir, .GlobalEnv)) {
    if (type == "status") {
      defer(cli_status_clear(id = args$id, result = .auto_result, .envir = .envir),
            envir = .envir, priority = "first")
    } else {
      defer(cli_end(id = args$id), envir = .envir, priority = "first")
    }
  }

  cond <- cli__message_create(type, args)

  if (is.null(record)) {
    cli__message_emit(cond)
    invisible(args$id)

  } else {
    cli_recorded[[record]] <- c(cli_recorded[[record]], list(cond))
    invisible(cond)
  }
}

cli__message_create <- function(type, args) {
  cond <- list(message = paste("cli message", type),
               type = type, args = args, pid = clienv$pid)

  class(cond) <- c(
    getOption("cli.message_class"),
    "cli_message",
    "condition"
  )

  cond
}

cli__message_emit <- function(cond) {
  withRestarts(
  {
    signalCondition(cond)
    cli__default_handler(cond)
  },
  cli_message_handled = function() NULL)
}

cli__default_handler <- function(msg) {
  custom_handler <- getOption("cli.default_handler")

  if (is.function(custom_handler)) {
    custom_handler(msg)
  } else {
    cli_server_default(msg)
  }
}
