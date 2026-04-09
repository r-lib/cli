# Parse a CSS3-like selector

This is the rather small subset of CSS3 that is supported:

## Usage

``` r
parse_selector(x)
```

## Arguments

- x:

  CSS3-like selector string.

## Details

Selectors:

- Type selectors, e.g. `input` selects all `<input>` elements.

- Class selectors, e.g. `.index` selects any element that has a class of
  "index".

- ID selector. `#toc` will match the element that has the ID `"toc"`.

Combinators:

- Descendant combinator, i.e. the space, that combinator selects nodes
  that are descendants of the first element. E.g. `div span` will match
  all `<span>` elements that are inside a `<div>` element.
