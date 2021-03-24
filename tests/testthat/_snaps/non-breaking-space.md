# does not break

    Code
      local({
        withr::local_options(cli.width = 40)
        str30 <- "123456789 123456789 1234567890"
        cli_text(c(str30, "this is not breaking"))
      })
    Message <cliMessage>
      123456789 123456789
      1234567890this is not breaking

