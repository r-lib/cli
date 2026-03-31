# About cli themes

CLI elements can be styled via a CSS-like language of selectors and
properties. Only a small subset of CSS3 is supported, and a lot visual
properties cannot be implemented on a terminal, so these will be ignored
as well.

## Adding themes

The style of an element is calculated from themes from four sources.
These form a stack, and the themes on the top of the stack take
precedence, over themes in the bottom.

1.  The cli package has a built-in theme. This is always active. See
    [`builtin_theme()`](https://cli.r-lib.org/dev/reference/builtin_theme.md).

2.  When an app object is created via
    [`start_app()`](https://cli.r-lib.org/dev/reference/start_app.md),
    the caller can specify a theme, that is added to theme stack. If no
    theme is specified for
    [`start_app()`](https://cli.r-lib.org/dev/reference/start_app.md),
    the content of the `cli.theme` option is used. Removed when the
    corresponding app stops.

3.  The user may specify a theme in the `cli.user_theme` option. This is
    added to the stack *after* the app's theme (step 2.), so it can
    override its settings. Removed when the app that added it stops.

4.  Themes specified explicitly in
    [`cli_div()`](https://cli.r-lib.org/dev/reference/cli_div.md)
    elements. These are removed from the theme stack, when the
    corresponding
    [`cli_div()`](https://cli.r-lib.org/dev/reference/cli_div.md)
    elements are closed.

## Writing themes

A theme is a named list of lists. The name of each entry is a CSS
selector. Only a subset of CSS is supported:

- Type selectors, e.g. `input` selects all `<input>` elements.

- Class selectors, e.g. `.index` selects any element that has a class of
  "index".

- ID selector. `#toc` will match the element that has the ID "toc".

- The descendant combinator, i.e. the space, that selects nodes that are
  descendants of the first element. E.g. `div span` will match all
  `<span>` elements that are inside a `<div>` element.

The content of a theme list entry is another named list, where the names
are CSS properties, e.g. `color`, or `font-weight` or `margin-left`, and
the list entries themselves define the values of the properties. See
[`builtin_theme()`](https://cli.r-lib.org/dev/reference/builtin_theme.md)
and
[`simple_theme()`](https://cli.r-lib.org/dev/reference/simple_theme.md)
for examples.

## Formatter callbacks

For flexibility, themes may also define formatter functions, with
property name `fmt`. These will be called once the other styles are
applied to an element. They are only called on elements that produce
output, i.e. *not* on container elements.

## Supported properties

Right now only a limited set of properties are supported. These include
left, right, top and bottom margins, background and foreground colors,
bold and italic fonts, underlined text. The `before` and `after`
properties are supported to insert text before and after the content of
the element.

The current list of properties:

- `after`: A string literal to insert after the element. It can also be
  a function that returns a string literal. Supported by all inline
  elements, list items, alerts and rules.

- `background-color`: An R color name, or HTML hexadecimal color. It can
  be applied to most elements (inline elements, rules, text, etc.), but
  the background of containers is not colored properly currently.

- `before`: A string literal to insert before the element. It can also
  be a function that returns a string literal. Supported by all inline
  elements, list items, alerts and rules.

- `class-map`: Its value can be a named list, and it specifies how R
  (S3) class names are mapped to cli class names. E.g.
  `list(fs_path = "file")` specifies that `fs_path` objects (from the fs
  package) should always print as `.file` objects in cli.

- `color`: Text color, an R color name or a HTML hexadecimal color. It
  can be applied to most elements that are printed.

- `collapse`: Specifies how to collapse a vector, before applying
  styling. If a character string, then that is used as the separator. If
  a function, then it is called, with the vector as the only argument.

- `digits`: Number of digits after the decimal point for numeric inline
  element of class `.val`.

- `fmt`: Generic formatter function that takes an input text and returns
  formatted text. Can be applied to most elements. If colors are in use,
  the input text provided to `fmt` already includes ANSI sequences.

- `font-style`: If `"italic"` then the text is printed as cursive.

- `font-weight`: If `"bold"`, then the text is printed in boldface.

- `line-type`: Line type for
  [`cli_rule()`](https://cli.r-lib.org/dev/reference/cli_rule.md).

- `list-style-type`: String literal or functions that returns a string
  literal, to be used as a list item marker in un-ordered lists.

- `margin-bottom`, `margin-left`, `margin-right`, `margin-top`: Margins.

- `padding-left`, `padding-right`: This is currently used the same way
  as the margins, but this might change later.

- `start`: Integer number, the first element in an ordered list.

- `string-quote`: Quoting character for inline elements of class `.val`.

- `text-decoration`: If `"underline"`, then underlined text is created.

- `text-exdent`: Amount of indentation from the second line of wrapped
  text.

- `transform`: A function to call on glue substitutions, before
  collapsing them. Note that `transform` is applied prior to
  implementing color via ANSI sequences.

- `vec-last`: The last separator when collapsing vectors.

- `vec-sep`: The separator to use when collapsing vectors.

- `vec-sep2`: The separator to use for two elements when collapsing
  vectors. If not set, then `vec-sep` is used for these as well.

- `vec-trunc`: Vectors longer than this will be truncated. Defaults to
  100.

- `vec-trunc-style`: Select between two ways of collapsing vectors:

  - `"both-ends"` is the current default and it shows the beginning and
    the end of the vector.

  - `"head"` only shows the beginning of the vector.

More properties might be added later. If you think that a property is
not applied properly to an element, please open an issue about it in the
cli issue tracker.

## Examples

Color of headings, that are only active in paragraphs with an 'output'
class:

    list(
      "par.output h1" = list("background-color" = "red", color = "#e0e0e0"),
      "par.output h2" = list("background-color" = "orange", color = "#e0e0e0"),
      "par.output h3" = list("background-color" = "blue", color = "#e0e0e0")
    )

Create a custom alert type:

    list(
      ".alert-start" = list(before = symbol$play),
      ".alert-stop"  = list(before = symbol$stop)
    )
