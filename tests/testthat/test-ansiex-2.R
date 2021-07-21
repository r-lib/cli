
test_that("very long strings", {
  withr::local_options(cli.num_colors = 256)
  str <- strrep("1234 ", 1000)
  expect_equal(
    ansi_simplify(col_red(col_red(str))),
    col_red(str)
  )

  str2 <- paste0(col_green(str), col_red(str))
  expect_equal(
    ansi_simplify(col_green(str2)),
    ansi_string(str2)
  )
})

test_that("RGB colors", {
  cases <- list(
    list("\033[38;5;123mfoo\033[39m", "\033[38;5;123mfoo\033[39m"),
    list("\033[38;2;1;2;3mfoo\033[39m", "\033[38;2;1;2;3mfoo\033[39m"),
    list("\033[38;2;mfoo\033[39m", "\033[38;2;0;0;0mfoo\033[39m"),
    list("\033[48;5;123mfoo\033[49m", "\033[48;5;123mfoo\033[49m"),
    list("\033[48;2;1;2;3mfoo\033[49m", "\033[48;2;1;2;3mfoo\033[49m"),
    list("\033[48;2;mfoo\033[49m", "\033[48;2;0;0;0mfoo\033[49m"),
    ## bad tags are skipped completely
    list("\033[48;4;12mfoo\033[49m", "foo")
  )

  for (c in cases) {
    expect_equal(ansi_simplify(c[[1]]), ansi_string(c[[2]]))
  }
})

test_that("0m closing tag", {
  cases <- list(
    list("\033[1mfoo\033[0m", "\033[1mfoo\033[22m"),
    list("\033[1mfoo\033[m", "\033[1mfoo\033[22m")
  )

  for (c in cases) {
    expect_equal(ansi_simplify(c[[1]]), ansi_string(c[[2]]))
  }
})

test_that("various tags", {
  cases <- list(
    list("\033[1m\033[22m\033[1mfoo",   "\033[1mfoo\033[22m"),
    list("\033[2m\033[22m\033[2mfoo",   "\033[2mfoo\033[22m"),
    list("\033[3m\033[23m\033[3mfoo",   "\033[3mfoo\033[23m"),
    list("\033[4m\033[24m\033[4mfoo",   "\033[4mfoo\033[24m"),
    list("\033[5m\033[25m\033[5mfoo",   "\033[5mfoo\033[25m"),
    list("\033[7m\033[27m\033[7mfoo",   "\033[7mfoo\033[27m"),
    list("\033[8m\033[28m\033[8mfoo",   "\033[8mfoo\033[28m"),
    list("\033[9m\033[29m\033[9mfoo",   "\033[9mfoo\033[29m"),
    list("\033[30m\033[39m\033[30mfoo", "\033[30mfoo\033[39m"),
    list("\033[31m\033[39m\033[31mfoo", "\033[31mfoo\033[39m"),
    list("\033[32m\033[39m\033[32mfoo", "\033[32mfoo\033[39m"),
    list("\033[33m\033[39m\033[33mfoo", "\033[33mfoo\033[39m"),
    list("\033[34m\033[39m\033[34mfoo", "\033[34mfoo\033[39m"),
    list("\033[35m\033[39m\033[35mfoo", "\033[35mfoo\033[39m"),
    list("\033[36m\033[39m\033[36mfoo", "\033[36mfoo\033[39m"),
    list("\033[37m\033[39m\033[37mfoo", "\033[37mfoo\033[39m"),
    list("\033[90m\033[39m\033[90mfoo", "\033[90mfoo\033[39m"),
    list("\033[91m\033[39m\033[91mfoo", "\033[91mfoo\033[39m"),
    list("\033[92m\033[39m\033[92mfoo", "\033[92mfoo\033[39m"),
    list("\033[93m\033[39m\033[93mfoo", "\033[93mfoo\033[39m"),
    list("\033[94m\033[39m\033[94mfoo", "\033[94mfoo\033[39m"),
    list("\033[95m\033[39m\033[95mfoo", "\033[95mfoo\033[39m"),
    list("\033[96m\033[39m\033[96mfoo", "\033[96mfoo\033[39m"),
    list("\033[97m\033[39m\033[97mfoo", "\033[97mfoo\033[39m"),
    list("\033[40m\033[49m\033[40mfoo", "\033[40mfoo\033[49m"),
    list("\033[41m\033[49m\033[41mfoo", "\033[41mfoo\033[49m"),
    list("\033[42m\033[49m\033[42mfoo", "\033[42mfoo\033[49m"),
    list("\033[43m\033[49m\033[43mfoo", "\033[43mfoo\033[49m"),
    list("\033[44m\033[49m\033[44mfoo", "\033[44mfoo\033[49m"),
    list("\033[45m\033[49m\033[45mfoo", "\033[45mfoo\033[49m"),
    list("\033[46m\033[49m\033[46mfoo", "\033[46mfoo\033[49m"),
    list("\033[47m\033[49m\033[47mfoo", "\033[47mfoo\033[49m"),
    list("\033[100m\033[49m\033[100mfoo", "\033[100mfoo\033[49m"),
    list("\033[101m\033[49m\033[101mfoo", "\033[101mfoo\033[49m"),
    list("\033[102m\033[49m\033[102mfoo", "\033[102mfoo\033[49m"),
    list("\033[103m\033[49m\033[103mfoo", "\033[103mfoo\033[49m"),
    list("\033[104m\033[49m\033[104mfoo", "\033[104mfoo\033[49m"),
    list("\033[105m\033[49m\033[105mfoo", "\033[105mfoo\033[49m"),
    list("\033[106m\033[49m\033[106mfoo", "\033[106mfoo\033[49m"),
    list("\033[107m\033[49m\033[107mfoo", "\033[107mfoo\033[49m")
  )

  for (c in cases) {
    expect_equal(ansi_simplify(c[[1]]), ansi_string(c[[2]]))
  }
})

