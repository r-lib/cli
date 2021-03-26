# quoting phrases that don't start or end with letter or number [plain]

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

# quoting phrases that don't start or end with letter or number [ansi]

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
      The name is [34m[34mgood-name[34m[39m.
      The name is '[34m[34mweird-name[34m[39m[47m [49m'.
      The name is '[34m[34mweird-name[34m[39m[47m [49m'.
      The name is '[34m[34mweird-name[34m[39m[47m [49m'.

# quoting weird names, still [plain]

    Code
      local({
        cat_line(nb(quote_weird_name("good")))
        cat_line(nb(quote_weird_name("  bad")))
        cat_line(nb(quote_weird_name("bad  ")))
        cat_line(nb(quote_weird_name("  bad  ")))
      })
    Output
      good
      '  bad'
      'bad  '
      '  bad  '

# quoting weird names, still [ansi]

    Code
      local({
        cat_line(nb(quote_weird_name("good")))
        cat_line(nb(quote_weird_name("  bad")))
        cat_line(nb(quote_weird_name("bad  ")))
        cat_line(nb(quote_weird_name("  bad  ")))
      })
    Output
      good
      '[47m  [49mbad'
      'bad[47m  [49m'
      '[47m  [49mbad[47m  [49m'

