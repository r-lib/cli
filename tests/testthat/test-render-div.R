test_that_cli("render_div", config = c("plain", "ansi"), {
  txt <- "Labore aliquip deserunt mollit sint enim commodo cupidatat
          officia nulla id. Minim in adipisicing esse elit aute cillum
          anim quis officia."
  expect_snapshot({
    render_div(
      cpt_div(cpt_text(txt)),
      width = 40
    )

    render_div(
      cpt_div(cpt_text(txt), attr = list(style = list("margin-top" = 1))),
      width = 40
    )

    render_div(
      cpt_div(cpt_text(txt), attr = list(style = list("margin-bottom" = 1))),
      width = 40
    )

    render_div(
      cpt_div(cpt_text(txt), attr = list(style = list("margin-left" = 2))),
      width = 40
    )

    render_div(
      cpt_div(cpt_text(txt), attr = list(style = list("margin-right" = 2))),
      width = 40
    )

    render_div(
      cpt_div(
        cpt_text(txt),
        attr = list(style = list(
          "padding-top" = 1,
          "background-color" = "grey"
        ))
      ),
      width = 40
    )

    render_div(
      cpt_div(
        cpt_text(txt),
        attr = list(style = list(
          "padding-bottom" = 1,
          "background-color" = "grey"
        ))
      ),
      width = 40
    )

    render_div(
      cpt_div(
        cpt_text(txt),
        attr = list(style = list(
          "padding-left" = 1,
          "background-color" = "grey"
        ))
      ),
      width = 40
    )

    render_div(
      cpt_div(
        cpt_text(txt),
        attr = list(style = list(
          "padding-right" = 1,
          "background-color" = "grey"
        ))
      ),
      width = 40
    )

    render_div(
      cpt_div(cpt_text(txt), attr = list(style = list("color" = "grey"))),
      width = 40
    )
  })
})

test_that_cli("render_div children", config = c("plain", "ansi"), {
  txt <- "Labore aliquip deserunt mollit sint enim commodo cupidatat
          officia nulla id. Minim in adipisicing esse elit aute cillum
          anim quis officia."

  withr::local_options(cli.width = 40L)
  expect_snapshot({
    writeLines(render_div(
      cpt_div(
        cpt_div(cpt_text(txt), attr = list(style = list(color = "magenta"))),
        attr = list(style = list(
          "background-color" = "grey",
          "padding-left" = 2L,
          "padding-right" = 2L,
          "padding-top" = 2L,
          "padding-bottom" = 2L,
          "margin-left" = 1L,
          "margin-right" = 1L,
          "margin-top" = 1L,
          "margin-bottom" = 1L
        ))
      )
    ))
  })
})

test_that_cli("render_div can turn off bg color", config = "ansi", {
  txt <- "Labore aliquip deserunt mollit sint enim commodo cupidatat
          officia nulla id. Minim in adipisicing esse elit aute cillum
          anim quis officia."

  withr::local_options(cli.width = 40L)
  expect_snapshot({
    writeLines(render_div(
      cpt_div(
        cpt_div(
          cpt_text(txt),
          attr = list(style = list(color = "magenta", "background-color" = NULL))
        ),
        attr = list(style = list(
          "background-color" = "grey",
          "padding-left" = 2L,
          "padding-right" = 2L,
          "padding-top" = 2L,
          "padding-bottom" = 2L,
          "margin-left" = 1L,
          "margin-right" = 1L,
          "margin-top" = 1L,
          "margin-bottom" = 1L
        ))
      )
    ))
  })
})

test_that("render_div with fmt callback", {
  headline <- "This is a headline"
  fmt <- function(x, style, width, ...) {
    cli::rule(x, width = width)
  }
  div <- cpt_div(cpt_text(headline), attr = list(style = list(fmt = fmt)))
  expect_snapshot(render(div, width = 40))
})
