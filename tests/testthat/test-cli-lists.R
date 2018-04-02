
context("cli lists")

test_that("ul", {
  clix$div(theme = list(ul = list("list-style-type" = "*")))
  lid <- clix$ul()
  out <- capt0({
    clix$it("foo")
    clix$it(c("bar", "foobar"))
  })
  expect_equal(out, "* foo\n* bar\n* foobar\n")
  clix$end(lid)
})

test_that("ol", {
  clix$div(theme = list(ol = list()))
  lid <- clix$ol()
  out <- capt0({
    clix$it("foo")
    clix$it(c("bar", "foobar"))
  })
  expect_equal(out, "1. foo\n2. bar\n3. foobar\n")
  clix$end(lid)
})

test_that("ul ul", {
  clix$div(theme = list(
    ul = list("list-style-type" = "*"),
    "ul ul" = list("list-style-type" = "-"),
    it = list("margin-left" = 2)
  ))
  lid <- clix$ul()
  out <- capt0({
    clix$it("1")
    lid2 <- clix$ul()
    clix$it("1 1")
    clix$it(c("1 2", "1 3"))
    clix$end(lid2)
    clix$it("2")
  })
  expect_equal(out, "* 1\n  - 1 1\n  - 1 2\n  - 1 3\n* 2\n")
  clix$end(lid)
})

test_that("ul ol", {
  clix$div(theme = list(
    ul = list("list-style-type" = "*"),
    it = list("margin-left" = 2)
  ))
  lid <- clix$ul()
  out <- capt0({
    clix$it("1")
    lid2 <- clix$ol()
    clix$it("1 1")
    clix$it(c("1 2", "1 3"))
    clix$end(lid2)
    clix$it("2")
  })
  expect_equal(out, "* 1\n  1. 1 1\n  2. 1 2\n  3. 1 3\n* 2\n")
  clix$end(lid)
})

test_that("ol ol", {
  clix$div(theme = list(
    it = list("margin-left" = 2)
  ))
  lid <- clix$ol()
  out <- capt0({
    clix$it("1")
    lid2 <- clix$ol()
    clix$it("1 1")
    clix$it(c("1 2", "1 3"))
    clix$end(lid2)
    clix$it("2")
  })
  expect_equal(out, "1. 1\n  1. 1 1\n  2. 1 2\n  3. 1 3\n2. 2\n")
  clix$end(lid)
})

test_that("ol ul", {
  clix$div(theme = list(
    ul = list("list-style-type" = "*"),
    it = list("margin-left" = 2)
  ))
  lid <- clix$ol()
  out <- capt0({
    clix$it("1")
    lid2 <- clix$ul()
    clix$it("1 1")
    clix$it(c("1 2", "1 3"))
    clix$end(lid2)
    clix$it("2")
  })
  expect_equal(out, "1. 1\n  * 1 1\n  * 1 2\n  * 1 3\n2. 2\n")
  clix$end(lid)
})

test_that("starting with an item", {
  clix$div(theme = list(ul = list("list-style-type" = "*")))
  out <- capt0({
    clix$it("foo")
    clix$it(c("bar", "foobar"))
  })
  expect_equal(out, "* foo\n* bar\n* foobar\n")
})

test_that("ol, with first item", {
  clix$div(theme = list(ol = list()))
  out <- capt0({
    lid <- clix$ol("foo")
    clix$it(c("bar", "foobar"))
  })
  expect_equal(out, "1. foo\n2. bar\n3. foobar\n")
  clix$end(lid)
})

test_that("ul, with first item", {
  clix$div(theme = list(ul = list("list-style-type" = "*")))
  out <- capt0({
    lid <- clix$ul("foo")
    clix$it(c("bar", "foobar"))
  })
  expect_equal(out, "* foo\n* bar\n* foobar\n")
  clix$end(lid)
})

test_that("dl", {
  clix$div(theme = list(ul = list()))
  lid <- clix$dl()
  out <- capt0({
    clix$it(c(this = "foo"))
    clix$it(c(that = "bar", other = "foobar"))
  })
  expect_equal(out, "this: foo\nthat: bar\nother: foobar\n")
  clix$end(lid)
})

test_that("dl dl", {
  clix$div(theme = list(
    it = list("margin-left" = 2)
  ))
  lid <- clix$dl()
  out <- capt0({
    clix$it(c(a = "1"))
    lid2 <- clix$dl()
    clix$it(c("a-a" = "1 1"))
    clix$it(c("a-b" = "1 2", "a-c" = "1 3"))
    clix$end(lid2)
    clix$it(c(b = "2"))
  })
  expect_equal(out, "a: 1\n  a-a: 1 1\n  a-b: 1 2\n  a-c: 1 3\nb: 2\n")
  clix$end(lid)
})

test_that("dl ol", {
  clix$div(theme = list(
    it = list("margin-left" = 2)
  ))
  lid <- clix$dl()
  out <- capt0({
    clix$it(c(a = "1"))
    lid2 <- clix$ol()
    clix$it(c("1 1"))
    clix$it(c("1 2", "1 3"))
    clix$end(lid2)
    clix$it(c(b = "2"))
  })
  expect_equal(out, "a: 1\n  1. 1 1\n  2. 1 2\n  3. 1 3\nb: 2\n")
  clix$end(lid)
})

test_that("dl ul", {
  clix$div(theme = list(
    ul = list("list-style-type" = "*"),
    it = list("margin-left" = 2)
  ))
  lid <- clix$dl()
  out <- capt0({
    clix$it(c(a = "1"))
    lid2 <- clix$ul()
    clix$it(c("1 1"))
    clix$it(c("1 2", "1 3"))
    clix$end(lid2)
    clix$it(c(b = "2"))
  })
  expect_equal(out, "a: 1\n  * 1 1\n  * 1 2\n  * 1 3\nb: 2\n")
  clix$end(lid)
})

test_that("ol dl", {
  clix$div(theme = list(
    it = list("margin-left" = 2)
  ))
  lid <- clix$ol()
  out <- capt0({
    clix$it("1")
    lid2 <- clix$dl()
    clix$it(c("a-a" = "1 1"))
    clix$it(c("a-b" = "1 2", "a-c" = "1 3"))
    clix$end(lid2)
    clix$it("2")
  })
  expect_equal(out, "1. 1\n  a-a: 1 1\n  a-b: 1 2\n  a-c: 1 3\n2. 2\n")
  clix$end(lid)
})

test_that("ul dl", {
  clix$div(theme = list(
    ul = list("list-style-type" = "*"),
    it = list("margin-left" = 2)
  ))
  lid <- clix$ul()
  out <- capt0({
    clix$it("1")
    lid2 <- clix$dl()
    clix$it(c("a-a" = "1 1"))
    clix$it(c("a-b" = "1 2", "a-c" = "1 3"))
    clix$end(lid2)
    clix$it("2")
  })
  expect_equal(out, "* 1\n  a-a: 1 1\n  a-b: 1 2\n  a-c: 1 3\n* 2\n")
  clix$end(lid)
})

test_that("dl, with first item", {
  clix$div(theme = list(ul = list()))
  out <- capt0({
    lid <- clix$dl(c(this = "foo"))
    clix$it(c(that = "bar", other = "foobar"))
  })
  expect_equal(out, "this: foo\nthat: bar\nother: foobar\n")
  clix$end(lid)
})
