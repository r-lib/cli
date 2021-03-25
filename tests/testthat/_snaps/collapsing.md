# collapsing without formatting, n>3

    Code
      pkgs <- paste0("pkg", 1:5)
      cli_text("Packages: {pkgs}.")
    Message <cliMessage>
      Packages: pkg1, pkg2, pkg3, pkg4, and pkg5.

# collapsing without formatting, n<3

    Code
      pkgs <- paste0("pkg", 1:2)
      cli_text("Packages: {pkgs}.")
    Message <cliMessage>
      Packages: pkg1 and pkg2.

# collapsing with formatting

    Code
      local({
        cli_div(theme = list(.pkg = list(fmt = function(x) paste0(x, " (P)"))))
        pkgs <- paste0("pkg", 1:5)
        cli_text("Packages: {.pkg {pkgs}}.")
      })
    Message <cliMessage>
      Packages: pkg1 (P), pkg2 (P), pkg3 (P), pkg4 (P), and pkg5 (P).

# collapsing with formatting, custom seps

    Code
      local({
        cli_div(theme = list(div = list(vec_sep = " ... ")))
        pkgs <- paste0("pkg", 1:5)
        cli_text("Packages: {.pkg {pkgs}}.")
      })
    Message <cliMessage>
      Packages: pkg1 ... pkg2 ... pkg3 ... pkg4, and pkg5.

# collapsing a cli_vec

    Code
      pkgs <- cli_vec(paste0("pkg", 1:5), style = list(vec_sep = " & ", vec_last = " & "))
      cli_text("Packages: {pkgs}.")
    Message <cliMessage>
      Packages: pkg1 & pkg2 & pkg3 & pkg4 & pkg5.

# collapsing a cli_vec with styling [plain]

    Code
      local({
        cli_div(theme = list(body = list(vec_sep = " ... ")))
        pkgs <- cli_vec(paste0("pkg", 1:5), style = list(vec_sep = " & ", vec_last = " & ",
          color = "blue"))
        cli_text("Packages: {pkgs}.")
      })
    Message <cliMessage>
      Packages: pkg1 & pkg2 & pkg3 & pkg4 & pkg5.

# collapsing a cli_vec with styling [ansi]

    Code
      local({
        cli_div(theme = list(body = list(vec_sep = " ... ")))
        pkgs <- cli_vec(paste0("pkg", 1:5), style = list(vec_sep = " & ", vec_last = " & ",
          color = "blue"))
        cli_text("Packages: {pkgs}.")
      })
    Message <cliMessage>
      Packages: [34m[34mpkg1[34m[39m & [34m[34mpkg2[34m[39m & [34m[34mpkg3[34m[39m & [34m[34mpkg4[34m[39m & [34m[34mpkg5[34m[39m.

