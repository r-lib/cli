# ul

    Code
      local({
        cli_div(theme = list(ul = list(`list-style-type` = "*")))
        lid <- cli_ul()
        cli_li("foo")
        cli_li(c("bar", "foobar"))
        cli_end(lid)
      })
    Message <cliMessage>
      * foo
      * bar
      * foobar

# ol

    Code
      local({
        cli_div(theme = list(ol = list()))
        lid <- cli_ol()
        cli_li("foo")
        cli_li(c("bar", "foobar"))
        cli_end(lid)
      })
    Message <cliMessage>
      1. foo
      2. bar
      3. foobar

# ul ul

    Code
      local({
        cli_div(theme = list(ul = list(`list-style-type` = "*"), `ul ul` = list(
          `list-style-type` = "-", `margin-left` = 2)))
        lid <- cli_ul()
        cli_li("1")
        lid2 <- cli_ul()
        cli_li("1 1")
        cli_li(c("1 2", "1 3"))
        cli_end(lid2)
        cli_li("2")
        cli_end(lid)
      })
    Message <cliMessage>
      * 1
          - 1 1
          - 1 2
          - 1 3
      * 2

# ul ol

    Code
      local({
        cli_div(theme = list(ul = list(`list-style-type` = "*"), li = list(
          `margin-left` = 2)))
        lid <- cli_ul()
        cli_li("1")
        lid2 <- cli_ol()
        cli_li("1 1")
        cli_li(c("1 2", "1 3"))
        cli_end(lid2)
        cli_li("2")
        cli_end(lid)
      })
    Message <cliMessage>
        * 1
          1. 1 1
          2. 1 2
          3. 1 3
        * 2

# ol ol

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
    Message <cliMessage>
        1. 1
            1. 1 1
            2. 1 2
            3. 1 3
        2. 2

# ol ul

    Code
      local({
        cli_div(theme = list(ul = list(`list-style-type` = "*", `margin-left` = 2)))
        lid <- cli_ol()
        cli_li("1")
        lid2 <- cli_ul()
        cli_li("1 1")
        cli_li(c("1 2", "1 3"))
        cli_end(lid2)
        cli_li("2")
        cli_end(lid)
      })
    Message <cliMessage>
      1. 1
          * 1 1
          * 1 2
          * 1 3
      2. 2

# starting with an item

    Code
      local({
        cli_div(theme = list(ul = list(`list-style-type` = "*")))
        cli_li("foo")
        cli_li(c("bar", "foobar"))
      })
    Message <cliMessage>
      * foo
      * bar
      * foobar

# ol, with first item

    Code
      local({
        cli_div(theme = list(ol = list()))
        lid <- cli_ol("foo", .close = FALSE)
        cli_li(c("bar", "foobar"))
        cli_end(lid)
      })
    Message <cliMessage>
      1. foo
      2. bar
      3. foobar

# ul, with first item

    Code
      local({
        cli_div(theme = list(ul = list(`list-style-type` = "*")))
        lid <- cli_ul("foo", .close = FALSE)
        cli_li(c("bar", "foobar"))
        cli_end(lid)
      })
    Message <cliMessage>
      * foo
      * bar
      * foobar

# dl

    Code
      local({
        cli_div(theme = list(ul = list()))
        lid <- cli_dl()
        cli_li(c(this = "foo"))
        cli_li(c(that = "bar", other = "foobar"))
        cli_end(lid)
      })
    Message <cliMessage>
      this: foo
      that: bar
      other: foobar

# dl dl

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
    Message <cliMessage>
        a: 1
          a-a: 1 1
          a-b: 1 2
          a-c: 1 3
        b: 2

# dl ol

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
    Message <cliMessage>
        a: 1
          1. 1 1
          2. 1 2
          3. 1 3
        b: 2

# dl ul

    Code
      local({
        cli_div(theme = list(ul = list(`list-style-type` = "*"), li = list(
          `margin-left` = 2)))
        lid <- cli_dl()
        cli_li(c(a = "1"))
        lid2 <- cli_ul()
        cli_li(c("1 1"))
        cli_li(c("1 2", "1 3"))
        cli_end(lid2)
        cli_li(c(b = "2"))
        cli_end(lid)
      })
    Message <cliMessage>
        a: 1
          * 1 1
          * 1 2
          * 1 3
        b: 2

# ol dl

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
    Message <cliMessage>
        1. 1
          a-a: 1 1
          a-b: 1 2
          a-c: 1 3
        2. 2

# ul dl

    Code
      local({
        cli_div(theme = list(ul = list(`list-style-type` = "*"), li = list(
          `margin-left` = 2)))
        lid <- cli_ul()
        cli_li("1")
        lid2 <- cli_dl()
        cli_li(c(`a-a` = "1 1"))
        cli_li(c(`a-b` = "1 2", `a-c` = "1 3"))
        cli_end(lid2)
        cli_li("2")
        cli_end(lid)
      })
    Message <cliMessage>
        * 1
          a-a: 1 1
          a-b: 1 2
          a-c: 1 3
        * 2

# dl, with first item

    Code
      local({
        cli_div(theme = list(ul = list()))
        lid <- cli_dl(c(this = "foo"), .close = FALSE)
        cli_li(c(that = "bar", other = "foobar"))
        cli_end(lid)
      })
    Message <cliMessage>
      this: foo
      that: bar
      other: foobar

