
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
