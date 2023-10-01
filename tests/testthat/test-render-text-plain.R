test_that_cli("render_inline_text_piece_plain", configs = c("plain", "ansi"), {
  expect_snapshot({
    render_inline_text_piece_plain("this is a test")
    render_inline_text_piece_plain(
      styled_text("test", list("background-color" = "cyan"))
    )
    render_inline_text_piece_plain(
      styled_text("this is a test", list(color = "red"))
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
