# ul [plain]

    Code
      local({
        lid <- cli_ul()
        cli_li("foo")
        cli_li(c("bar", "foobar"))
        cli_end(lid)
      })
    Message
      * foo
      * bar
      * foobar

# ul [unicode]

    Code
      local({
        lid <- cli_ul()
        cli_li("foo")
        cli_li(c("bar", "foobar"))
        cli_end(lid)
      })
    Message
      • foo
      • bar
      • foobar

# ol [plain]

    Code
      local({
        cli_div(theme = list(ol = list()))
        lid <- cli_ol()
        cli_li("foo")
        cli_li(c("bar", "foobar"))
        cli_end(lid)
      })
    Message
      1. foo
      2. bar
      3. foobar

# ol [unicode]

    Code
      local({
        cli_div(theme = list(ol = list()))
        lid <- cli_ol()
        cli_li("foo")
        cli_li(c("bar", "foobar"))
        cli_end(lid)
      })
    Message
      1. foo
      2. bar
      3. foobar

# ul ul [plain]

    Code
      local({
        cli_div(theme = list(`ul ul` = list(`list-style-type` = "-", `margin-left` = 2)))
        lid <- cli_ul()
        cli_li("1")
        lid2 <- cli_ul()
        cli_li("1 1")
        cli_li(c("1 2", "1 3"))
        cli_end(lid2)
        cli_li("2")
        cli_end(lid)
      })
    Message
      * 1
          - 1 1
          - 1 2
          - 1 3
      * 2

# ul ul [unicode]

    Code
      local({
        cli_div(theme = list(`ul ul` = list(`list-style-type` = "-", `margin-left` = 2)))
        lid <- cli_ul()
        cli_li("1")
        lid2 <- cli_ul()
        cli_li("1 1")
        cli_li(c("1 2", "1 3"))
        cli_end(lid2)
        cli_li("2")
        cli_end(lid)
      })
    Message
      • 1
          - 1 1
          - 1 2
          - 1 3
      • 2

# ul ol [plain]

    Code
      local({
        cli_div(theme = list(li = list(`margin-left` = 2)))
        lid <- cli_ul()
        cli_li("1")
        lid2 <- cli_ol()
        cli_li("1 1")
        cli_li(c("1 2", "1 3"))
        cli_end(lid2)
        cli_li("2")
        cli_end(lid)
      })
    Message
        * 1
          1. 1 1
          2. 1 2
          3. 1 3
        * 2

# ul ol [unicode]

    Code
      local({
        cli_div(theme = list(li = list(`margin-left` = 2)))
        lid <- cli_ul()
        cli_li("1")
        lid2 <- cli_ol()
        cli_li("1 1")
        cli_li(c("1 2", "1 3"))
        cli_end(lid2)
        cli_li("2")
        cli_end(lid)
      })
    Message
        • 1
          1. 1 1
          2. 1 2
          3. 1 3
        • 2

# ol ol [plain]

    Code
      local({
        cli_div(theme = list(li = list(`margin-left` = 2), `li li` = list(
          `margin-left` = 2)))
        lid <- cli_ol()
        cli_li("1")
        lid2 <- cli_ol()
        cli_li("1 1")
        cli_li(c("1 2", "1 3"))
        cli_end(lid2)
        cli_li("2")
        cli_end(lid)
      })
    Message
        1. 1
          1. 1 1
          2. 1 2
          3. 1 3
        2. 2

# ol ol [unicode]

    Code
      local({
        cli_div(theme = list(li = list(`margin-left` = 2), `li li` = list(
          `margin-left` = 2)))
        lid <- cli_ol()
        cli_li("1")
        lid2 <- cli_ol()
        cli_li("1 1")
        cli_li(c("1 2", "1 3"))
        cli_end(lid2)
        cli_li("2")
        cli_end(lid)
      })
    Message
        1. 1
          1. 1 1
          2. 1 2
          3. 1 3
        2. 2

# ol ul [plain]

    Code
      local({
        cli_div(theme = list(ul = list(`margin-left` = 2)))
        lid <- cli_ol()
        cli_li("1")
        lid2 <- cli_ul()
        cli_li("1 1")
        cli_li(c("1 2", "1 3"))
        cli_end(lid2)
        cli_li("2")
        cli_end(lid)
      })
    Message
      1. 1
          * 1 1
          * 1 2
          * 1 3
      2. 2

