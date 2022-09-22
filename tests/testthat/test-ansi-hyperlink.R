
test_that("ansi_align", {
  txt0 <- "\033]8;;https://ex.com\007te\033]8;;\007"
  txt1 <- st_from_bel(txt0)
  txt <- paste0(txt0, txt1)
  space3 <- strrep(" ", 3)
  space6 <- strrep(" ", 6)
  expect_equal(
    ansi_align(txt, 10),
    ansi_string(paste0(txt, space6))
  )

  expect_equal(
    ansi_align(txt, 10, "center"),
    ansi_string(paste0(space3, txt, space3))
  )

  expect_equal(
    ansi_align(txt, 10, "right"),
    ansi_string(paste0(space6, txt))
  )
})

test_that("ansi_chartr", {
  txt0 <- "1\033]8;;https://ex.com\007text\033]8;;\0072"
  txt1 <- st_from_bel(txt0)
  txt <- paste0(txt0, txt1)
  expect_equal(
    ansi_chartr("12x0", "34yo", txt),
    ansi_string(paste0(
      "3\033]8;;https://ex.com\007teyt\033]8;;\0074",
      st_from_bel("3\033]8;;https://ex.com\007teyt\033]8;;\0074")
    ))
  )
})

test_that("ansi_columns", {
  txt <- "\033]8;;https://ex.com\007text\033]8;;\007"

  expect_equal(
    ansi_strip(ansi_columns(rep(txt, 4), 10)),
    c("text text ", "text text ")
  )
})

test_that("ansi_has_any", {
  txt <- "1\033]8;;https://ex.com\007text\033]8;;\0072"
  expect_true(ansi_has_any(txt))
  expect_true(ansi_has_any(txt, sgr = FALSE, csi = FALSE))
  expect_false(ansi_has_any(txt, link = FALSE))
})

test_that("ansi_html", {
  txt <- paste0(
    "1",
    "\033[1m\033]8;;https://ex.com\007",
    "text",
    "\033]8;;\007",
    "\033[22m",
    "2"
  )

  expect_equal(
    ansi_html(txt),
    paste0(
      "1",
      "<a class=\"ansi-link\" href=\"https://ex.com\">",
      "<span class=\"ansi ansi-bold\">",
      "text",
      "</span>",
      "</a>",
      "2"
    )
  )
})

test_that("ansi_nchar", {
  cases <- list(
    list("\033]8;;https://ex.com\007text\033]8;;\007", 4),
    list("\033]8;x=1:y=2;https://ex.com\007text\033]8;;\007", 4),
    list("\033]8;;https://ex.com\007text\033]8;;\007", 4),
    list("\033[1m\033]8;;https://ex.com\007text\033]8;;\007\033[22m", 4)
  )

  for (c in cases) {
    expect_equal(ansi_nchar(c[[1]]), c[[2]])
  }
})

test_that("ansi_regex", {
  cases <- c(
    "1\033]8;;https://ex.com\007text\033]8;;\0072",
    "1\033]8;x=1:y=2;https://ex.com\007text\033]8;;\0072",
    "1\033]8;;https://ex.com\007text\033]8;;\0072",
    "1\033[1m\033]8;;https://ex.com\007text\033]8;;\007\033[22m2"
  )

  for (case in cases) {
    expect_equal(gsub(ansi_regex(), "", case, perl = TRUE), "1text2")
  }
})

test_that("ansi_simplify", {
  txt <- "1\033[1m\033]8;;https://ex.com\007text\033]8;;\007\033[22m2"
  expect_equal(
    ansi_simplify(txt),
    ansi_string(
      "1\033]8;;https://ex.com\007\033[1mtext\033[22m\033]8;;\0072"
    )
  )
})

test_that("ansi_strip", {
  cases <- c(
    "1\033]8;;https://ex.com\007text\033]8;;\0072",
    "1\033]8;x=1:y=2;https://ex.com\007text\033]8;;\0072",
    "1\033]8;;https://ex.com\007text\033]8;;\0072",
    "1\033[1m\033]8;;https://ex.com\007text\033]8;;\007\033[22m2"
  )

  for (case in cases) {
    expect_equal(ansi_strip(case), "1text2")
  }

  txt <- "1\033[1m\033]8;;https://ex.com\007text\033]8;;\007\033[22m2"
  expect_equal(
    ansi_strip(txt, link = FALSE),
    "1\033]8;;https://ex.com\007text\033]8;;\0072"
  )
  expect_equal(
    ansi_strip(txt, sgr = FALSE),
    "1\033[1mtext\033[22m2"
  )
})

