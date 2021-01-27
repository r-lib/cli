
test_that("ansi_string", {
  right <- c("ansi_string", "character")
  expect_equal(class(ansi_string("foobar")), right)
  expect_equal(class(ansi_string(133)), right)
  expect_equal(class(ansi_string(ansi_string(134))), right)
})

test_that("ansi_regex", {
  # somewhat special sequences
  cases <- list(
    list("foo\033[39;49mbar", "foobar"),
    list("foo\033[1;3;4mbar", "foobar"),
    list("foo\033[1;;4mbar", "foobar"),
    list("foo\033[mbar", "foobar")
  )

  for (case in cases) {
    expect_equal(gsub(ansi_regex(), "", case[[1]], perl = TRUE), case[[2]])
  }
})

test_that("ansi_has_any works", {
  withr::local_options(list(
    cli.num_colors = 256L,
    cli.hyperlink = TRUE
  ))
  expect_false(ansi_has_any("foobar"))
  for (sym in ls(asNamespace("cli"), pattern = "^col_|^bg_|^style_")) {
    fun <- get(sym, envir = asNamespace("cli"))
    expect_true(ansi_has_any(fun("foo", "bar")))
  }
})

test_that("ansi_strip works", {
  withr::local_options(list(
    cli.num_colors = 256L,
    cli.hyperlink = TRUE
  ))
  expect_equal("", ansi_strip(""))
  expect_equal("foobar", ansi_strip("foobar"))
  expect_equal(
    "foobar",
    ansi_strip(col_red(style_underline(style_bold("foobar"))))
  )


  for (sym in ls(asNamespace("cli"), pattern = "^col_|^bg_|^style_")) {
    fun <- get(sym, envir = asNamespace("cli"))
    ans <- if (sym == "style_hyperlink") "foo" else "foobar"
    expect_equal(ans, ansi_strip(fun("foo", "bar")))
  }
})

str <- c("",
         "plain",
         "\033[31m",
         "\033[39m",
         "\033[31mred\033[39m",
         "\033[31mred\033[39m\033[31mred\033[39m",
         "foo\033[31mred\033[39m",
         "\033[31mred\033[39mfoo")

test_that("ansi_nchar", {
  withr::local_options(list(cli.num_colors = 256L))
  for (s in str) {
    expect_equal(ansi_nchar(s), nchar(ansi_strip(s)), info = s)
  }
})

test_that("ansi_nchar wide characters", {
  expect_equal(ansi_nchar("\u231a", "width"), 2L)
})

test_that("ansi_substr bad input", {
  expect_error(
    ansi_substr("foobar", NULL, 10),
    "invalid substring arguments"
  )
  expect_error(
    ansi_substr("foobar", 10, NULL),
    "invalid substring arguments"
  )
})

test_that("ansi_substr", {
  withr::local_options(list(cli.num_colors = 256L))
  for (s in str) {
    for (i in 1 %:% ansi_nchar(s)) {
      for (j in i %:% ansi_nchar(s)) {
        expect_equal(ansi_strip(ansi_substr(s, i, j)),
                     substr(ansi_strip(s), i, j), info = paste(s, i, j))
      }
    }
  }
})

test_that("ansi_substr keeps color", {
  withr::local_options(list(cli.num_colors = 256L))
  expect_equal(
    ansi_substr("\033[31mred\033[39m", 1, 1),
    ansi_string("\033[31mr\033[39m")
  )
  expect_equal(
    ansi_substr("foo\033[31mred\033[39m", 4, 4),
    ansi_string("\033[31mr\033[39m")
  )
  expect_equal(
    ansi_substr("foo\033[31mred\033[39mbar", 4, 4),
    ansi_string("\033[31mr\033[39m")
  )
  expect_equal(
    ansi_substr("\033[31mred\033[39mfoo\033[31mred\033[39mbar", 7, 7),
    ansi_string("\033[31m\033[39m\033[31mr\033[39m")
  )
})

