test_that("empty input", {
  expect_snapshot(
    vt_output("", width = 20, height = 2)$segment
  )
})

test_that("raw input", {
  expect_snapshot(
    vt_output(charToRaw("foobar"), width = 20, height = 2)$segment
  )
})

test_that("overflow", {
  expect_snapshot(
    vt_output(strrep("1234567890", 2), width = 19, height = 2)$segment
  )
})

test_that("control characters", {
  expect_snapshot(
    vt_output("foo\nbar", width = 20, height = 2)$segment
  )
  expect_snapshot(
    vt_output("foobar\rbaz", width = 20, height = 2)$segment
  )
})

test_that("scroll up", {
  expect_snapshot(
    vt_output(strrep("1234567890", 5), width = 20, height = 2)$segment
  )
  expect_snapshot(
    vt_output(paste0(1:10, "\n"), width = 10, height = 5)$segment
  )
})

test_that_cli(configs = "ansi", "ANSI SGR", {
  expect_snapshot(
    vt_output(
      "12\033[31m34\033[1m56\033[39m78\033[21m90",
      width = 20,
      height = 2
    )
  )

  expect_snapshot(
    vt_output(style_bold("I'm bold"), width = 20, height = 2)
  )

  expect_snapshot(
    vt_output(style_italic("I'm italic"), width = 20, height = 2)
  )

  expect_snapshot(
    vt_output(style_underline("I'm underlined"), width = 20, height = 2)
  )

  expect_snapshot(
    vt_output(style_strikethrough("I'm strikethrough"), width = 20, height = 2)
  )

  expect_snapshot(
    vt_output(style_inverse("I'm inverse"), width = 20, height = 2)
  )
})

test_that("hyperlinks", {
  withr::local_options(cli.hyperlink = TRUE)
  expect_snapshot({
    link <- style_hyperlink("text", "url")
    vt_output(c("pre ", st_from_bel(link), " post"), width = 20, height = 2)
  })
  expect_snapshot({
    link <- style_hyperlink("text", "url", params = c("f" = "x", "g" = "y"))
    vt_output(c("pre ", st_from_bel(link), " post"), width = 20, height = 2)
  })
})

test_that("erase in line", {
  expect_snapshot({
    vt_output("foobar\033[3D\033[K", width = 10, height = 2)$segment
    vt_output("foobar\033[3D\033[0K", width = 10, height = 2)$segment
    vt_output("foobar\033[3D\033[1K", width = 10, height = 2)$segment
    vt_output("foobar\033[3D\033[2K", width = 10, height = 2)$segment
  })
})

test_that("erase in screen", {
  expect_snapshot({
    vt_output(
      "foo\nfoobar\nfoobar2\033[A\033[4D\033[J",
      width = 10,
      height = 4
    )$segment
    vt_output(
      "foo\nfoobar\nfoobar2\033[A\033[4D\033[0J",
      width = 10,
      height = 4
    )$segment
    vt_output(
      "foo\nfoobar\nfoobar2\033[A\033[4D\033[1J",
      width = 10,
      height = 4
    )$segment
    vt_output(
      "foo\nfoobar\nfoobar2\033[A\033[4D\033[2Jx",
      width = 10,
      height = 4
    )$segment
    vt_output(
      "foo\nfoobar\nfoobar2\033[A\033[4D\033[3Jx",
      width = 10,
      height = 4
    )$segment
  })
})

test_that("colors", {
  expect_equal(vt_output("\033[30mcolored\033[39m")$color[1], "0")
  expect_equal(vt_output("\033[37mcolored\033[39m")$color[1], "7")
  expect_equal(vt_output("\033[90mcolored\033[39m")$color[1], "8")
  expect_equal(vt_output("\033[97mcolored\033[39m")$color[1], "15")

  expect_equal(vt_output("\033[40mcolored\033[39m")$background_color[1], "0")
  expect_equal(vt_output("\033[47mcolored\033[39m")$background_color[1], "7")
  expect_equal(vt_output("\033[100mcolored\033[39m")$background_color[1], "8")
  expect_equal(vt_output("\033[107mcolored\033[39m")$background_color[1], "15")

  expect_equal(vt_output("\033[38;5;100mcolored\033[39m")$color[1], "100")
  expect_equal(
    vt_output("\033[48;5;110mcolored\033[39m")$background_color[1],
    "110"
  )

  expect_equal(vt_output("\033[38;2;1;2;3mcolored\033[39m")$color[1], "#010203")
  expect_equal(
    vt_output("\033[48;2;4;5;6mcolored\033[39m")$background_color[1],
    "#040506"
  )
})
