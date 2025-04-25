test_that("diff_chr", {
  # Something simple first
  a <- as.character(c(1, 1, 1, 1, 1, 1, 1, 2, 3, 4, 4, 4, 4, 4, 4, 4, 5))
  b <- as.character(c(1, 1, 1, 1, 1, 1, 1, 2, 10, 4, 4, 4, 4, 4, 4, 4, 6, 7, 5))
  d <- diff_chr(a, b)
  expect_snapshot(d$lcs)
  d <- diff_chr(b, a)
  expect_snapshot(d$lcs)
})

test_that_cli(configs = c("plain", "ansi"), "diff_chr", {
  # Something simple first
  a <- as.character(c(1, 1, 1, 1, 1, 1, 1, 2, 3, 4, 4, 4, 4, 4, 4, 4, 5))
  b <- as.character(c(1, 1, 1, 1, 1, 1, 1, 2, 10, 4, 4, 4, 4, 4, 4, 4, 6, 7, 5))
  d <- diff_chr(a, b)
  expect_snapshot(d)
  expect_snapshot(d$lcs)
})

test_that("diff_chr edge cases", {
  expect_snapshot(diff_chr(character(), character()))
  expect_snapshot(diff_chr(character(), character())$lcs)
  expect_snapshot(diff_chr("a", character()))
  expect_snapshot(diff_chr(character(), "b"))
  expect_snapshot(diff_chr("a", "a"))
  expect_snapshot(diff_chr(letters, letters))
  expect_snapshot(diff_chr(c("a", NA, "a2"), "b"))
  expect_snapshot(diff_chr(NA_character_, "NA"))
})

test_that("format.cli_diff_chr context", {
  # Something simple first
  a <- as.character(c(1, 1, 1, 1, 1, 1, 1, 2, 3, 4, 4, 4, 4, 4, 4, 4, 5))
  b <- as.character(c(1, 1, 1, 1, 1, 1, 1, 2, 10, 4, 4, 4, 4, 4, 4, 4, 6, 7, 5))
  d <- diff_chr(a, b)
  expect_snapshot(print(d, context = 1))
  expect_snapshot(print(d, context = 0))
  expect_snapshot(print(d, context = Inf))
  d2 <- diff_chr(c("foo", "bar"), c("foo", "bar"))
  expect_snapshot(print(d2, context = Inf))
})

test_that_cli(configs = c("plain", "ansi"), "diff_str", {
  str1 <- "abcdefghijklmnopqrstuvwxyz"
  str2 <- "PREabcdefgMIDDLEnopqrstuvwxyzPOST"
  d <- diff_str(str1, str2)
  expect_snapshot(d)
})

test_that("warnings and errors", {
  expect_error(diff_chr(1:10, 1:10), "is.character")
  expect_error(
    format(diff_chr("foo", "bar"), context = -1),
    "is_count"
  )
  expect_warning(
    format(diff_chr("foo", "bar"), what = 1, is = 2, this = 3),
    "Extra arguments"
  )
  expect_warning(
    format(diff_str("foo", "bar"), what = 1, is = 2, this = 3),
    "Extra arguments"
  )
})

test_that("max_diff", {
  expect_snapshot_error(
    class = "cli_diff_max_dist",
    diff_chr("a", c("a", "b"), 0)
  )

  expect_silent(diff_chr(c("a", "c"), c("a", "b"), 2))

  expect_snapshot_error(
    class = "cli_diff_max_dist",
    diff_chr(c("a", "c"), c("a", "b"), 1)
  )
})