test_that("ansi_substr, start after string end", {
  withr::local_options(list(cli.num_colors = 256L))
  expect_equal(ansi_substr("red", 4, 4), ansi_string(""))
  expect_equal(ansi_substr("red", 4, 5), ansi_string(""))
  expect_equal(ansi_strip(ansi_substr("\033[31mred\033[39m", 4, 4)), "")
  expect_equal(ansi_strip(ansi_substr("\033[31mred\033[39m", 4, 5)), "")

  expect_equal(ansi_substr("red", 3, 4), ansi_string("d"))
  expect_equal(ansi_substr("red", 3, 5), ansi_string("d"))
  expect_equal(ansi_strip(ansi_substr("\033[31mred\033[39m", 3, 4)), "d")
  expect_equal(ansi_strip(ansi_substr("\033[31mred\033[39m", 3, 5)), "d")
})

test_that("ansi_substr, multiple strings", {
  withr::local_options(list(cli.num_colors = 256L))
  set.seed(42)
  for (i in 1:100) {
    strs <- sample(str, 4)
    num_starts <- sample(1:5, 1)
    num_stops <- sample(1:5, 1)
    starts <- sample(1:5, num_starts, replace = TRUE)
    stops <- sample(1:5, num_stops, replace = TRUE)
    r1 <- ansi_strip(ansi_substr(strs, starts, stops))
    r2 <- substr(ansi_strip(strs), starts, stops)
    expect_equal(r1, r2)
  }
})

test_that("ansi_substr corner cases", {
  withr::local_options(list(cli.num_colors = 256L))
  # Zero length input

  c0 <- character(0L)
  o0 <- structure(list(), class="abc")
  co0 <- structure(character(0L), class="abc")
  expect_identical(ansi_substr(c0, 1, 1), ansi_string(substr(c0, 1, 1)))
  expect_identical(ansi_substr(o0, 1, 1), ansi_string(substr(o0, 1, 1)))
  expect_identical(ansi_substr(co0, 1, 1), ansi_string(substr(co0, 1, 1)))

  expect_identical(
    ansi_substring(c0, 1, 1),
    ansi_string(substring(c0, 1, 1))
  )
  expect_identical(
    ansi_substring(o0, 1, 1),
    ansi_string(substring(o0, 1, 1))
  )
  expect_identical(
    ansi_substring(co0, 1, 1),
    ansi_string(substring(co0, 1, 1))
  )

  # Character start/stop
  expect_identical(
    ansi_substr("abc", "1", 1),
    ansi_string(substr("abc", "1", 1))
  )
  expect_identical(
    ansi_substr("abc", 1, "1"),
    ansi_string(substr("abc", 1, "1"))
  )

  # non-numeric arguments cause errors; NOTE: this actually "works"
  # with 'substr' but not implemented in 'ansi_substr'
  suppressWarnings(
    expect_error(ansi_substr("abc", "hello", 1), "non-numeric")
  )

})

test_that("ansi_substring", {
  withr::local_options(list(cli.num_colors = 256L))
  for (s in str) {
    for (i in 1 %:% ansi_nchar(s)) {
      for (j in i %:% ansi_nchar(s)) {
        expect_equal(ansi_strip(ansi_substring(s, i, j)),
                     substring(ansi_strip(s), i, j), info = paste(s, i, j))
      }
    }
  }
})

test_that("ansi_substring, multiple strings", {
  withr::local_options(list(cli.num_colors = 256L))
  set.seed(42)
  for (i in 1:100) {
    strs <- sample(str, 4)
    num_starts <- sample(1:5, 1)
    num_stops <- sample(1:5, 1)
    starts <- sample(1:5, num_starts, replace = TRUE)
    stops <- sample(1:5, num_stops, replace = TRUE)
    r1 <- ansi_strip(ansi_substring(strs, starts, stops))
    r2 <- substring(ansi_strip(strs), starts, stops)
    expect_equal(r1, r2)
  }
})

test_that("ansi_substring corner cases", {
  withr::local_options(list(cli.num_colors = 256L))
  # Zero length input

  c0 <- character(0L)
  o0 <- structure(list(), class="abc")
  co0 <- structure(character(0L), class="abc")
  expect_identical(
    ansi_substring(c0, 1, 1),
    ansi_string(substring(c0, 1, 1))
  )
  expect_identical(
    ansi_substring(o0, 1, 1),
    ansi_string(substring(o0, 1, 1))
  )
  expect_identical(
    ansi_substring(co0, 1, 1),
    ansi_string(substring(co0, 1, 1))
  )
})

