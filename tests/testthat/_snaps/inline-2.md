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
    Message
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
    Message
      The name is [34mgood-name[39m.
      The name is '[34mweird-name[39m[44m [49m'.
      The name is '[34mweird-name[39m[44m [49m'.
      The name is '[34mweird-name[39m[44m [49m'.

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
    Message
      Some numbers: 1, 2, 3, 4, 5, ....
    Code
      cli_text("Some numbers: {.val {x}}.")
    Message
      Some numbers: 1, 2, 3, 4, 5, ....

# custom truncation [ansi]

    Code
      x <- cli_vec(1:100, list(vec_trunc = 5))
      cli_text("Some numbers: {x}.")
    Message
      Some numbers: 1, 2, 3, 4, 5, ....
    Code
      cli_text("Some numbers: {.val {x}}.")
    Message
      Some numbers: [34m1[39m, [34m2[39m, [34m3[39m, [34m4[39m, [34m5[39m, ....

# custom truncation [unicode]

    Code
      x <- cli_vec(1:100, list(vec_trunc = 5))
      cli_text("Some numbers: {x}.")
    Message
      Some numbers: 1, 2, 3, 4, 5, ….
    Code
      cli_text("Some numbers: {.val {x}}.")
    Message
      Some numbers: 1, 2, 3, 4, 5, ….

# custom truncation [fancy]

    Code
      x <- cli_vec(1:100, list(vec_trunc = 5))
      cli_text("Some numbers: {x}.")
    Message
      Some numbers: 1, 2, 3, 4, 5, ….
    Code
      cli_text("Some numbers: {.val {x}}.")
    Message
      Some numbers: [34m1[39m, [34m2[39m, [34m3[39m, [34m4[39m, [34m5[39m, ….

# collapsing class names [plain]

    Code
      local({
        cc <- c("one", "two")
        cli_text("this is a class: {.cls myclass}")
        cli_text("multiple classes: {.cls {cc}}")
      })
    Message
      this is a class: <myclass>
      multiple classes: <one/two>

# collapsing class names [ansi]

    Code
      local({
        cc <- c("one", "two")
        cli_text("this is a class: {.cls myclass}")
        cli_text("multiple classes: {.cls {cc}}")
      })
    Message
      this is a class: [34m<myclass>[39m
      multiple classes: [34m<one/two>[39m

# transform [plain]

    Code
      local({
        cli_text("This is a {.field field} (before)")
        foo <- (function(x) toupper(x))
        cli_div(theme = list(span.field = list(transform = foo)))
        cli_text("This is a {.field field} (during)")
        cli_end()
        cli_text("This is a {.field field} (after)")
      })
    Message
      This is a field (before)
      This is a FIELD (during)
      This is a field (after)

# transform [ansi]

    Code
      local({
        cli_text("This is a {.field field} (before)")
        foo <- (function(x) toupper(x))
        cli_div(theme = list(span.field = list(transform = foo)))
        cli_text("This is a {.field field} (during)")
        cli_end()
        cli_text("This is a {.field field} (after)")
      })
    Message
      This is a [32mfield[39m (before)
      This is a [32mFIELD[39m (during)
      This is a [32mfield[39m (after)

# cli_format

    Code
      cli_format(1:4 / 7, list(digits = 2))
    Output
      [1] 0.14 0.29 0.43 0.57

# cli_format() is used for .val

    Code
      local({
        cli_div(theme = list(.val = list(digits = 2)))
        cli_text("Some random numbers: {.val {runif(4)}}.")
      })
    Message
      Some random numbers: 0.91, 0.94, 0.29, and 0.83.

# .q always double quotes

    Code
      cli_text("just a {.q string}, nothing more")
    Message
      just a "string", nothing more

# .or

    Code
      cli_text("{.or {letters[1:5]}}")
    Message
      a, b, c, d, or e

---

    Code
      cli_text("{.or {letters[1:2]}}")
    Message
      a or b

# line breaks

    Code
      ansi_strwrap(txt2, width = 60)
    Output
      <cli_ansi_string>
      [1] Cupidatat deserunt culpa enim deserunt minim aliqua tempor
      [2] fugiat cupidatat laboris officia esse ex aliqua. Ullamco  
      [3] mollit adipisicing anim.                                  
      [4] Cupidatat deserunt culpa enim deserunt minim aliqua tempor
      [5] fugiat cupidatat laboris officia esse ex aliqua. Ullamco  
      [6] mollit adipisicing anim.                                  

# double ticks [ansi]

    Code
      format_inline("{.code {x}}")
    Output
      [1] "\033[31m`a`\033[39m, \033[31m`` `x` ``\033[39m, and \033[31m`b`\033[39m"

---

    Code
      format_inline("{.fun {x}}")
    Output
      [1] "\033[31m`a()`\033[39m, \033[31m`` `x` ()``\033[39m, and \033[31m`b()`\033[39m"

