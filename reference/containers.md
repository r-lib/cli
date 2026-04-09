# About cli containers

Container elements may contain other elements. Currently the following
commands create container elements:
[`cli_div()`](https://cli.r-lib.org/reference/cli_div.md),
[`cli_par()`](https://cli.r-lib.org/reference/cli_par.md), the list
elements: [`cli_ul()`](https://cli.r-lib.org/reference/cli_ul.md),
[`cli_ol()`](https://cli.r-lib.org/reference/cli_ol.md),
[`cli_dl()`](https://cli.r-lib.org/reference/cli_dl.md), and list items
are containers as well:
[`cli_li()`](https://cli.r-lib.org/reference/cli_li.md).

## Details

### Themes

A container can add a new theme, which is removed when the container
exits.

    d <- cli_div(theme = list(h1 = list(color = "blue",
                                        "font-weight" = "bold")))
    cli_h1("Custom title")
    cli_end(d)

    #>
    #> Custom title

### Auto-closing

Container elements are closed with
[`cli_end()`](https://cli.r-lib.org/reference/cli_end.md). For
convenience, by default they are closed automatically when the function
that created them terminated (either regularly or with an error). The
default behavior can be changed with the `.auto_close` argument.

    div <- function() {
      cli_div(class = "tmp", theme = list(.tmp = list(color = "yellow")))
      cli_text("This is yellow")
    }
    div()
    cli_text("This is not yellow any more")

    #> This is yellow
    #> This is not yellow any more

### Debugging

You can use the internal `cli:::cli_debug_doc()` function to see the
currently open containers.

    fun <- function() {
      cli_div(id = "mydiv")
      cli_par(class = "myclass")
      cli:::cli_debug_doc()
    }
    fun()

    #>
    #> <cli document>
    #> <body id="body">
    #> <div id="mydiv"> +theme
    #> <par id="cli-40403-226" class="myclass">