test_that("unknown tags are kept as is, and [0m is also kept for then", {
  cases <- list(
    list("\033[11mfoo\033[0m", "\033[11mfoo\033[0m")
  )
  for (c in cases) {
    expect_equal(ansi_simplify(c[[1]]), ansi_string(c[[2]]))
  }
})

test_that("simplify w/o tags", {
  cases <- list(
    list(c("", "foo", "\033[1mbold"), c("", "foo", "\033[1mbold\033[22m"))
  )
  for (c in cases) {
    expect_equal(ansi_simplify(c[[1]]), ansi_string(c[[2]]))
  }
})

test_that("CSI sequences", {
  expect_equal(
    ansi_simplify("foo\033[10Abar", csi = "drop"),
    ansi_string("foobar")
  )
  expect_equal(
    ansi_simplify("\033[1mfoo\033[0m\033[10Abar", csi = "drop"),
    ansi_string("\033[1mfoo\033[22mbar")
  )
  expect_equal(
    ansi_simplify("foo\033[10Abar", csi = "keep"),
    ansi_string("foo\033[10Abar")
  )
  expect_equal(
    ansi_simplify("\033[1mfoo\033[0m\033[10Abar", csi = "keep"),
    ansi_string("\033[1mfoo\033[10A\033[22mbar")
  )
  expect_equal(
    ansi_strip("\033[1mfoo\033[10Abar\033[0m", csi = TRUE, sgr = FALSE),
    "\033[1mfoobar\033[0m"
  )
  expect_equal(
    ansi_strip("\033[1mfoo\033[10Abar\033[0m", csi = FALSE, sgr = TRUE),
    "foo\033[10Abar"
  )
})

test_that("ansi_has_any", {
  T <- TRUE
  F <- FALSE
  expect_false(ansi_has_any("foobar",                sgr = T, csi = T))
  expect_true (ansi_has_any("\033[1mfoobar",         sgr = T, csi = T))
  expect_true (ansi_has_any("\033[10Afoobar",        sgr = T, csi = T))
  expect_true (ansi_has_any("\033[10A\033[1mfoobar", sgr = T, csi = T))
  expect_false(ansi_has_any("foobar",                sgr = T, csi = F))
  expect_true (ansi_has_any("\033[1mfoobar",         sgr = T, csi = F))
  expect_false(ansi_has_any("\033[10Afoobar",        sgr = T, csi = F))
  expect_true (ansi_has_any("\033[10A\033[1mfoobar", sgr = T, csi = F))
  expect_false(ansi_has_any("foobar",                sgr = F, csi = T))
  expect_false(ansi_has_any("\033[1mfoobar",         sgr = F, csi = T))
  expect_true (ansi_has_any("\033[10Afoobar",        sgr = F, csi = T))
  expect_true (ansi_has_any("\033[10A\033[1mfoobar", sgr = F, csi = T))
  expect_false(ansi_has_any("foobar",                sgr = F, csi = F))
  expect_false(ansi_has_any("\033[1mfoobar",         sgr = F, csi = F))
  expect_false(ansi_has_any("\033[10Afoobar",        sgr = F, csi = F))
  expect_false(ansi_has_any("\033[10A\033[1mfoobar", sgr = F, csi = F))
})

test_that("NA", {
  T <- TRUE
  F <- FALSE
  s <- c("foo", NA, "bar", "\033[1mfoobar")

  expect_equal(
    ansi_simplify(s),
    ansi_string(c("foo", NA, "bar", "\033[1mfoobar\033[22m"))
  )
  expect_equal(is.na(ansi_simplify(s)), c(F, T, F, F))

  expect_equal(
    ansi_substr(s, 1, 2),
    ansi_string(c("fo", NA, "ba", "\033[1mfo\033[22m"))
  )
  expect_equal(is.na(ansi_substr(s, 1, 2)), c(F, T, F, F))

  expect_snapshot(ansi_html(s))
  expect_equal(is.na(ansi_html(s)), c(F, T, F, F))

  expect_equal(ansi_has_any(s), c(F, NA, F, T))

  expect_equal(ansi_strip(s), c("foo", NA, "bar", "foobar"))
  expect_equal(is.na(ansi_strip(s)), c(F, T, F, F))
})