test_that("ansi_strsplit", {
  txt <- "1\033]8;;https://ex.com\007te;xt\033]8;;\0072"
  expect_equal(
    ansi_strsplit(txt, ";"),
    list(ansi_string(c(
      "1\033]8;;https://ex.com\007te\033]8;;\007",
      "\033]8;;https://ex.com\007xt\033]8;;\0072"
    )))
  )
})

test_that("ansi_strtrim", {
  txt <- "1\033]8;;https://ex.com\007text\033]8;;\0072"
  expect_equal(
    ansi_strtrim(txt, 6),
    ansi_string(txt)
  )
  expect_equal(
    ansi_strtrim(txt, 5),
    ansi_string(paste0(ansi_substr(txt, 1, 2), "..."))
  )
})

test_that("ansi_strwrap", {
  txt <- "1\033]8;;https://ex.com\007text\033]8;;\0072"
  wrp <- ansi_strwrap(strrep(paste0(txt, " "), 10), 15)
  expect_equal(
    wrp,
    ansi_string(rep(paste0(txt, " ", txt), 5))
  )
})

test_that("ansi_substr", {
  txt <- "1\033[1m\033]8;;https://ex.com\007text\033]8;;\007\033[22m2"

  cases <- list(
    list(1, 3, "1\033]8;;https://ex.com\007\033[1mte\033[22m\033]8;;\007"),
    list(4, 6, "\033]8;;https://ex.com\007\033[1mxt\033[22m\033]8;;\0072"),
    list(3, 4, "\033]8;;https://ex.com\007\033[1mex\033[22m\033]8;;\007"),
    list(1, 10, "1\033]8;;https://ex.com\007\033[1mtext\033[22m\033]8;;\0072")
  )

  for (c in cases) {
    expect_equal(ansi_substr(txt, c[[1]], c[[2]]), ansi_string(c[[3]]))
  }
})

test_that("ansi_substring", {
  txt <- "1\033[1m\033]8;;https://ex.com\007text\033]8;;\007\033[22m2"

  cases <- list(
    list(1, 3, "1\033]8;;https://ex.com\007\033[1mte\033[22m\033]8;;\007"),
    list(4, 6, "\033]8;;https://ex.com\007\033[1mxt\033[22m\033]8;;\0072"),
    list(3, 4, "\033]8;;https://ex.com\007\033[1mex\033[22m\033]8;;\007"),
    list(1, 10, "1\033]8;;https://ex.com\007\033[1mtext\033[22m\033]8;;\0072")
  )

  for (c in cases) {
    expect_equal(ansi_substring(txt, c[[1]], c[[2]]), ansi_string(c[[3]]))
  }
})

test_that("ansi_tolower", {
  txt <- "Pre\033]8;;https://ex.com\007tEXt\033]8;;\007PoST"
  expect_equal(
    ansi_tolower(txt),
    ansi_string("pre\033]8;;https://ex.com\007text\033]8;;\007post")
  )
})

test_that("ansi_toupper", {
  txt <- "Pre\033]8;;https://ex.com\007tEXt\033]8;;\007PoST"
  expect_equal(
    ansi_toupper(txt),
    ansi_string("PRE\033]8;;https://ex.com\007TEXT\033]8;;\007POST")
  )
})

test_that("ansi_trimws", {
  txt <- "1\033[1m\033]8;;https://ex.com\007text\033]8;;\007\033[22m2"
  expect_equal(
    ansi_trimws(paste0("   ", txt, "   ")),
    ansi_simplify(txt)
  )
  expect_equal(
    ansi_trimws(txt),
    ansi_string(txt)
  )
})

test_that("unknown hyperlink type", {
  expect_snapshot(
    error = TRUE,
    make_link("this", "foobar")
  )
})
