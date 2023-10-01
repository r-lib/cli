# render_inline_span [plain]

    Code
      render_inline_span(cpt_span(cpt_text(txt)))
    Output
      <cli_ansi_string>
      [1] Consequat quis labore occaecat enim nostrud voluptate culpa eiusmod esse.
    Code
      render_inline_span(cpt_span(cpt_text(txt), attr = list(style = list(before = "<",
        after = ">"))))
    Output
      <cli_ansi_string>
      [1] <Consequat quis labore occaecat enim nostrud voluptate culpa eiusmod esse.>
    Code
      render_inline_span(cpt_span(cpt_text(txt), attr = list(style = list(prefix = "{",
        postfix = "}"))))
    Output
      <cli_ansi_string>
      [1] {Consequat quis labore occaecat enim nostrud voluptate culpa eiusmod esse.}
    Code
      gsub(" ", "+", render_inline_span(cpt_span(cpt_text("before"), cpt_span(
        cpt_text(txt), attr = list(style = list(`padding-left` = 2, `padding-right` = 3))),
      cpt_text("after"))))
    Output
      <cli_ansi_string>
      [1] before++Consequat quis labore occaecat enim nostrud voluptate culpa eiusmod esse.+++after
    Code
      render_inline_span(cpt_span(cpt_text("before"), cpt_span(cpt_text(txt), attr = list(
        style = list(`padding-left` = 2, `padding-right` = 3, `background-color` = "grey"))),
      cpt_text("after")))
    Output
      <cli_ansi_string>
      [1] before  Consequat quis labore occaecat enim nostrud voluptate culpa eiusmod esse.   after
    Code
      render_inline_span(cpt_span(cpt_text(txt), attr = list(style = list(color = "cyan",
        `font-style` = "italic"))))
    Output
      <cli_ansi_string>
      [1] Consequat quis labore occaecat enim nostrud voluptate culpa eiusmod esse.
    Code
      render_inline_span(cpt_span(cpt_text("before"), cpt_span(cpt_text(txt), attr = list(
        style = list(`margin-left` = 2, `margin-right` = 3, `background-color` = "grey"))),
      cpt_text("after")))
    Output
      <cli_ansi_string>
      [1] before  Consequat quis labore occaecat enim nostrud voluptate culpa eiusmod esse.   after

# render_inline_span [ansi]

    Code
      render_inline_span(cpt_span(cpt_text(txt)))
    Output
      <cli_ansi_string>
      [1] Consequat quis labore occaecat enim nostrud voluptate culpa eiusmod esse.
    Code
      render_inline_span(cpt_span(cpt_text(txt), attr = list(style = list(before = "<",
        after = ">"))))
    Output
      <cli_ansi_string>
      [1] <Consequat quis labore occaecat enim nostrud voluptate culpa eiusmod esse.>
    Code
      render_inline_span(cpt_span(cpt_text(txt), attr = list(style = list(prefix = "{",
        postfix = "}"))))
    Output
      <cli_ansi_string>
      [1] {Consequat quis labore occaecat enim nostrud voluptate culpa eiusmod esse.}
    Code
      gsub(" ", "+", render_inline_span(cpt_span(cpt_text("before"), cpt_span(
        cpt_text(txt), attr = list(style = list(`padding-left` = 2, `padding-right` = 3))),
      cpt_text("after"))))
    Output
      <cli_ansi_string>
      [1] before++Consequat quis labore occaecat enim nostrud voluptate culpa eiusmod esse.+++after
    Code
      render_inline_span(cpt_span(cpt_text("before"), cpt_span(cpt_text(txt), attr = list(
        style = list(`padding-left` = 2, `padding-right` = 3, `background-color` = "grey"))),
      cpt_text("after")))
    Output
      <cli_ansi_string>
      [1] before[47m  Consequat quis labore occaecat enim nostrud voluptate culpa eiusmod esse.   [49mafter
    Code
      render_inline_span(cpt_span(cpt_text(txt), attr = list(style = list(color = "cyan",
        `font-style` = "italic"))))
    Output
      <cli_ansi_string>
      [1] [3m[36mConsequat quis labore occaecat enim nostrud voluptate culpa eiusmod esse.[39m[23m
    Code
      render_inline_span(cpt_span(cpt_text("before"), cpt_span(cpt_text(txt), attr = list(
        style = list(`margin-left` = 2, `margin-right` = 3, `background-color` = "grey"))),
      cpt_text("after")))
    Output
      <cli_ansi_string>
      [1] before  [47mConsequat quis labore occaecat enim nostrud voluptate culpa eiusmod esse.[49m   after

