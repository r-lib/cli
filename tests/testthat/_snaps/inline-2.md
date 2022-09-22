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
      x <- cli_vec(1:100, list(`vec-trunc` = 5))
      cli_text("Some numbers: {x}.")
    Message
      Some numbers: 1, 2, 3, ..., 99, and 100.
    Code
      cli_text("Some numbers: {.val {x}}.")
    Message
      Some numbers: 1, 2, 3, ..., 99, and 100.

# custom truncation [ansi]

    Code
      x <- cli_vec(1:100, list(`vec-trunc` = 5))
      cli_text("Some numbers: {x}.")
    Message
      Some numbers: 1, 2, 3, ..., 99, and 100.
    Code
      cli_text("Some numbers: {.val {x}}.")
    Message
      Some numbers: [34m1[39m, [34m2[39m, [34m3[39m, ..., [34m99[39m, and [34m100[39m.

# custom truncation [unicode]

    Code
      x <- cli_vec(1:100, list(`vec-trunc` = 5))
      cli_text("Some numbers: {x}.")
    Message
      Some numbers: 1, 2, 3, …, 99, and 100.
    Code
      cli_text("Some numbers: {.val {x}}.")
    Message
      Some numbers: 1, 2, 3, …, 99, and 100.

# custom truncation [fancy]

    Code
      x <- cli_vec(1:100, list(`vec-trunc` = 5))
      cli_text("Some numbers: {x}.")
    Message
      Some numbers: 1, 2, 3, …, 99, and 100.
    Code
      cli_text("Some numbers: {.val {x}}.")
    Message
      Some numbers: [34m1[39m, [34m2[39m, [34m3[39m, …, [34m99[39m, and [34m100[39m.

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

# do not inherit 'transform' issue #422

    Code
      d <- deparse(c("cli", "glue"))
      cli::cli_alert_info("To install, run {.code install.packages({d})}")
    Message
      i To install, run `install.packages(c("cli", "glue"))`

---

    Code
      cli::cli_text("{.code foo({1+1})}")
    Message
      `foo(2)`

# no inherit color, issue #474 [plain]

    Code
      cli::cli_text("pre {.val x {'foo'} y} post")
    Message
      pre "x foo y" post

# no inherit color, issue #474 [ansi]

    Code
      cli::cli_text("pre {.val x {'foo'} y} post")
    Message
      pre [34m"x foo y"[39m post

# \f at the end, issue #491 [plain]

    Code
      cli_fmt(cli::cli_text("{.val a}{.val b}"))
    Output
      [1] "\"a\"\"b\""
    Code
      cli_fmt(cli::cli_text("\f{.val a}{.val b}"))
    Output
      [1] ""           "\"a\"\"b\""
    Code
      cli_fmt(cli::cli_text("\f\f{.val a}{.val b}"))
    Output
      [1] ""           ""           "\"a\"\"b\""
    Code
      cli_fmt(cli::cli_text("{.val a}\f{.val b}"))
    Output
      [1] "\"a\"" "\"b\""
    Code
      cli_fmt(cli::cli_text("{.val a}\f\f{.val b}"))
    Output
      [1] "\"a\"" ""      "\"b\""
    Code
      cli_fmt(cli::cli_text("{.val a}{.val b}\f"))
    Output
      [1] "\"a\"\"b\"" ""          
    Code
      cli_fmt(cli::cli_text("{.val a}{.val b}\f\f"))
    Output
      [1] "\"a\"\"b\"" ""           ""          
    Code
      cli_fmt(cli::cli_text("\f\f\f{.val a}\f\f\f{.val b}\f\f\f"))
    Output
       [1] ""      ""      ""      "\"a\"" ""      ""      "\"b\"" ""      ""     
      [10] ""     

# \f at the end, issue #491 [ansi]

    Code
      cli_fmt(cli::cli_text("{.val a}{.val b}"))
    Output
      [1] "\033[34m\"a\"\"b\"\033[39m"
    Code
      cli_fmt(cli::cli_text("\f{.val a}{.val b}"))
    Output
      [1] ""                           "\033[34m\"a\"\"b\"\033[39m"
    Code
      cli_fmt(cli::cli_text("\f\f{.val a}{.val b}"))
    Output
      [1] ""                           ""                          
      [3] "\033[34m\"a\"\"b\"\033[39m"
    Code
      cli_fmt(cli::cli_text("{.val a}\f{.val b}"))
    Output
      [1] "\033[34m\"a\"\033[39m" "\033[34m\"b\"\033[39m"
    Code
      cli_fmt(cli::cli_text("{.val a}\f\f{.val b}"))
    Output
      [1] "\033[34m\"a\"\033[39m" ""                      "\033[34m\"b\"\033[39m"
    Code
      cli_fmt(cli::cli_text("{.val a}{.val b}\f"))
    Output
      [1] "\033[34m\"a\"\"b\"\033[39m" ""                          
    Code
      cli_fmt(cli::cli_text("{.val a}{.val b}\f\f"))
    Output
      [1] "\033[34m\"a\"\"b\"\033[39m" ""                          
      [3] ""                          
    Code
      cli_fmt(cli::cli_text("\f\f\f{.val a}\f\f\f{.val b}\f\f\f"))
    Output
       [1] ""                      ""                      ""                     
       [4] "\033[34m\"a\"\033[39m" ""                      ""                     
       [7] "\033[34m\"b\"\033[39m" ""                      ""                     
      [10] ""                     

# truncate vectors at 20

    Code
      cli::cli_text("Some letters: {letters}")
    Message
      Some letters: a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, ..., y, and
      z

# brace expresssion edge cases [ansi]

    Code
      cli_text("{.code {foo} and {bar}}")
    Message
      `foo and bar`
    Code
      cli_text("{.emph {foo} and {bar}}")
    Message
      [3mfoo and bar[23m
    Code
      cli_text("{.q {foo} and {bar}}")
    Message
      "foo and bar"

# various errors

    ! Invalid cli literal: `{.foobar}` starts with a dot.
    i Interpreted literals must not start with a dot in cli >= 3.4.0.
    i `{}` expressions starting with a dot are now only used for cli styles.
    i To avoid this error, put a space character after the starting `{` or use parentheses: `{(.foobar)}`.

---

    ! Invalid cli literal: `{.someve...}` starts with a dot.
    i Interpreted literals must not start with a dot in cli >= 3.4.0.
    i `{}` expressions starting with a dot are now only used for cli styles.
    i To avoid this error, put a space character after the starting `{` or use parentheses: `{(.someve...)}`.

---

    Code
      cli_text("xx {__cannot-parse-this__} yy")
    Condition
      Error:
      ! Error while parsing cli `{}` expression: `__cannot-parse-th...`.
      Caused by error:
      ! <text>:1:2: unexpected input
      1: __
           ^

---

    Code
      cli_text("xx {1 + 'a'} yy")
    Condition
      Error:
      ! Error while evaluating cli `{}` expression: `1 + 'a'`.
      Caused by error:
      ! non-numeric argument to binary operator