test_that("ansi_strsplit", {
  withr::local_options(list(cli.num_colors = 256L))
  red <- "\033[31mred\033[39m"

  str <- "plain-plain"
  expect_equal(
    ansi_strsplit(str, "-"),
    lapply(strsplit(str, "-"), ansi_string)
  )

  str <- paste0(red, "-plain")
  expect_equal(
    ansi_strip(ansi_strsplit(str, "-")[[1]]),
    strsplit(ansi_strip(str), "-")[[1]]
  )

  expect_equal(
    ansi_strsplit(str, "e"),
    list(ansi_string(c("\033[31mr\033[39m", "\033[31md\033[39m-plain")))
  )

  str <- paste0(red, "-", red, "-", red)
  expect_equal(
    ansi_strip(ansi_strsplit(str, "-")[[1]]),
    strsplit(ansi_strip(str), "-")[[1]]
  )

  # with leading and trailing separators
  str.2 <- paste0("-", red, "-", red, "-", red, "-")
  expect_equal(ansi_strip(ansi_strsplit(str.2, "-")[[1]]),
               strsplit(ansi_strip(str.2), "-")[[1]])

  # greater than length 1
  str.3 <- paste0("-", c(col_green("hello"), col_red("goodbye")), "-world-")
  expect_equal(ansi_strip(unlist(ansi_strsplit(str.3, "-"))),
               unlist(strsplit(ansi_strip(str.3), "-")))
})

test_that("ansi_strsplit multiple strings", {
  withr::local_options(list(cli.num_colors = 256L))
  red <- "\033[31mred\033[39m"
  str <- c(
    paste0("plain-plain-", red, "-plain-", red),
    paste0(red, "-", red),
    red
  )

  r1 <- lapply(ansi_strsplit(str, "-"), ansi_strip)
  r2 <- strsplit(ansi_strip(str), "-")
  expect_equal(r1, r2)
})

test_that("ansi_strsplit edge cases", {
  withr::local_options(list(cli.num_colors = 256L))
  expect_equal(ansi_strsplit("", "-"), list(ansi_string(character(0L))))
  expect_equal(
    ansi_strip(ansi_strsplit("\033[31m\033[39m", "-")[[1]]), character(0L)
  )

  # special cases
  expect_equal(ansi_strsplit("", ""), lapply(strsplit("", ""), ansi_string))
  expect_equal(
    ansi_strsplit("a", "a"),
    lapply(strsplit("a", "a"), ansi_string)
  )

  # this following test isn't working yet
  expect_equal(
    ansi_strsplit("a", ""),
    lapply(strsplit("a", ""), ansi_string)
  )
  expect_equal(
    ansi_strsplit("", "a"),
    lapply(strsplit("", "a"), ansi_string)
  )

  # Longer strings
  expect_identical(
    ansi_strsplit(c("", "a", "aa"), "a"),
    lapply(strsplit(c("", "a", "aa"), "a"), ansi_string)
  )
  expect_identical(
    ansi_strsplit(c("abaa", "ababza"), "b."),
    lapply(strsplit(c("abaa", "ababza"), "b."), ansi_string)
  )
})

test_that("Weird length 'split'", {
  withr::local_options(list(cli.num_colors = 256L))
  expect_error(
    ansi_strsplit(c("ab", "bd"), c("b", "d")),
    "must be character"
  )
  expect_identical(
    ansi_strsplit("ab", NULL),
    lapply(strsplit("ab", NULL), ansi_string)
  )
  expect_identical(
    ansi_strsplit("ab", character(0L)),
    lapply(strsplit("ab", character(0L)), ansi_string)
  )
})

