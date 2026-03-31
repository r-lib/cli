# CLI paragraph

The builtin theme leaves an empty line between paragraphs. See also
[containers](https://cli.r-lib.org/dev/reference/containers.md).

## Usage

``` r
cli_par(id = NULL, class = NULL, .auto_close = TRUE, .envir = parent.frame())
```

## Arguments

- id:

  Element id, a string. If `NULL`, then a new id is generated and
  returned.

- class:

  Class name, sting. Can be used in themes.

- .auto_close:

  Whether to close the container, when the calling function finishes (or
  `.envir` is removed, if specified).

- .envir:

  Environment to evaluate the glue expressions in. It is also used to
  auto-close the container if `.auto_close` is `TRUE`.

## Value

The id of the new container element, invisibly.

## Details

    clifun <- function() {
      cli_par()
      cli_text(cli:::lorem_ipsum())
    }
    clifun()
    clifun()

    #> Sunt anim ullamco Lorem qui mollit anim est in deserunt adipisicing.
    #> Enim deserunt laborum ad qui qui. Anim esse non anim magna Lorem
    #> consequat dolore labore cupidatat magna et. Esse nulla eiusmod Lorem
    #> exercitation cupidatat velit enim exercitation excepteur non officia
    #> incididunt. Id laborum dolore commodo Lorem esse ea sint proident.
    #>
    #> Fugiat mollit in Lorem velit qui exercitation ipsum consectetur ad
    #> nisi ut eu do ullamco. Mollit officia reprehenderit culpa Lorem est
    #> reprehenderit excepteur enim magna incididunt ea. Irure nisi ad
    #> exercitation deserunt enim anim excepteur quis minim laboris veniam
    #> nulla pariatur. Enim irure aute nulla irure qui non. Minim velit
    #> proident sunt sint. Proident sit occaecat ex aute.
    #>
