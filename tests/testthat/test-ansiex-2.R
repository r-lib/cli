
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
