
test_that("hash_sha256", {
  dig <- function(x) {
    digest::digest(x, serialize = FALSE, algo = "sha256")
  }

  cases <- list(
    list(character(), character()),
    list("", dig("")),
    list("x", dig("x")),
    list(NA_character_, NA_character_),
    list(NA, NA_character_),
    list(
      c(NA, "", "foo", NA),
      c(NA, dig(""), dig("foo"), NA)
    )
  )

  for (case in cases) {
    expect_equal(hash_sha256(case[[1]]), case[[2]])
  }
})

test_that("hash_raw_sha256", {
  dig <- function(x) {
    digest::digest(x, serialize = FALSE, algo = "sha256")
  }

  cases <- list(
    list(raw(), dig(raw())),
    list(as.raw(0), dig(as.raw(0))),
    list(charToRaw("foobar"), dig("foobar"))
  )

  for (case in cases) {
    expect_equal(hash_raw_sha256(case[[1]]), case[[2]])
  }
})

test_that("hash_obj_sha256", {
  dig <- function(x) {
    digest::digest(x, serializeVersion = 2, algo = "sha256")
  }

  cases <- list(
    "",
    raw(0),
    1:10,
    mtcars
  )

  for (case in cases) {
    expect_equal(hash_obj_sha256(case), dig(case))
  }
})

test_that("hash_file_sha256", {
  dig <- function(x) {
    digest::digest(file = x, algo = "sha256")
  }

  f <- test_path("test-hash.R")
  expect_equal(
    hash_file_sha256(character()),
    character()
  )

  expect_equal(hash_file_sha256(f), dig(f))
})

test_that("hash_md5", {
  dig <- function(x) {
    digest::digest(x, serialize = FALSE, algo = "md5")
  }

  cases <- list(
    list(character(), character()),
    list("", dig("")),
    list("x", dig("x")),
    list(NA_character_, NA_character_),
    list(NA, NA_character_),
    list(
      c(NA, "", "foo", NA),
      c(NA, dig(""), dig("foo"), NA)
    )
  )

  for (case in cases) {
    expect_equal(hash_md5(case[[1]]), case[[2]])
  }
})

test_that("hash_raw_md5", {
  dig <- function(x) {
    digest::digest(x, serialize = FALSE, algo = "md5")
  }

  cases <- list(
    list(raw(), dig(raw())),
    list(as.raw(0), dig(as.raw(0))),
    list(charToRaw("foobar"), dig("foobar"))
  )

  for (case in cases) {
    expect_equal(hash_raw_md5(case[[1]]), case[[2]])
  }
})

test_that("hash_obj_md5", {
  dig <- function(x) {
    digest::digest(x, serializeVersion = 2, algo = "md5")
  }

  cases <- list(
    "",
    raw(0),
    1:10,
    mtcars
  )

  for (case in cases) {
    expect_equal(hash_obj_md5(case), dig(case))
  }
})

test_that("hash_emoji", {
  expect_snapshot({
    hash_emoji(character())$names
    hash_emoji("")$names
    hash_emoji("x")$names
    hash_emoji(NA_character_)$names
    hash_emoji(NA)$names
    hash_emoji(c(NA, "", "foo", NA))$names
  })
})

test_that("hash_raw_emoji", {
  expect_snapshot({
    hash_raw_emoji(raw())$names
    hash_raw_emoji(as.raw(0))$names
    hash_raw_emoji(charToRaw("foobar"))$names
  })
})

test_that("hash_obj_emoji", {
  expect_snapshot({
    hash_obj_emoji("")$names
    hash_obj_emoji(raw(0))$names
    hash_obj_emoji(1:10)$names
    hash_obj_emoji(mtcars)$names
  })
})

test_that("hash_animal", {
  expect_snapshot({
    hash_animal(character())$words
    hash_animal("")$words
    hash_animal("x")$words
    hash_animal(NA_character_)$words
    hash_animal(NA)$words
    hash_animal(c(NA, "", "foo", NA))$words
  })
})

test_that("hash_raw_animal", {
  expect_snapshot({
    hash_raw_animal(raw())$words
    hash_raw_animal(as.raw(0))$words
    hash_raw_animal(charToRaw("foobar"))$words
  })
})

test_that("hash_obj_animal", {
  expect_snapshot({
    hash_obj_animal("")$words
    hash_obj_animal(raw(0))$words
    hash_obj_animal(1:10)$words
    hash_obj_animal(mtcars)$words
  })
})