test_that("strrep", {
  expect_equal(strrep(character(), 5), character())
  expect_equal(strrep("a", 5), "aaaaa")
})

test_that("convert to character", {
  expect_false(ansi_has_any(123))
  expect_equal(ansi_strip(123), "123")
  expect_equal(ansi_substr(1234, 2, 3), ansi_string("23"))
  expect_equal(ansi_substring(1234, 2, 3), ansi_string("23"))
  expect_equal(ansi_strsplit(1234, 2), list(ansi_string(c("1", "34"))))
  expect_equal(ansi_trimws(123), ansi_string("123"))
  expect_equal(ansi_strwrap(123), ansi_string("123"))
  expect_equal(ansi_simplify(123), ansi_string("123"))
  expect_equal(ansi_html(123), "123")
  expect_equal(ansi_nchar(123), 3)
})

test_that("ansi_nchar", {
  b <- col_red(c(
    "\U0001f477\U0001f3fb",
    "\U0001f477\U0001f3fc\u200d\u2642\ufe0f",
    "\U0001f477\U0001f3fd\u200d\u2640\ufe0f",
    "\U0001f477",
    "\U0001f477\U0001f3fe\u200d\u2640\ufe0f"
  ))
  expect_equal(ansi_nchar(b), rep(1L, 5))
  expect_equal(ansi_nchar(b, "chars"), rep(1L, 5))
  expect_equal(ansi_nchar(b, "bytes"), c(8L, 17L, 17L, 4L, 17L))
  expect_equal(ansi_nchar(b, "width"), rep(2L, 5))
  expect_equal(ansi_nchar(b, "graphemes"), rep(1L, 5))
  expect_equal(ansi_nchar(b, "codepoints"), c(2L, 5L, 5L, 1L, 5L))

  bb <- paste0(b, collapse = "")
  expect_equal(ansi_nchar(bb), sum(rep(1L, 5)))
  expect_equal(ansi_nchar(bb, "chars"), sum(rep(1L, 5)))
  expect_equal(ansi_nchar(bb, "bytes"), sum(c(8L, 17L, 17L, 4L, 17L)))
  expect_equal(ansi_nchar(bb, "width"), sum(rep(2L, 5)))
  expect_equal(ansi_nchar(bb, "graphemes"), sum(rep(1L, 5)))
  expect_equal(ansi_nchar(bb, "codepoints"), sum(c(2L, 5L, 5L, 1L, 5L)))

  expect_equal(ansi_nchar(character(), "chars"), integer())
  expect_equal(ansi_nchar(character(), "bytes"), integer())
  expect_equal(ansi_nchar(character(), "width"), integer())
  expect_equal(ansi_nchar(character(), "graphemes"), integer())
  expect_equal(ansi_nchar(character(), "codepoints"), integer())

  expect_equal(ansi_nchar("", "chars"), 0L)
  expect_equal(ansi_nchar("", "bytes"), 0L)
  expect_equal(ansi_nchar("", "width"), 0L)
  expect_equal(ansi_nchar("", "graphemes"), 0L)
  expect_equal(ansi_nchar("", "codepoints"), 0L)
})

test_that("ansi_align with graphemes", {
  withr::local_options(cli.num_colors = 256)

  b <- col_red(c(
    "\U0001f477\U0001f3fb",
    "\U0001f477\U0001f3fc\u200d\u2642\ufe0f",
    "\U0001f477\U0001f3fd\u200d\u2640\ufe0f",
    "\U0001f477",
    "\U0001f477\U0001f3fe\u200d\u2640\ufe0f"
  ))

  expect_equal(
    ansi_align(b, width = 10, align = "left"),
    ansi_string(paste0(b, strrep(" ", 8)))
  )
  expect_equal(
    ansi_align(b, width = 10, align = "center"),
    ansi_string(paste0(strrep(" ", 4), b, strrep(" ", 4)))
  )
  expect_equal(
    ansi_align(b, width = 10, align = "right"),
    ansi_string(paste0(strrep(" ", 8), b))
  )
})

test_that("ansi_columns with graphemes", {
  withr::local_options(cli.num_colors = 256)

  b <- col_red(c(
    "\U0001f477\U0001f3fb",
    "\U0001f477\U0001f3fc\u200d\u2642\ufe0f",
    "\U0001f477\U0001f3fd\u200d\u2640\ufe0f",
    "\U0001f477",
    "\U0001f477\U0001f3fe\u200d\u2640\ufe0f"
  ))

  expect_equal(
    ansi_columns(b, width = 6),
    ansi_string(c(
      paste0(b[1], " ", b[2], " "),
      paste0(b[3], " ", b[4], " "),
      paste0(b[5], "    ")
    ))
  )
})