# ol ul [unicode]

    Code
      local({
        cli_div(theme = list(ul = list(`margin-left` = 2)))
        lid <- cli_ol()
        cli_li("1")
        lid2 <- cli_ul()
        cli_li("1 1")
        cli_li(c("1 2", "1 3"))
        cli_end(lid2)
        cli_li("2")
        cli_end(lid)
      })
    Message
      1. 1
          • 1 1
          • 1 2
          • 1 3
      2. 2

# starting with an item [plain]

    Code
      local({
        cli_li("foo")
        cli_li(c("bar", "foobar"))
        cli_end()
        cli_end()
      })
    Message
      * foo
      * bar
      * foobar

# starting with an item [unicode]

    Code
      local({
        cli_li("foo")
        cli_li(c("bar", "foobar"))
        cli_end()
        cli_end()
      })
    Message
      • foo
      • bar
      • foobar

# ol, with first item [plain]

    Code
      local({
        cli_div(theme = list(ol = list()))
        lid <- cli_ol("foo", .close = FALSE)
        cli_li(c("bar", "foobar"))
        cli_end(lid)
      })
    Message
      1. foo
      2. bar
      3. foobar

# ol, with first item [unicode]

    Code
      local({
        cli_div(theme = list(ol = list()))
        lid <- cli_ol("foo", .close = FALSE)
        cli_li(c("bar", "foobar"))
        cli_end(lid)
      })
    Message
      1. foo
      2. bar
      3. foobar

# ul, with first item [plain]

    Code
      local({
        lid <- cli_ul("foo", .close = FALSE)
        cli_li(c("bar", "foobar"))
        cli_end(lid)
      })
    Message
      * foo
      * bar
      * foobar

# ul, with first item [unicode]

    Code
      local({
        lid <- cli_ul("foo", .close = FALSE)
        cli_li(c("bar", "foobar"))
        cli_end(lid)
      })
    Message
      • foo
      • bar
      • foobar

# dl [plain]

    Code
      local({
        cli_div(theme = list(ul = list()))
        lid <- cli_dl()
        cli_li(c(this = "foo"))
        cli_li(c(that = "bar", other = "foobar"))
        cli_end(lid)
      })
    Message
      this: foo
      that: bar
      other: foobar

# dl [unicode]

    Code
      local({
        cli_div(theme = list(ul = list()))
        lid <- cli_dl()
        cli_li(c(this = "foo"))
        cli_li(c(that = "bar", other = "foobar"))
        cli_end(lid)
      })
    Message
      this: foo
      that: bar
      other: foobar

# dl dl [plain]

    Code
      local({
        cli_div(theme = list(li = list(`margin-left` = 2)))
        lid <- cli_dl()
        cli_li(c(a = "1"))
        lid2 <- cli_dl()
        cli_li(c(`a-a` = "1 1"))
        cli_li(c(`a-b` = "1 2", `a-c` = "1 3"))
        cli_end(lid2)
        cli_li(c(b = "2"))
        cli_end(lid)
      })
    Message
        a: 1
          a-a: 1 1
          a-b: 1 2
          a-c: 1 3
        b: 2

# dl dl [unicode]

    Code
      local({
        cli_div(theme = list(li = list(`margin-left` = 2)))
        lid <- cli_dl()
        cli_li(c(a = "1"))
        lid2 <- cli_dl()
        cli_li(c(`a-a` = "1 1"))
        cli_li(c(`a-b` = "1 2", `a-c` = "1 3"))
        cli_end(lid2)
        cli_li(c(b = "2"))
        cli_end(lid)
      })
    Message
        a: 1
          a-a: 1 1
          a-b: 1 2
          a-c: 1 3
        b: 2

# dl ol [plain]

    Code
      local({
        cli_div(theme = list(li = list(`margin-left` = 2)))
        lid <- cli_dl()
        cli_li(c(a = "1"))
        lid2 <- cli_ol()
        cli_li(c("1 1"))
        cli_li(c("1 2", "1 3"))
        cli_end(lid2)
        cli_li(c(b = "2"))
        cli_end(lid)
      })
    Message
        a: 1
          1. 1 1
          2. 1 2
          3. 1 3
        b: 2

# dl ol [unicode]

    Code
      local({
        cli_div(theme = list(li = list(`margin-left` = 2)))
        lid <- cli_dl()
        cli_li(c(a = "1"))
        lid2 <- cli_ol()
        cli_li(c("1 1"))
        cli_li(c("1 2", "1 3"))
        cli_end(lid2)
        cli_li(c(b = "2"))
        cli_end(lid)
      })
    Message
        a: 1
          1. 1 1
          2. 1 2
          3. 1 3
        b: 2