test_that("ansi_align", {
  withr::local_options(list(cli.num_colors = 256L))
  expect_equal(ansi_align(character()), ansi_string(character()))
  expect_equal(ansi_align("", 0), ansi_string(""))
  expect_equal(ansi_align(" ", 0), ansi_string(" "))
  expect_equal(ansi_align(" ", 1), ansi_string(" "))
  expect_equal(ansi_align(" ", 2), ansi_string("  "))
  expect_equal(ansi_align("a", 1), ansi_string("a"))
  expect_equal(ansi_align(letters, 1), ansi_string(letters))
  expect_equal(ansi_align(letters, 0), ansi_string(letters))
  expect_equal(ansi_align(letters, -1), ansi_string(letters))

  expect_equal(ansi_align(letters, 2), ansi_string(paste0(letters, " ")))
  expect_equal(
    ansi_align(letters, 3, "center"),
    ansi_string(paste0(" ", letters, " "))
  )
  expect_equal(
    ansi_align(letters, 2, "right"),
    ansi_string(paste0(" ", letters))
  )

  expect_equal(
    ansi_align(c("foo", "foobar", "", "a"), 6, "left"),
    ansi_string(c("foo   ", "foobar", "      ", "a     ")))

  expect_equal(
    ansi_align(c("foo", "foobar", "", "a"), 6, "center"),
    ansi_string(c("  foo ", "foobar", "      ", "   a  ")))

  expect_equal(
    ansi_align(c("foo", "foobar", "", "a"), 6, "right"),
    ansi_string(c("   foo", "foobar", "      ", "     a")))

  # #54: alignment of wide characters
  expect_equal(
    ansi_align(c("foo", "\u6210\u4ea4\u65e5", "", "a"), 6, "left"),
    ansi_string(c("foo   ", "\u6210\u4ea4\u65e5", "      ", "a     ")))

  expect_equal(
    ansi_align(c("foo", "\u6210\u4ea4\u65e5", "", "a"), 6, "center"),
    ansi_string(c("  foo ", "\u6210\u4ea4\u65e5", "      ", "   a  ")))

  expect_equal(
    ansi_align(c("foo", "\u6210\u4ea4\u65e5", "", "a"), 6, "right"),
    ansi_string(c("   foo", "\u6210\u4ea4\u65e5", "      ", "     a")))
})

test_that("stripping hyperlinks", {
  withr::local_options(list(cli.hyperlink = TRUE))
  x <- unclass(style_hyperlink("foo", "https://r-pkg.org"))
  expect_equal(
    ansi_strip(paste0("1111-", x, "-2222-", x, "-333")),
    "1111-foo-2222-foo-333"
  )
})

test_that("ansi_trimws", {
  cases <- list(
    list(character(), ansi_string(character())),
    list(1, ansi_string(1)),
    list("", ansi_string("")),
    list("foo", ansi_string("foo")),
    list("  foo  ", ansi_string("foo")),
    list(c("foo", "bar"), ansi_string(c("foo", "bar"))),
    list(col_red(c("  colored  ")), ansi_string(col_red("colored"))),
    list(
      paste0("   ", col_red(c("  colored  ")), "   "),
      ansi_string(col_red("colored")))
  )

  for (case in cases) expect_equal(ansi_trimws(case[[1]]), case[[2]])

  cases_left <- list(
    list(character(), ansi_string(character())),
    list(1, ansi_string(1)),
    list("", ansi_string("")),
    list("foo", ansi_string("foo")),
    list("  foo  ", ansi_string("foo  ")),
    list(c("foo", "bar"), ansi_string(c("foo", "bar"))),
    list(col_red(c("  colored  ")), ansi_string(col_red("colored  "))),
    list(
      paste0("   ", col_red(c("  colored  ")), "   "),
      ansi_string(paste0(col_red("colored  "), "   ")))
  )

  for (case in cases_left) {
    expect_equal(ansi_trimws(case[[1]], "left"), case[[2]])
  }

  cases_right <- list(
    list(character(), ansi_string(character())),
    list(1, ansi_string(1)),
    list("", ansi_string("")),
    list("foo", ansi_string("foo")),
    list("  foo  ", ansi_string("  foo")),
    list(c("foo", "bar"), ansi_string(c("foo", "bar"))),
    list(col_red(c("  colored  ")), ansi_string(col_red("  colored"))),
    list(
      paste0("   ", col_red(c("  colored  ")), "   "),
      ansi_string(paste0("   ", col_red("  colored"))))
  )

  for (case in cases_left) {
    expect_equal(ansi_trimws(case[[1]], "left"), case[[2]])
  }
})

