# render_inline_text_piece_plain [plain]

    Code
      render_inline_text_piece_plain("this is a test")
    Output
      <cli_ansi_string>
      [1] this is a test
    Code
      render_inline_text_piece_plain(styled_text("test", list(`background-color` = "cyan")))
    Output
      <cli_ansi_string>
      [1] test
    Code
      render_inline_text_piece_plain(styled_text("this is a test", list(color = "red")))
    Output
      <cli_ansi_string>
      [1] this is a test
    Code
      render_inline_text_piece_plain(styled_text("this is a test", list(`font-style` = "italic")))
    Output
      <cli_ansi_string>
      [1] this is a test
    Code
      render_inline_text_piece_plain(styled_text("this is a test", list(
        `font-weight` = "bold")))
    Output
      <cli_ansi_string>
      [1] this is a test
    Code
      render_inline_text_piece_plain(styled_text("test", list(`text-decoration` = "underline")))
    Output
      <cli_ansi_string>
      [1] test
    Code
      render_inline_text_piece_plain(styled_text("text", list(color = "green", fmt = function(
        x) paste0("{", x, "}"))))
    Output
      <cli_ansi_string>
      [1] {text}

# render_inline_text_piece_plain [ansi]

    Code
      render_inline_text_piece_plain("this is a test")
    Output
      <cli_ansi_string>
      [1] this is a test
    Code
      render_inline_text_piece_plain(styled_text("test", list(`background-color` = "cyan")))
    Output
      <cli_ansi_string>
      [1] [46mtest[49m
    Code
      render_inline_text_piece_plain(styled_text("this is a test", list(color = "red")))
    Output
      <cli_ansi_string>
      [1] [31mthis is a test[39m
    Code
      render_inline_text_piece_plain(styled_text("this is a test", list(`font-style` = "italic")))
    Output
      <cli_ansi_string>
      [1] [3mthis is a test[23m
    Code
      render_inline_text_piece_plain(styled_text("this is a test", list(
        `font-weight` = "bold")))
    Output
      <cli_ansi_string>
      [1] [1mthis is a test[22m
    Code
      render_inline_text_piece_plain(styled_text("test", list(`text-decoration` = "underline")))
    Output
      <cli_ansi_string>
      [1] [4mtest[24m
    Code
      render_inline_text_piece_plain(styled_text("text", list(color = "green", fmt = function(
        x) paste0("{", x, "}"))))
    Output
      <cli_ansi_string>
      [1] {[32mtext[39m}

