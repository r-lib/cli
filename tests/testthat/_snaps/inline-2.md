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
      The name is 'good-name'.
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
      The name is '[34m[34mweird-name[34m[39m[44m [49m'.
      The name is '[34m[34mweird-name[34m[39m[44m [49m'.
      The name is '[34m[34mweird-name[34m[39m[44m [49m'.

# quoting weird names, still [plain]

    Code
      local({
        cat_line(nb(quote_weird_name("good")))
        cat_line(nb(quote_weird_name("  bad")))
        cat_line(nb(quote_weird_name("bad  ")))
        cat_line(nb(quote_weird_name("  bad  ")))
      })
    Output
      'good'
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
      '[44m  [49mbad'
      'bad[44m  [49m'
      '[44m  [49mbad[44m  [49m'

# ~/ files are not weird [ansi]

    Code
      local({
        cat_line(nb(quote_weird_name("~/good")))
        cat_line(nb(quote_weird_name("~~bad")))
        cat_line(nb(quote_weird_name("bad~  ")))
        cat_line(nb(quote_weird_name(" ~ bad ~ ")))
      })
    Output
      ~/good
      '~~bad'
      'bad~[44m  [49m'
      '[44m [49m~ bad ~[44m [49m'

# custom truncation [plain]

    Code
      x <- cli_vec(1:100, list(vec_trunc = 5))
      cli_text("Some numbers: {x}.")
    Message <cliMessage>
      Some numbers: 1, 2, 3, 4, 5, ....
    Code
      cli_text("Some numbers: {.val {x}}.")
    Message <cliMessage>
      Some numbers: 1, 2, 3, 4, 5, ....

# custom truncation [ansi]

    Code
      x <- cli_vec(1:100, list(vec_trunc = 5))
      cli_text("Some numbers: {x}.")
    Message <cliMessage>
      Some numbers: 1, 2, 3, 4, 5, ....
    Code
      cli_text("Some numbers: {.val {x}}.")
    Message <cliMessage>
      Some numbers: [34m[34m1[34m[39m, [34m[34m2[34m[39m, [34m[34m3[34m[39m, [34m[34m4[34m[39m, [34m[34m5[34m[39m, ....

# custom truncation [unicode]

    Code
      x <- cli_vec(1:100, list(vec_trunc = 5))
      cli_text("Some numbers: {x}.")
    Message <cliMessage>
      Some numbers: 1, 2, 3, 4, 5, ….
    Code
      cli_text("Some numbers: {.val {x}}.")
    Message <cliMessage>
      Some numbers: 1, 2, 3, 4, 5, ….

# custom truncation [fancy]

    Code
      x <- cli_vec(1:100, list(vec_trunc = 5))
      cli_text("Some numbers: {x}.")
    Message <cliMessage>
      Some numbers: 1, 2, 3, 4, 5, ….
    Code
      cli_text("Some numbers: {.val {x}}.")
    Message <cliMessage>
      Some numbers: [34m[34m1[34m[39m, [34m[34m2[34m[39m, [34m[34m3[34m[39m, [34m[34m4[34m[39m, [34m[34m5[34m[39m, ….

