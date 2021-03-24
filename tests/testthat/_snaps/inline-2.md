# quoting phrases that don't start or end with letter or number

    Code
      local({
        x0 <- "good-name"
        cli_text("The name is {.file {x0}}.")
        x <- "weird-name "
        cli_text("The name is {.file {x}}.")
        cli_text("The name is {.path {x}}.")
        cli_text("The name is {.email {x}}.")
      })
    Message <cliMessage>
      The name is good-name.
      The name is 'weird-name '.
      The name is 'weird-name '.
      The name is 'weird-name '.

