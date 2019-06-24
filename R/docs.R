
#' CLI inline markup
#'
#' @section Command substitution:
#'
#' All text emitted by cli supports glue interpolation. Expressions
#' enclosed by braces will be evaluated as R code. See [glue::glue()] for
#' details.
#'
#' In addition to regular glue interpolation, cli can also add classes
#' to parts of the text, and these classes can be used in themes. For
#' example
#'
#' ```
#' cli_text("This is {emph important}.")
#' ```
#'
#' adds a class to the "important" word, class "emph". Note that in this
#' cases the string within the braces is not a valid R expression. If you
#' want to mix classes with interpolation, add another pair of braces:
#'
#' ```
#' adjective <- "great"
#' cli_text("This is {emph {adjective}}.")
#' ```
#'
#' An inline class will always create a `span` element internally. So in
#' themes, you can use the `span.emph` CSS selector to change how inline
#' text is emphasized:
#'
#' ```
#' cli_div(theme = list(span.emph = list(color = "red")))
#' adjective <- "nice and red"
#' cli_text("This is {emph {adjective}}.")
#' ```
#'
#' @section Classes:
#'
#' The default theme defines the following inline classes:
#' * `emph` for emphasized text.
#' * `strong` for strong importance.
#' * `code` for a piece of code.
#' * `pkg` for a package name.
#' * `fun` for a function name.
#' * `arg` for a function argument.
#' * `key` for a keyboard key.
#' * `file` for a file name.
#' * `path` for a path (essentially the same as `file`).
#' * `email` for an email address.
#' * `url` for a URL.
#' * `var` for a variable name.
#' * `envvar` for the name of an environment variable.
#'
#' See examples below.
#'
#' You can simply add new classes by defining them in the theme, and then
#' using them, see the example below.
#'
#' @name inline-markup
#' @examples
#' ## Some inline markup examples
#' cli_ul()
#' cli_it("{emph Emphasized} text")
#' cli_it("{strong Strong} importance")
#' cli_it("A piece of code: {code sum(a) / length(a)}")
#' cli_it("A package name: {pkg cli}")
#' cli_it("A function name: {fun cli_text}")
#' cli_it("A function argument: {arg text}")
#' cli_it("A keyboard key: press {key ENTER}")
#' cli_it("A file name: {file /usr/bin/env}")
#' cli_it("An email address: {email bugs.bunny@acme.com}")
#' cli_it("A URL: {url https://acme.com}")
#' cli_it("A variable name: {var mtcars}")
#' cli_it("An environment variable: {envvar R_LIBS}")
#' cli_end()
#'
#' ## Adding a new class
#' cli_div(theme = list(
#'   span.myclass = list(color = "lightgrey"),
#'   "span.myclass::before" = list(content = "["),
#'   "span.myclass::after" = list(content = "]")))
#' cli_text("This is {myclass in brackets}.")
#' cli_end()
NULL

#' CLI containers
#'
#' Container elements may contain other elements. Currently the following
#' commands create container elements: [cli_div()], [cli_par()], the list
#' elements: [cli_ul()], [cli_ol()], [cli_dl()], and list items are
#' containers as well: [cli_it()].
#'
#' Container elements need to be closed with [cli_end()]. For convenience,
#' they are have an `.auto_close` argument, which allows automatically
#' closing a container element, when the function that created it
#' terminates (either regularly, or with an error).
#'
#' @name containers
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
NULL

#' CLI themes
#'
#' CLI elements can be styled via a CSS-like language of selectors and
#' properties. Note that while most of the CSS3 language is supported,
#' a lot visual properties cannot be implemented on a terminal, so these
#' will be ignored.
#'
#' @section Adding themes:
#' The style of an element is calculated from themes from four sources.
#' These form a stack, and the styles on the top of the stack take
#' precedence, over styles in the bottom.
#'
#' 1. The cli package has a builtin theme. This is always active.
#'    See [builtin_theme()].
#' 2. When an app object is created via [start_app()], the caller can
#'    specify a theme, that is added to theme stack. If no theme is
#'    specified for [start_app()], the content of the `cli.theme` option
#'    is used. Removed when the corresponding app stops.
#' 3. The user may speficy a theme in the `cli.user_theme` option. This
#'    is added to the stack _after_ the app's theme (step 2.), so it can
#'    override its settings. Removed when the app that added it stops.
#' 4. Themes specified explicitly in [cli_div()] elements. These are
#'    removed from the theme stack, when the corresponding [cli_div()]
#'    elements are closed.
#'
#' @section Writing themes:
#' A theme is a named list of lists. The name of each entry is a CSS
#' selector. Most features of CSS selectors are supported here:, for a
#' complete reference, see the selectr package.
#'
#' The content of a theme list entry is another named list, where the
#' names are CSS properties, e.g. `color`, or `font-weight` or
#' `margin-left`, and the list entries themselves define the values of
#' the properties. See [builtin_theme()] and [simple_theme()] for examples.
#'
#' @section CSS pseudo elements:
#' Currently only the `::before` and `::after` pseudo elements are
#' supported.
#'
#' @section Formatter callbacks:
#' For flexibility, themes may also define formatter functions, with
#' property name `fmt`. These will be called once the other styles are
#' applied to an element. They are only called on elements that produce
#' output, i.e. _not_ on container elements.
#'
#' @section Supported properties:
#' Right now only a limited set of properties are supported. These include
#' left, right, top and bottom margins, background and foreground colors,
#' bold and italic fonts, underlined text. The `content` property is
#' supported to insert text via `::before` and `::after` selectors.
#'
#' More properties might be adder later.
#'
#' Please see the example themes and the source code for now for the
#' details.
#'
#' @section Examples:
#' Color of headers, that are only active in paragraphs with an
#' 'output' class:
#' ```
#' list(
#'   "par.output h1" = list("background-color" = "red", color = "#e0e0e0"),
#'   "par.output h2" = list("background-color" = "orange", color = "#e0e0e0"),
#'   "par.output h3" = list("background-color" = "blue", color = "#e0e0e0")
#' )
#' ```
#'
#' Create a custom alert type:
#' ```
#' list(
#'   ".alert-start::before" = list(content = symbol$play),
#'   ".alert-stop::before"  = list(content = symbol$stop)
#' )
#' ```
#' @name themes
NULL
