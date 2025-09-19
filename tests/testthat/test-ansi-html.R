test_that("ansi_html", {
  str <- c(
    "\033[1mbold\033[22m",
    "\033[2mfaint",
    "\033[3mitalic\033[0m",
    "\033[4munderline",
    "\033[5mblink",
    "\033[7minverse",
    "\033[8mhide",
    "\033[9mcrossedout",
    "\033[30mblack",
    "\033[31mred",
    "\033[32mgreen",
    "\033[33myellow",
    "\033[34mblue",
    "\033[35mmagenta",
    "\033[36mcyan",
    "\033[37mwhite",
    "\033[90mbblack",
    "\033[91mbred",
    "\033[92mbgreen",
    "\033[93mbyellow",
    "\033[94mbblue",
    "\033[95mbmagenta",
    "\033[96mbcyan",
    "\033[97mbwhite",
    "\033[38;5;156mcolor-156",
    "\033[38;2;1;22;255mcolor-1-22-255",
    "\033[40mbg-black",
    "\033[41mbg-red",
    "\033[42mbg-green",
    "\033[43mbg-yellow",
    "\033[44mbg-blue",
    "\033[45mbg-magenta",
    "\033[46mbg-cyan",
    "\033[47mbg-white",
    "\033[100mbg-bblack",
    "\033[101mbg-bred",
    "\033[102mbg-bgreen",
    "\033[103mbg-byellow",
    "\033[104mbg-bblue",
    "\033[105mbg-bmagenta",
    "\033[106mbg-bcyan",
    "\033[107mbg-bwhite",
    "\033[48;5;156mbg-color-156",
    "\033[48;2;1;22;255mbg-color-1-22-255"
  )
  expect_snapshot(
    ansi_html(str)
  )
})

test_that("multiple styles", {
  expect_snapshot(
    ansi_html("\033[1;2;35;45mmultiple")
  )
})

test_that("CSI", {
  expect_equal(
    ansi_html("foo\033[10Abar", csi = "drop"),
    "foobar"
  )
  expect_equal(
    ansi_html("\033[1mfoo\033[0m\033[10Abar", csi = "drop"),
    "<span class=\"ansi ansi-bold\">foo</span>bar"
  )
  expect_equal(
    ansi_html("foo\033[10Abar", csi = "keep"),
    "foo\033[10Abar"
  )
  expect_equal(
    ansi_html("\033[1mfoo\033[0m\033[10Abar", csi = "keep"),
    "<span class=\"ansi ansi-bold\">foo</span>\033[10Abar"
  )
})

test_that("ansi_html_style", {
  expect_snapshot(
    ansi_html_style(colors = 8)
  )
  expect_snapshot(
    ansi_html_style(colors = 256, palette = "ubuntu")
  )
})
