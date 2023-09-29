test_that_cli("render_inline_text_piece_plain", configs = c("plain", "ansi"), {
  expect_snapshot({
    render_inline_text_piece_plain("this is a test")
    render_inline_text_piece_plain(
      styled_text("this is a test", list(color = "red"))
    )
    render_inline_text_piece_plain(
      styled_text("test", list("background-color" = "cyan"))
    )
    render_inline_text_piece_plain(
      styled_text("this is a test", list("font-style" = "italic"))
    )
    render_inline_text_piece_plain(
      styled_text("this is a test", list("font-weight" = "bold"))
    )
    render_inline_text_piece_plain(
      styled_text("test", list("text-decoration" = "underline"))
    )

    render_inline_text_piece_plain(styled_text(
      "text",
      list(color = "green", fmt = function(x) paste0("{", x, "}"))
    ))
  })
})

test_that_cli("render_inline_text_piece_substitution", configs = c("plain"), {
  expect_snapshot({
    render_inline_text_piece_substitution(list(value = 1:5))
    render_inline_text_piece_substitution(list(value = 1:20))
    render_inline_text_piece_substitution(list(value = 1:21))
    render_inline_text_piece_substitution(list(value = 1:100))
  })

  # transform
  expect_snapshot({
    render_inline_text_piece_substitution(
      styled_sub(1:5, style = list(transform = function(x) x + x))
    )
  })

  # collapse
  expect_snapshot({
    render_inline_text_piece_substitution(
      styled_sub(1:5, style = list(collapse = "|"))
    )
    render_inline_text_piece_substitution(styled_sub(
      value = 1:5,
      style = list(collapse = function(x) paste(x, collapse = "|"))
    ))
  })

  # before, after
  expect_snapshot({
    render_inline_text_piece_substitution(styled_sub(
      value = 1:5,
      style = list(before = "<", after = ">")
    ))
  })

  # before, after + collapse
  expect_snapshot({
    render_inline_text_piece_substitution(styled_sub(
      value = 1:5,
      style = list(collapse = "|", before = "<", after = ">")
    ))
  })

  # prefix, postfix
  expect_snapshot({
    render_inline_text_piece_substitution(styled_sub(
      value = 1:5,
      style = list(prefix = "[", postfix = "]")
    ))
  })

  # vec-sep, vec-sep2, vec-last
  expect_snapshot({
    render_inline_text_piece_substitution(styled_sub(
      value = 1:5,
      style = list("vec-sep" = " + ")
    ))
    render_inline_text_piece_substitution(styled_sub(
      value = 1:5,
      style = list("vec-sep" = " + ", "vec-last" = " + ")
    ))
    render_inline_text_piece_substitution(styled_sub(
      value = 1:2,
      style = list("vec-sep" = " + ", "vec-sep2" = " ++ ", "vec-last" = " + ")
    ))
  })

  # vec-trunc, vec-trunc-style
  expect_snapshot({
    render_inline_text_piece_substitution(styled_sub(
      value = 1:10,
      style = list("vec-trunc" = 5)
    ))
    render_inline_text_piece_substitution(styled_sub(
      value = 1:10,
      style = list("vec-trunc" = 5, "vec-trunc-style" = "both-ends")
    ))
    render_inline_text_piece_substitution(styled_sub(
      value = 1:10,
      style = list("vec-trunc" = 5, "vec-trunc-style" = "head")
    ))
  })
})
