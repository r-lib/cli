# print.cli_ansi_style

    Code
      print(col_red)
    Output
      <cli_ansi_style>
      Example output

# print.cli_ansi_string

    Code
      print(col_red("red"))
    Output
      <cli_ansi_string>
      [1] [31mred[39m

# ansi-scale

    Code
      ansi_scale(c(0, 0, 0))
    Output
      [1] 0 0 0
    Code
      ansi_scale(c(255, 100, 0))
    Output
      [1] 5 2 0
    Code
      ansi_scale(c(255, 100, 0), round = FALSE)
    Output
      [1] 5.000000 1.960784 0.000000