test_that("ansi_strwrap simple", {
  cases = list(
    list(character(), character()),
    list("", ""),
    list("foo", "foo"),
    list(1, "1"),
    list(c("foo", "bar"), c("foo", "bar"))
  )

  for (case in cases) {
    expect_equal(ansi_strwrap(case[[1]], 20), ansi_string(case[[2]]))
  }
})

test_that("ansi_strwrap simple styled", {
  cases = list(
    list(col_red("foo"), col_red("foo")),
    list(col_red(c("foo", "bar")), col_red(c("foo", "bar")))
  )

  for (case in cases) {
    expect_equal(ansi_strwrap(case[[1]], 20), ansi_string(case[[2]]))
  }
})

test_that("ansi_strwrap", {
  txt0 <- glue::glue_col("
    {col_red Velit occaecat} quis culpa occaecat.  {col_green Pariatur} \\
    ad veniam pariatur {bg_blue consectetur}.  Dolore aliquip et \\
    {style_underline consequat Lorem consectetur} dolor.  Irure id velit \\
    proident elit veniam eu exercitation nisi laboris officia.     Qui \\
    {col_red sunt      occaecat} cillum {col_red sit    commodo sit.    \\
    Culpa} aliquip et consectetur ullamco aliqua Lorem laborum dolore.    ")

  txt <- paste0(txt0, "\n\t  \n", txt0)
  expect_equal(
    ansi_strip(ansi_strwrap(txt0, 40)),
    strwrap(ansi_strip(txt0), 40)
  )
  expect_equal(
    ansi_strip(ansi_strwrap(txt, 40)),
    strwrap(ansi_strip(txt), 40)
  )
  expect_equal(
    ansi_strip(ansi_strwrap(txt, 40, indent = 2)),
    strwrap(ansi_strip(txt), 40, indent = 2)
  )
  expect_equal(
    ansi_strip(ansi_strwrap(txt, 40, exdent = 2)),
    strwrap(ansi_strip(txt), 40, exdent = 2)
  )
  expect_equal(
    ansi_strip(ansi_strwrap(txt, 40, indent = 2, exdent = 4)),
    strwrap(ansi_strip(txt), 40, indent = 2, exdent = 4)
  )
})

test_that("ansi_strwrap double width", {
  expect_equal(
    ansi_strwrap("\U0001F477 1 2 3", 4),
    ansi_string(c("\U0001f477", "1 2", "3"))
  )
})

test_that("ansi_strwrap newlines", {
  expect_equal(
    ansi_strwrap("\033[32mv\033[39m hello world.\nxxx"),
    ansi_string("\033[32mv\033[39m hello world. xxx")
  )
})

test_that("ansi_strtrim", {
  withr::local_options(c(cli.unicode = FALSE))
  setup_unicode_width_fix()
  cases <- list(
    list("", ansi_string("")),
    list("1", ansi_string("1")),
    list("123456789", ansi_string("123456789")),
    list("1234567890", ansi_string("1234567890")),
    list("12345678901", ansi_string("1234567...")),
    list(
      strrep("\u231A", 6),
      ansi_string(paste0(strrep("\u231A", 3), "..."))),
    list(col_red("1"), col_red("1"))
  )

  for (case in cases) expect_equal(ansi_strtrim(case[[1]], 10), case[[2]])
})

test_that("ansi_columns", {
  withr::local_options(c(cli.unicode = FALSE))
  local_edition(3)

  expect_equal(ansi_columns(character()), ansi_string(character()))

  expect_snapshot_output(
    cat(ansi_columns(paste("foo", 1:10), width = 40), sep = "\n")
  )
  txt60 <- strrep("1234567890", 6)
  expect_snapshot_output(
    cat(ansi_columns(txt60, width = 15), sep = "\n")
  )
})
