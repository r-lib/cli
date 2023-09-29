# render_inline_text_piece_plain [plain]

    Code
      render_inline_text_piece_plain("this is a test")
    Output
      <cli_ansi_string>
      [1] this is a test
    Code
      render_inline_text_piece_plain("this is a test", list(color = "red"))
    Output
      <cli_ansi_string>
      [1] this is a test
    Code
      render_inline_text_piece_plain("test", list(`background-color` = "cyan"))
    Output
      <cli_ansi_string>
      [1] test
    Code
      render_inline_text_piece_plain("this is a test", list(`font-style` = "italic"))
    Output
      <cli_ansi_string>
      [1] this is a test
    Code
      render_inline_text_piece_plain("this is a test", list(`font-weight` = "bold"))
    Output
      <cli_ansi_string>
      [1] this is a test
    Code
      render_inline_text_piece_plain("test", list(`text-decoration` = "underline"))
    Output
      <cli_ansi_string>
      [1] test
    Code
      render_inline_text_piece_plain("text", list(color = "green", fmt = function(x)
        paste0("{", x, "}")))
    Output
      <cli_ansi_string>
      [1] {text}

# render_inline_text_piece_plain [ansi]

    Code
      render_inline_text_piece_plain("this is a test")
    Output
      <cli_ansi_string>
      [1] this is a test
    Code
      render_inline_text_piece_plain("this is a test", list(color = "red"))
    Output
      <cli_ansi_string>
      [1] [31mthis is a test[39m
    Code
      render_inline_text_piece_plain("test", list(`background-color` = "cyan"))
    Output
      <cli_ansi_string>
      [1] [46mtest[49m
    Code
      render_inline_text_piece_plain("this is a test", list(`font-style` = "italic"))
    Output
      <cli_ansi_string>
      [1] [3mthis is a test[23m
    Code
      render_inline_text_piece_plain("this is a test", list(`font-weight` = "bold"))
    Output
      <cli_ansi_string>
      [1] [1mthis is a test[22m
    Code
      render_inline_text_piece_plain("test", list(`text-decoration` = "underline"))
    Output
      <cli_ansi_string>
      [1] [4mtest[24m
    Code
      render_inline_text_piece_plain("text", list(color = "green", fmt = function(x)
        paste0("{", x, "}")))
    Output
      <cli_ansi_string>
      [1] {[32mtext[39m}

# render_inline_text_piece_substitution [plain]

    Code
      render_inline_text_piece_substitution(list(value = 1:5))
    Output
      <cli_ansi_string>
      [1] 1, 2, 3, 4, and 5
    Code
      render_inline_text_piece_substitution(list(value = 1:20))
    Output
      <cli_ansi_string>
      [1] 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, and 20
    Code
      render_inline_text_piece_substitution(list(value = 1:21))
    Output
      <cli_ansi_string>
      [1] 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, ..., 20, and 21
    Code
      render_inline_text_piece_substitution(list(value = 1:100))
    Output
      <cli_ansi_string>
      [1] 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, ..., 99, and 100

---

    Code
      render_inline_text_piece_substitution(list(value = 1:5), list(transform = function(
        x) x + x))
    Output
      <cli_ansi_string>
      [1] 2, 4, 6, 8, and 10

---

    Code
      render_inline_text_piece_substitution(list(value = 1:5), list(collapse = "|"))
    Output
      <cli_ansi_string>
      [1] 1|2|3|4|5
    Code
      render_inline_text_piece_substitution(list(value = 1:5), list(collapse = function(
        x) paste(x, collapse = "|")))
    Output
      <cli_ansi_string>
      [1] 1|2|3|4|5

---

    Code
      render_inline_text_piece_substitution(list(value = 1:5), list(before = "<",
        after = ">"))
    Output
      <cli_ansi_string>
      [1] <1>, <2>, <3>, <4>, and <5>

---

    Code
      render_inline_text_piece_substitution(list(value = 1:5), list(collapse = "|",
        before = "<", after = ">"))
    Output
      <cli_ansi_string>
      [1] <1|2|3|4|5>

---

    Code
      render_inline_text_piece_substitution(list(value = 1:5), list(prefix = "[",
        postfix = "]"))
    Output
      <cli_ansi_string>
      [1] [1], [2], [3], [4], and [5]

---

    Code
      render_inline_text_piece_substitution(list(value = 1:5), list(`vec-sep` = " + "))
    Output
      <cli_ansi_string>
      [1] 1 + 2 + 3 + 4, and 5
    Code
      render_inline_text_piece_substitution(list(value = 1:5), list(`vec-sep` = " + ",
        `vec-last` = " + "))
    Output
      <cli_ansi_string>
      [1] 1 + 2 + 3 + 4 + 5
    Code
      render_inline_text_piece_substitution(list(value = 1:2), list(`vec-sep` = " + ",
        `vec-sep2` = " ++ ", `vec-last` = " + "))
    Output
      <cli_ansi_string>
      [1] 1 ++ 2

---

    Code
      render_inline_text_piece_substitution(list(value = 1:10), list(`vec-trunc` = 5))
    Output
      <cli_ansi_string>
      [1] 1, 2, 3, ..., 9, and 10
    Code
      render_inline_text_piece_substitution(list(value = 1:10), list(`vec-trunc` = 5,
        `vec-trunc-style` = "both-ends"))
    Output
      <cli_ansi_string>
      [1] 1, 2, 3, ..., 9, and 10
    Code
      render_inline_text_piece_substitution(list(value = 1:10), list(`vec-trunc` = 5,
        `vec-trunc-style` = "head"))
    Output
      <cli_ansi_string>
      [1] 1, 2, 3, 4, 5, ...

# render_inline_text_piece_substitution pref [plain]

    Code
      render_inline_text_piece_substitution(list(value = 1:10, style = list(
        `vec-trunc` = 100)), list(`vec-trunc` = 5, `vec-trunc-style` = "head"))
    Output
      <cli_ansi_string>
      [1] 1, 2, 3, 4, 5, ...

