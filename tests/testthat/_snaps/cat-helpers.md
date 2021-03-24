# cat_line

    Code
      cat_line("This is ", "a ", "line of text.")
    Output
      This is a line of text.

---

    Code
      cat_line("This is ", "a ", "line of text.", col = "red")
    Output
      [31mThis is a line of text.[39m
    Code
      cat_line("This is ", "a ", "line of text.", background_col = "green")
    Output
      [42mThis is a line of text.[49m

# cat_bullet [plain]

    Code
      cat_bullet(letters[1:5])
    Output
      * a
      * b
      * c
      * d
      * e

# cat_bullet [unicode]

    Code
      cat_bullet(letters[1:5])
    Output
      ● a
      ● b
      ● c
      ● d
      ● e

# cat_boxx [plain]

    Code
      cat_boxx("foo")
    Output
      +---------+
      |         |
      |   foo   |
      |         |
      +---------+

# cat_boxx [unicode]

    Code
      cat_boxx("foo")
    Output
      ┌─────────┐
      │         │
      │   foo   │
      │         │
      └─────────┘

# cat_rule [plain]

    Code
      local({
        withr::local_options(cli.width = 20)
        cat_rule("title")
      })
    Output
      -- title -----------

# cat_rule [unicode]

    Code
      local({
        withr::local_options(cli.width = 20)
        cat_rule("title")
      })
    Output
      ── title ───────────

# cat_print [plain]

    Code
      cat_print(boxx(""))
    Output
      +------+
      |      |
      |      |
      |      |
      +------+

---

    Code
      local({
        tmp <- tempfile()
        on.exit(unlink(tmp), add = TRUE)
        expect_silent(cat_print(boxx(""), file = tmp))
        cat(readLines(tmp, warn = FALSE), sep = "\n")
      })
    Output
      +------+
      |      |
      |      |
      |      |
      +------+

# cat_print [unicode]

    Code
      cat_print(boxx(""))
    Output
      ┌──────┐
      │      │
      │      │
      │      │
      └──────┘

---

    Code
      local({
        tmp <- tempfile()
        on.exit(unlink(tmp), add = TRUE)
        expect_silent(cat_print(boxx(""), file = tmp))
        cat(readLines(tmp, warn = FALSE), sep = "\n")
      })
    Output
      ┌──────┐
      │      │
      │      │
      │      │
      └──────┘

