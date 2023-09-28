
test_that_cli("format_text_piece_plain", configs = c("plain", "ansi"), {
  expect_snapshot({
    format_text_piece_plain("this is a test")
    format_text_piece_plain("this is a test", list(color = "red"))
    format_text_piece_plain("test", list("background-color" = "cyan"))
    format_text_piece_plain("this is a test", list("font-style" = "italic"))
    format_text_piece_plain("this is a test", list("font-weight" = "bold"))
    format_text_piece_plain("test", list("text-decoration" = "underline"))

    format_text_piece_plain(
      "text",
      list(color = "green", fmt = function(x) paste0("{", x, "}"))
    )
  })
})

test_that_cli("format_text_piece_substitution", configs = c("plain"), {
  expect_snapshot({
    format_text_piece_substitution(list(value = 1:5))
    format_text_piece_substitution(list(value = 1:20))
    format_text_piece_substitution(list(value = 1:21))
    format_text_piece_substitution(list(value = 1:100))
  })

  # transform
  expect_snapshot({
    format_text_piece_substitution(
      list(value = 1:5),
      list(transform = function(x) x + x)
    )
  })

  # collapse
  expect_snapshot({
    format_text_piece_substitution(
      list(value = 1:5),
      list(collapse = "|")
    )
    format_text_piece_substitution(
      list(value = 1:5),
      list(collapse = function(x) paste(x, collapse = "|"))
    )
  })

  # before, after
  expect_snapshot({
    format_text_piece_substitution(
      list(value = 1:5),
      list(before = "<", after = ">")
    )
  })

  # before, after + collapse
  expect_snapshot({
    format_text_piece_substitution(
      list(value = 1:5),
      list(collapse = "|", before = "<", after = ">")
    )
  })

  # prefix, postfix
  expect_snapshot({
    format_text_piece_substitution(
      list(value = 1:5),
      list(prefix = "[", postfix = "]")
    )
  })

  # vec-sep, vec-sep2, vec-last
  expect_snapshot({
    format_text_piece_substitution(
      list(value = 1:5),
      list("vec-sep" = " + ")
    )
    format_text_piece_substitution(
      list(value = 1:5),
      list("vec-sep" = " + ", "vec-last" = " + ")
    )
    format_text_piece_substitution(
      list(value = 1:2),
      list("vec-sep" = " + ", "vec-sep2" = " ++ ", "vec-last" = " + ")
    )
  })

  # vec-trunc, vec-trunc-style
  expect_snapshot({
    format_text_piece_substitution(
      list(value = 1:10),
      list("vec-trunc" = 5)
    )
    format_text_piece_substitution(
      list(value = 1:10),
      list("vec-trunc" = 5, "vec-trunc-style" = "both-ends")
    )
    format_text_piece_substitution(
      list(value = 1:10),
      list("vec-trunc" = 5, "vec-trunc-style" = "head")
    )
  })
})

test_that_cli("format_text_piece_substitution pref", configs = c("plain"), {
  expect_snapshot({
    format_text_piece_substitution(
      list(
        value = 1:10,
        style = list("vec-trunc" = 100)
      ),
      list("vec-trunc" = 5, "vec-trunc-style" = "head")
    )
  })
})
