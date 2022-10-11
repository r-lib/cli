# ansi_palette_show

    Code
      ansi_palette_show(colors = truecolor)
    Output
                                                           bright variants
      blck red  grn  yllw blue mgnt cyan whte  blck red  grn  yllw blue mgnt cyan whte
      
      [30m####[39m [31m####[39m [32m####[39m [33m####[39m [34m####[39m [35m####[39m [36m####[39m [37m####[39m  [90m####[39m [91m####[39m [92m####[39m [93m####[39m [94m####[39m [95m####[39m [96m####[39m [97m####[39m
      [30m####[39m [31m####[39m [32m####[39m [33m####[39m [34m####[39m [35m####[39m [36m####[39m [37m####[39m  [90m####[39m [91m####[39m [92m####[39m [93m####[39m [94m####[39m [95m####[39m [96m####[39m [97m####[39m
      [30m####[39m [31m####[39m [32m####[39m [33m####[39m [34m####[39m [35m####[39m [36m####[39m [37m####[39m  [90m####[39m [91m####[39m [92m####[39m [93m####[39m [94m####[39m [95m####[39m [96m####[39m [97m####[39m
      [30m####[39m [31m####[39m [32m####[39m [33m####[39m [34m####[39m [35m####[39m [36m####[39m [37m####[39m  [90m####[39m [91m####[39m [92m####[39m [93m####[39m [94m####[39m [95m####[39m [96m####[39m [97m####[39m

---

    Code
      ansi_palette_show(colors = truecolor)
    Output
                                                           bright variants
      blck red  grn  yllw blue mgnt cyan whte  blck red  grn  yllw blue mgnt cyan whte
      
      [38;2;0;0;0m####[39m [38;2;255;92;87m####[39m [38;2;90;247;142m####[39m [38;2;243;249;157m####[39m [38;2;87;199;255m####[39m [38;2;255;106;193m####[39m [38;2;154;237;254m####[39m [38;2;241;241;240m####[39m  [38;2;104;104;104m####[39m [38;2;255;92;87m####[39m [38;2;90;247;142m####[39m [38;2;243;249;157m####[39m [38;2;87;199;255m####[39m [38;2;255;106;193m####[39m [38;2;154;237;254m####[39m [38;2;241;241;240m####[39m
      [38;2;0;0;0m####[39m [38;2;255;92;87m####[39m [38;2;90;247;142m####[39m [38;2;243;249;157m####[39m [38;2;87;199;255m####[39m [38;2;255;106;193m####[39m [38;2;154;237;254m####[39m [38;2;241;241;240m####[39m  [38;2;104;104;104m####[39m [38;2;255;92;87m####[39m [38;2;90;247;142m####[39m [38;2;243;249;157m####[39m [38;2;87;199;255m####[39m [38;2;255;106;193m####[39m [38;2;154;237;254m####[39m [38;2;241;241;240m####[39m
      [38;2;0;0;0m####[39m [38;2;255;92;87m####[39m [38;2;90;247;142m####[39m [38;2;243;249;157m####[39m [38;2;87;199;255m####[39m [38;2;255;106;193m####[39m [38;2;154;237;254m####[39m [38;2;241;241;240m####[39m  [38;2;104;104;104m####[39m [38;2;255;92;87m####[39m [38;2;90;247;142m####[39m [38;2;243;249;157m####[39m [38;2;87;199;255m####[39m [38;2;255;106;193m####[39m [38;2;154;237;254m####[39m [38;2;241;241;240m####[39m
      [38;2;0;0;0m####[39m [38;2;255;92;87m####[39m [38;2;90;247;142m####[39m [38;2;243;249;157m####[39m [38;2;87;199;255m####[39m [38;2;255;106;193m####[39m [38;2;154;237;254m####[39m [38;2;241;241;240m####[39m  [38;2;104;104;104m####[39m [38;2;255;92;87m####[39m [38;2;90;247;142m####[39m [38;2;243;249;157m####[39m [38;2;87;199;255m####[39m [38;2;255;106;193m####[39m [38;2;154;237;254m####[39m [38;2;241;241;240m####[39m

# error

    Code
      withr::with_options(list(cli.palette = "foobar12"), ansi_palette_show(colors = 256))
    Condition
      Error:
      ! [1m[22mCannot find cli ANSI palette [34m"foobar12"[39m
      [36mi[39m Know palettes are [34m"dichro"[39m, [34m"vga"[39m, [34m"winxp"[39m, [34m"vscode"[39m, [34m"win10"[39m, [34m"macos"[39m, [34m"putty"[39m, [34m"mirc"[39m, [34m"xterm"[39m, [34m"ubuntu"[39m, [34m"eclipse"[39m, [34m"iterm"[39m, [34m"iterm-pastel"[39m, [34m"iterm-smoooooth"[39m, [34m"iterm-snazzy"[39m, [34m"iterm-solarized"[39m, and [34m"iterm-tango"[39m.
      [36mi[39m Maybe the `cli.palette` option is incorrect?

# custom palettes

    Code
      col_black("black")
    Output
      <cli_ansi_string>
      [1] [38;5;232mblack[39m
    Code
      col_red("red")
    Output
      <cli_ansi_string>
      [1] [38;5;210mred[39m
    Code
      col_green("green")
    Output
      <cli_ansi_string>
      [1] [38;5;121mgreen[39m
    Code
      col_yellow("yellow")
    Output
      <cli_ansi_string>
      [1] [38;5;229myellow[39m
    Code
      col_blue("blue")
    Output
      <cli_ansi_string>
      [1] [38;5;117mblue[39m
    Code
      col_magenta("magenta")
    Output
      <cli_ansi_string>
      [1] [38;5;212mmagenta[39m
    Code
      col_cyan("cyan")
    Output
      <cli_ansi_string>
      [1] [38;5;159mcyan[39m
    Code
      col_white("white")
    Output
      <cli_ansi_string>
      [1] [38;5;254mwhite[39m
    Code
      col_br_black("br_black")
    Output
      <cli_ansi_string>
      [1] [38;5;241mbr_black[39m
    Code
      col_br_red("br_red")
    Output
      <cli_ansi_string>
      [1] [38;5;210mbr_red[39m
    Code
      col_br_green("br_green")
    Output
      <cli_ansi_string>
      [1] [38;5;121mbr_green[39m
    Code
      col_br_yellow("br_yellow")
    Output
      <cli_ansi_string>
      [1] [38;5;229mbr_yellow[39m
    Code
      col_br_blue("br_blue")
    Output
      <cli_ansi_string>
      [1] [38;5;117mbr_blue[39m
    Code
      col_br_magenta("br_magenta")
    Output
      <cli_ansi_string>
      [1] [38;5;212mbr_magenta[39m
    Code
      col_br_cyan("br_cyan")
    Output
      <cli_ansi_string>
      [1] [38;5;159mbr_cyan[39m
    Code
      col_br_white("br_white")
    Output
      <cli_ansi_string>
      [1] [38;5;254mbr_white[39m

