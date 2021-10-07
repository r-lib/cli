
test_that("ediff_chr", {
  # Something simple first
  a <- as.character(c(1,1,1,1,1,1,1,2,3,4,4,4,4,4,4,4,5))
  b <- as.character(c(1,1,1,1,1,1,1,2,10,4,4,4,4,4,4,4,6,7,5))
  d <- ediff_chr(a, b)
  expect_snapshot(d$lcs)
  d <- ediff_chr(b, a)
  expect_snapshot(d$lcs)
})

test_that_cli(configs = c("plain", "ansi"), "ediff_chr", {
  # Something simple first
  a <- as.character(c(1,1,1,1,1,1,1,2,3,4,4,4,4,4,4,4,5))
  b <- as.character(c(1,1,1,1,1,1,1,2,10,4,4,4,4,4,4,4,6,7,5))
  d <- ediff_chr(a, b)
  expect_snapshot(d)
  expect_snapshot(d$lcs)
})

test_that("ediff_chr edge cases", {
  expect_snapshot(ediff_chr(character(), character()))
  expect_snapshot(ediff_chr(character(), character())$lcs)
  expect_snapshot(ediff_chr("a", character()))
  expect_snapshot(ediff_chr(character(), "b"))
  expect_snapshot(ediff_chr("a", "a"))
  expect_snapshot(ediff_chr(letters, letters))
  expect_snapshot(ediff_chr(c("a", NA, "a2"), "b"))
  expect_snapshot(ediff_chr(NA_character_, "NA"))
})

test_that("format.cli_diff_chr context", {
  # Something simple first
  a <- as.character(c(1,1,1,1,1,1,1,2,3,4,4,4,4,4,4,4,5))
  b <- as.character(c(1,1,1,1,1,1,1,2,10,4,4,4,4,4,4,4,6,7,5))
  d <- ediff_chr(a, b)
  expect_snapshot(print(d, context = 1))
  expect_snapshot(print(d, context = 0))
  expect_snapshot(print(d, context = Inf))
  d2 <- ediff_chr(c("foo", "bar"), c("foo", "bar"))
  expect_snapshot(print(d2, context = Inf))
})

test_that_cli(config = c("plain", "ansi"), "ediff_str", {
  str1 <- "abcdefghijklmnopqrstuvwxyz"
  str2 <- "PREabcdefgMIDDLEnopqrstuvwxyzPOST"
  d <- ediff_str(str1, str2)
  expect_snapshot(d)
})

test_that("warnings and errors", {
  expect_error(ediff_chr(1:10, 1:10), "is.character")
  expect_error(
    format(ediff_chr("foo", "bar"), context = -1),
    "is_count"
  )
  expect_warning(
    format(ediff_chr("foo", "bar"), what = 1, is = 2, this = 3),
    "Extra arguments"
  )
  expect_warning(
    format(ediff_str("foo", "bar"), what = 1, is = 2, this = 3),
    "Extra arguments"
  )
})
