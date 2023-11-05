test_that_cli("render_inline_span", config = c("plain", "ansi"), {
  txt <- "Consequat quis labore occaecat enim nostrud voluptate culpa eiusmod esse."
  expect_snapshot({
    render_inline_span(cpt_span(cpt_txt(txt)))

    render_inline_span(
      cpt_span(
        cpt_txt(txt),
        attr = list(style = list(before = "<", after = ">"))
      )
    )

    render_inline_span(
      cpt_span(
        cpt_txt(txt),
        attr = list(style = list(prefix = "{", postfix = "}"))
      )
    )

    gsub("\u00a0", "+", render_inline_span(
      cpt_span(
        cpt_txt("before"),
        cpt_span(
          cpt_txt(txt),
          attr = list(style = list("padding-left" = 2, "padding-right" = 3))
        ),
        cpt_txt("after")
      )
    ))

    # padding has background color as well
    render_inline_span(
      cpt_span(
        cpt_txt("before"),
        cpt_span(
          cpt_txt(txt),
          attr = list(style = list(
            "padding-left" = 2,
            "padding-right" = 3,
            "background-color" = "grey"
          ))
        ),
        cpt_txt("after")
      )
    )

    render_inline_span(
      cpt_span(
        cpt_txt(txt),
        attr = list(style = list(color = "cyan", "font-style" = "italic"))
      )
    )

    # margin does not have background color
    render_inline_span(
      cpt_span(
        cpt_txt("before"),
        cpt_span(
          cpt_txt(txt),
          attr = list(style = list(
            "margin-left" = 2,
            "margin-right" = 3,
            "background-color" = "grey"
          ))
        ),
        cpt_txt("after")
      )
    )
  })
})
