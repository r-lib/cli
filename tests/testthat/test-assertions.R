
context("assertions")

test_that("is_string", {

  strings <- list("foo", "", "111", "1", "-", "NA")
  not_strings <- list(1, character(), NA_character_, NA,
                      c("foo", NA), c("1", "2"), NULL)

  for (p in strings) {
    expect_true(is_string(p))
    expect_silent(assert_that(is_string(p)))
  }

  for (n in not_strings) {
    expect_false(is_string(n))
    expect_error(assert_that(is_string(n)), "is not a string")
  }
})

test_that("is_border_style", {
  expect_true(is_border_style(rownames(box_styles())[1]))
  expect_false(is_border_style("blahblahxxx"))

  expect_silent(assert_that(is_border_style(rownames(box_styles())[1])))
  expect_error(assert_that(is_border_style("blahblahxxx")),
               "not a border style")
})

test_that("is_padding_or_margin", {
  good <- list(1, 0, 0L, 1L, 237, c(1,2,3,4), c(0,0,0,0), rep(1L, 4))
  bad <- list(numeric(), integer(), c(1,2), c(1L, 2L, 3L), 1:5,
              "1", c("1", "2", "3", "1"), NA, NA_real_, NA_integer_,
              c(1,2,NA,1), c(1L,NA,3L))

  for (g in good) {
    expect_true(is_padding_or_margin(g))
    expect_silent(assert_that(is_padding_or_margin(g)))
  }
  for (b in bad) {
    expect_false(is_padding_or_margin(b))
    expect_error(assert_that(is_padding_or_margin(b)),
                 "must be an integer of length one or four")
  }
})

test_that("is_col", {
  good <- list("red", "orange", NULL, crayon::red)
  bad <- list(c("red", "orange"), character(), NA_character_)

  for (g in good) {
    expect_true(is_col(g))
    expect_silent(assert_that(is_col(g)))
  }
  for (b in bad) {
    expect_false(is_col(b))
    expect_error(assert_that(is_col(b)),
                 "must be a color name, or a crayon style")
  }
})

test_that("is_count", {

  counts <- list(1, 1L, 0, 0L, 42, 42L)
  not_counts <- list(c(1, 2), numeric(), NA_integer_, NA_real_, NA, 1.1,
                     NULL, "1")

  for (c in counts) {
    expect_true(is_count(c))
    expect_silent(assert_that(is_count(c)))
  }

  for (n in not_counts) {
    expect_false(is_count(n))
    expect_error(assert_that(is_count(n)), "must be a count")
  }
})

test_that("is_tree_style", {
  good <- list(
    list(h = "1", v = "2", l = "3", j = "4"),
    list(j = "4", v = "2", h = "1", l = "3")
  )
  bad <- list(
    NULL,
    1:4,
    c(h = "1", v = "2", l = "3", j = "4"),
    list(h = "1", v = "2", l = "3", j = "4", x = "10"),
    list(h = "1", v = c("2", "3"), l = "3", j = "4"),
    list(h = "1", v = "2", l = character(), j = "4"),
    list(h = "1", v = "2", l = 3, j = "4"),
    list("1", v = "2", l = "3", j = "4"),
    list("1", "2", "3", "4")
  )

  for (x in good) expect_true (is_tree_style(x))
  for (x in bad ) expect_false(is_tree_style(x))
})
