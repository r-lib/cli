# verbatim text is correctly styled

    Code
      local({
        theme <- list(.padded = list(`margin-left` = 4))
        cli_div(class = "padded", theme = theme)
        lines <- c("first", "second", "third")
        cli_verbatim(lines)
        cli_verbatim(paste0(lines, collapse = "\n"))
      })
    Message <cliMessage>
          first
          second
          third
          first
          second
          third

