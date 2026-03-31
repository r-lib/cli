# Match a selector to a container stack

Match a selector to a container stack

## Usage

``` r
match_selector(sels, cnts)
```

## Arguments

- sels:

  A list of selector nodes.

- cnts:

  A list of container nodes.

  The last selector in the list must match the last container, so we do
  the matching from the back. This is because we use this function to
  calculate the style of newly encountered containers.
