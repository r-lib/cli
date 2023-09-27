# format_text_piece_plain [plain]

    Code
      format_text_piece_plain("this is a test")
    Output
      [1] "this is a test"
    Code
      format_text_piece_plain("this is a test", list(color = "red"))
    Output
      <cli_ansi_string>
      [1] this is a test
    Code
      format_text_piece_plain("test", list(`background-color` = "cyan"))
    Output
      <cli_ansi_string>
      [1] test
    Code
      format_text_piece_plain("this is a test", list(`font-style` = "italic"))
    Output
      <cli_ansi_string>
      [1] this is a test
    Code
      format_text_piece_plain("this is a test", list(`font-weight` = "bold"))
    Output
      <cli_ansi_string>
      [1] this is a test
    Code
      format_text_piece_plain("test", list(`text-decoration` = "underline"))
    Output
      <cli_ansi_string>
      [1] test
    Code
      format_text_piece_plain("text", list(color = "green", fmt = function(x) paste0(
        "{", x, "}")))
    Output
      [1] "{text}"

# format_text_piece_plain [ansi]

    Code
      format_text_piece_plain("this is a test")
    Output
      [1] "this is a test"
    Code
      format_text_piece_plain("this is a test", list(color = "red"))
    Output
      <cli_ansi_string>
      [1] [31mthis is a test[39m
    Code
      format_text_piece_plain("test", list(`background-color` = "cyan"))
    Output
      <cli_ansi_string>
      [1] [46mtest[49m
    Code
      format_text_piece_plain("this is a test", list(`font-style` = "italic"))
    Output
      <cli_ansi_string>
      [1] [3mthis is a test[23m
    Code
      format_text_piece_plain("this is a test", list(`font-weight` = "bold"))
    Output
      <cli_ansi_string>
      [1] [1mthis is a test[22m
    Code
      format_text_piece_plain("test", list(`text-decoration` = "underline"))
    Output
      <cli_ansi_string>
      [1] [4mtest[24m
    Code
      format_text_piece_plain("text", list(color = "green", fmt = function(x) paste0(
        "{", x, "}")))
    Output
      [1] "{\033[32mtext\033[39m}"