# dl ul [plain]

    Code
      local({
        cli_div(theme = list(li = list(`margin-left` = 2)))
        lid <- cli_dl()
        cli_li(c(a = "1"))
        lid2 <- cli_ul()
        cli_li(c("1 1"))
        cli_li(c("1 2", "1 3"))
        cli_end(lid2)
        cli_li(c(b = "2"))
        cli_end(lid)
      })
    Message
        a: 1
          * 1 1
          * 1 2
          * 1 3
        b: 2

# dl ul [unicode]

    Code
      local({
        cli_div(theme = list(li = list(`margin-left` = 2)))
        lid <- cli_dl()
        cli_li(c(a = "1"))
        lid2 <- cli_ul()
        cli_li(c("1 1"))
        cli_li(c("1 2", "1 3"))
        cli_end(lid2)
        cli_li(c(b = "2"))
        cli_end(lid)
      })
    Message
        a: 1
          • 1 1
          • 1 2
          • 1 3
        b: 2

# ol dl [plain]

    Code
      local({
        cli_div(theme = list(li = list(`margin-left` = 2)))
        lid <- cli_ol()
        cli_li("1")
        lid2 <- cli_dl()
        cli_li(c(`a-a` = "1 1"))
        cli_li(c(`a-b` = "1 2", `a-c` = "1 3"))
        cli_end(lid2)
        cli_li("2")
        cli_end(lid)
      })
    Message
        1. 1
          a-a: 1 1
          a-b: 1 2
          a-c: 1 3
        2. 2

# ol dl [unicode]

    Code
      local({
        cli_div(theme = list(li = list(`margin-left` = 2)))
        lid <- cli_ol()
        cli_li("1")
        lid2 <- cli_dl()
        cli_li(c(`a-a` = "1 1"))
        cli_li(c(`a-b` = "1 2", `a-c` = "1 3"))
        cli_end(lid2)
        cli_li("2")
        cli_end(lid)
      })
    Message
        1. 1
          a-a: 1 1
          a-b: 1 2
          a-c: 1 3
        2. 2

# ul dl [plain]

    Code
      local({
        cli_div(theme = list(li = list(`margin-left` = 2)))
        lid <- cli_ul()
        cli_li("1")
        lid2 <- cli_dl()
        cli_li(c(`a-a` = "1 1"))
        cli_li(c(`a-b` = "1 2", `a-c` = "1 3"))
        cli_end(lid2)
        cli_li("2")
        cli_end(lid)
      })
    Message
        * 1
          a-a: 1 1
          a-b: 1 2
          a-c: 1 3
        * 2

# ul dl [unicode]

    Code
      local({
        cli_div(theme = list(li = list(`margin-left` = 2)))
        lid <- cli_ul()
        cli_li("1")
        lid2 <- cli_dl()
        cli_li(c(`a-a` = "1 1"))
        cli_li(c(`a-b` = "1 2", `a-c` = "1 3"))
        cli_end(lid2)
        cli_li("2")
        cli_end(lid)
      })
    Message
        • 1
          a-a: 1 1
          a-b: 1 2
          a-c: 1 3
        • 2

# dl, with first item [plain]

    Code
      local({
        cli_div(theme = list(ul = list()))
        lid <- cli_dl(c(this = "foo"), .close = FALSE)
        cli_li(c(that = "bar", other = "foobar"))
        cli_end(lid)
      })
    Message
      this: foo
      that: bar
      other: foobar

# dl, with first item [unicode]

    Code
      local({
        cli_div(theme = list(ul = list()))
        lid <- cli_dl(c(this = "foo"), .close = FALSE)
        cli_li(c(that = "bar", other = "foobar"))
        cli_end(lid)
      })
    Message
      this: foo
      that: bar
      other: foobar

# styling pieces of a dl [ansi]

    Code
      local({
        cli_div(theme = list(.dt = list(postfix = " -> "), .dd = list(color = "blue")))
        cli_dl(c(foo = "bar", bar = "baz"))
      })
    Message
      foo -> [34mbar[39m
      bar -> [34mbaz[39m

# cli_dl edge cases

    Code
      cli_dl(c(abc = "foo", empty = "", def = "bar"))
    Message
      abc: foo
      empty:
      def: bar

# cli_dl label style

    Code
      local({
        cli_dl(c(`{.code code}` = "{.code this is code too}", `{.str strin}` = "{.url https://x.com}"))
      })
    Message
      `code`: `this is code too`
      "strin": <https://x.com>

