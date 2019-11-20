
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
#' cli_text("This is {.emph important}.")
#' ```
#'
#' adds a class to the "important" word, class "emph". Note that in this
#' case the string within the braces is usually not a valid R expression.
#' If you want to mix classes with interpolation, add another pair of
#' braces:
#'
#' ```
#' adjective <- "great"
#' cli_text("This is {.emph {adjective}}.")
#' ```
#'
#' An inline class will always create a `span` element internally. So in
#' themes, you can use the `span.emph` CSS selector to change how inline
#' text is emphasized:
#'
#' ```
#' cli_div(theme = list(span.emph = list(color = "red")))
#' adjective <- "nice and red"
#' cli_text("This is {.emph {adjective}}.")
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
#' @section Collapsing inline vectors:
#'
#' When cli performs inline text formatting, it automatically collapses
#' glue substitutions, after formatting. This is handy to create lists of
#' files, packages, etc. See examples below.
#'
#' @section Escaping `{` and `}`:
#'
#' It might happen that you want to pass a string to `cli_*` functions,
#' and you do not_ want command substitution in that string, because it
#' might contain `}` and `{` characters. The simplest solution for this is
#' referring to the string from a template:
#'
#' ```
#' msg <- "Error in if (ncol(dat$y)) {: argument is of length zero"
#' cli_alert_warning("{msg}")
#' ```
#'
#' If you want to explicitly escape `{` and `}` characters, just double
#' them:
#'
#' ```
#' cli_alert_warning("A warning with {{ braces }}")
#' ```
#'
#' See also examples below.
#'
#' @name inline-markup
#' @examples
#' ## Some inline markup examples
#' cli_ul()
#' cli_li("{.emph Emphasized} text")
#' cli_li("{.strong Strong} importance")
#' cli_li("A piece of code: {.code sum(a) / length(a)}")
#' cli_li("A package name: {.pkg cli}")
#' cli_li("A function name: {.fn cli_text}")
#' cli_li("A keyboard key: press {.kbd ENTER}")
#' cli_li("A file name: {.file /usr/bin/env}")
#' cli_li("An email address: {.email bugs.bunny@acme.com}")
#' cli_li("A URL: {.url https://acme.com}")
#' cli_li("An environment variable: {.envvar R_LIBS}")
#' cli_end()
#'
#' ## Adding a new class
#' cli_div(theme = list(
#'   span.myclass = list(color = "lightgrey"),
#'   "span.myclass" = list(before = "["),
#'   "span.myclass" = list(after = "]")))
#' cli_text("This is {.myclass in brackets}.")
#' cli_end()
#'
#' ## Collapsing
#' pkgs <- c("pkg1", "pkg2", "pkg3")
#' cli_text("Packages: {pkgs}.")
#' cli_text("Packages: {.pkg {pkgs}}")
#'
#' ## Escaping
#' msg <- "Error in if (ncol(dat$y)) {: argument is of length zero"
#' cli_alert_warning("{msg}")
#'
#' cli_alert_warning("A warning with {{ braces }}")
NULL

#' CLI containers
#'
#' Container elements may contain other elements. Currently the following
#' commands create container elements: [cli_div()], [cli_par()], the list
#' elements: [cli_ul()], [cli_ol()], [cli_dl()], and list items are
#' containers as well: [cli_li()].
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
#' properties. Only a small subset of CSS3 is supported, and
#' a lot visual properties cannot be implemented on a terminal, so these
#' will be ignored as well.
#'
#' @section Adding themes:
#' The style of an element is calculated from themes from four sources.
#' These form a stack, and the themes on the top of the stack take
#' precedence, over themes in the bottom.
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
#' selector. Only a subset of CSS is supported:
#' * Type selectors, e.g. `input` selects all `<input>` elements.
#' * Class selectors, e.g. `.index` selects any element that has a class
#'   of "index".
#' * ID selector. `#toc` will match the element that has the ID "toc".
#' * The descendant combinator, i.e. the space, that selects nodes
#'   that are descendants of the first element. E.g. `div span` will match
#'   all `<span>` elements that are inside a `<div>` element.
#'
#' The content of a theme list entry is another named list, where the
#' names are CSS properties, e.g. `color`, or `font-weight` or
#' `margin-left`, and the list entries themselves define the values of
#' the properties. See [builtin_theme()] and [simple_theme()] for examples.
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
#' bold and italic fonts, underlined text. The `before` and `after`
#' properties are supported to insert text before and after the
#' content of the element.
#'
#' More properties might be adder later.
#'
#' Please see the example themes and the source code for now for the
#' details.
#'
#' @section Examples:
#' Color of headings, that are only active in paragraphs with an
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
#'   ".alert-start" = list(before = symbol$play),
#'   ".alert-stop"  = list(before = symbol$stop)
#' )
#' ```
#' @name themes
NULL
