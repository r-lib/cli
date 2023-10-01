# render_inline_text_piece_plain [plain]

    Code
      render_inline_text_piece_plain("this is a test")
    Output
      <cli_ansi_string>
      [1] this is a test
    Code
      render_inline_text_piece_plain(styled_text("test", list(`background-color` = "cyan")))
    Output
      <cli_ansi_string>
      [1] test
    Code
      render_inline_text_piece_plain(styled_text("this is a test", list(color = "red")))
    Output
      <cli_ansi_string>
      [1] this is a test
    Code
      render_inline_text_piece_plain(styled_text("this is a test", list(`font-style` = "italic")))
    Output
      <cli_ansi_string>
      [1] this is a test
    Code
      render_inline_text_piece_plain(styled_text("this is a test", list(
        `font-weight` = "bold")))
    Output
      <cli_ansi_string>
      [1] this is a test
    Code
      render_inline_text_piece_plain(styled_text("test", list(`text-decoration` = "underline")))
    Output
      <cli_ansi_string>
      [1] test
    Code
      render_inline_text_piece_plain(styled_text("text", list(color = "green", fmt = function(
        x) paste0("{", x, "}"))))
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
      render_inline_text_piece_plain(styled_text("test", list(`background-color` = "cyan")))
    Output
      <cli_ansi_string>
      [1] [46mtest[49m
    Code
      render_inline_text_piece_plain(styled_text("this is a test", list(color = "red")))
    Output
      <cli_ansi_string>
      [1] [31mthis is a test[39m
    Code
      render_inline_text_piece_plain(styled_text("this is a test", list(`font-style` = "italic")))
    Output
      <cli_ansi_string>
      [1] [3mthis is a test[23m
    Code
      render_inline_text_piece_plain(styled_text("this is a test", list(
        `font-weight` = "bold")))
    Output
      <cli_ansi_string>
      [1] [1mthis is a test[22m
    Code
      render_inline_text_piece_plain(styled_text("test", list(`text-decoration` = "underline")))
    Output
      <cli_ansi_string>
      [1] [4mtest[24m
    Code
      render_inline_text_piece_plain(styled_text("text", list(color = "green", fmt = function(
        x) paste0("{", x, "}"))))
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
      render_inline_text_piece_substitution(styled_sub(1:5, style = list(transform = function(
        x) x + x)))
    Output
      <cli_ansi_string>
      [1] 2, 4, 6, 8, and 10

---

    Code
      render_inline_text_piece_substitution(styled_sub(1:5, style = list(collapse = "|")))
    Output
      <cli_ansi_string>
      [1] 1|2|3|4|5
    Code
      render_inline_text_piece_substitution(styled_sub(value = 1:5, style = list(
        collapse = function(x) paste(x, collapse = "|"))))
    Output
      <cli_ansi_string>
      [1] 1|2|3|4|5

---

    Code
      render_inline_text_piece_substitution(styled_sub(value = 1:5, style = list(
        before = "<", after = ">")))
    Output
      <cli_ansi_string>
      [1] <1>, <2>, <3>, <4>, and <5>

---

    Code
      render_inline_text_piece_substitution(styled_sub(value = 1:5, style = list(
        collapse = "|", before = "<", after = ">")))
    Output
      <cli_ansi_string>
      [1] <1|2|3|4|5>

---

    Code
      render_inline_text_piece_substitution(styled_sub(value = 1:5, style = list(
        prefix = "[", postfix = "]")))
    Output
      <cli_ansi_string>
      [1] [1], [2], [3], [4], and [5]

---

    Code
      render_inline_text_piece_substitution(styled_sub(value = 1:5, style = list(
        `vec-sep` = " + ")))
    Output
      <cli_ansi_string>
      [1] 1 + 2 + 3 + 4, and 5
    Code
      render_inline_text_piece_substitution(styled_sub(value = 1:5, style = list(
        `vec-sep` = " + ", `vec-last` = " + ")))
    Output
      <cli_ansi_string>
      [1] 1 + 2 + 3 + 4 + 5
    Code
      render_inline_text_piece_substitution(styled_sub(value = 1:2, style = list(
        `vec-sep` = " + ", `vec-sep2` = " ++ ", `vec-last` = " + ")))
    Output
      <cli_ansi_string>
      [1] 1 ++ 2

---

    Code
      render_inline_text_piece_substitution(styled_sub(value = 1:10, style = list(
        `vec-trunc` = 5)))
    Output
      <cli_ansi_string>
      [1] 1, 2, 3, ..., 9, and 10
    Code
      render_inline_text_piece_substitution(styled_sub(value = 1:10, style = list(
        `vec-trunc` = 5, `vec-trunc-style` = "both-ends")))
    Output
      <cli_ansi_string>
      [1] 1, 2, 3, ..., 9, and 10
    Code
      render_inline_text_piece_substitution(styled_sub(value = 1:10, style = list(
        `vec-trunc` = 5, `vec-trunc-style` = "head")))
    Output
      <cli_ansi_string>
      [1] 1, 2, 3, 4, 5, ...

---

    Code
      render_inline_text_piece_substitution(styled_sub(value = 1:10 / 3, style = list(
        digits = 2, transform = cli_format)))
    Output
      <cli_ansi_string>
      [1] 0.33, 0.67, 1, 1.33, 1.67, 2, 2.33, 2.67, 3, and 3.33
    Code
      render_inline_text_piece_substitution(styled_sub(value = 1:10 / 3, style = list(
        digits = 3, transform = cli_format)))
    Output
      <cli_ansi_string>
      [1] 0.333, 0.667, 1, 1.333, 1.667, 2, 2.333, 2.667, 3, and 3.333

---

    Code
      render_inline_text_piece_substitution(styled_sub(value = letters[1:10], style = list(
        `string-quote` = "'")))
    Output
      <cli_ansi_string>
      [1] a, b, c, d, e, f, g, h, i, and j
    Code
      render_inline_text_piece_substitution(styled_sub(value = letters[1:10], style = list(
        `string-quote` = "'", transform = cli_format)))
    Output
      <cli_ansi_string>
      [1] 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', and 'j'
    Code
      render_inline_text_piece_substitution(styled_sub(value = letters[1:10], style = list(
        `string-quote` = "\"", transform = cli_format)))
    Output
      <cli_ansi_string>
      [1] "a", "b", "c", "d", "e", "f", "g", "h", "i", and "j"

