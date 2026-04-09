# Match a selector node to a container

Match a selector node to a container

## Usage

``` r
match_selector_node(node, cnt)
```

## Arguments

- node:

  Selector node, as parsed by `parse_selector_node()`.

- cnt:

  Container node, has elements `tag`, `id`, `class`.

  The selector node matches the container, if all these hold:

  - The id of the selector is missing or unique.

  - The tag of the selector is missing or unique.

  - The id of the container is missing or unique.

  - The tag of the container is unique.

  - If the selector specifies an id, it matches the id of the container.

  - If the selector specifies a tag, it matches the tag of the
    container.

  - If the selector specifies class names, the container has all these
    classes.
