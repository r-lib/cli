
test_that("ansi_align", {

})

test_that("ansi_chartr", {

})

test_that("ansi_columns", {

})

test_that("ansi_has_any", {

})

test_that("ansi_html", {

})

test_that("ansi_html_style", {

})

test_that("ansi_nchar", {
  cases <- list(
    list("\033]8;;https://ex.com\033\\text\033]8;;\033\\", 4),
    list("\033]8;x=1:y=2;https://ex.com\033\\text\033]8;;\033\\", 4),
    list("\033]8;;https://ex.com\033\\text\033]8;;\033\\", 4),
    list("\033[1m\033]8;;https://ex.com\033\\text\033]8;;\033\\\033[21m", 4)    
  )

  for (c in cases) {
    expect_equal(ansi_nchar(c[[1]]), c[[2]])
  }
})

test_that("ansi_regex", {
  cases <- c(
    "1\033]8;;https://ex.com\033\\text\033]8;;\033\\2",
    "1\033]8;x=1:y=2;https://ex.com\033\\text\033]8;;\033\\2",
    "1\033]8;;https://ex.com\033\\text\033]8;;\033\\2",
    "1\033[1m\033]8;;https://ex.com\033\\text\033]8;;\033\\\033[21m2"
  )

  for (case in cases) {
    expect_equal(gsub(ansi_regex(), "", case, perl = TRUE), "1text2")
  }
})

test_that("ansi_simplify", {

})

test_that("ansi_strip", {

})

test_that("ansi_strsplit", {

})

test_that("ansi_strtrim", {

})

test_that("ansi_strwrap", {

})

test_that("ansi_substr", {

})

test_that("ansi_substring", {

})

test_that("ansi_tolower", {

})

test_that("ansi_toupper", {

})

test_that("ansi_trimws", {

})
