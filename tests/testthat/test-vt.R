
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

test_that_cli(config = "ansi", "ANSI SGR", {
  expect_snapshot(
    vt_output("12\033[31m34\033[1m56\033[39m78\033[21m90", width = 20, height = 2)
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
