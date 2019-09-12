
context("cli lists")

setup(start_app())
teardown(stop_app())

test_that("ul", {
  cli_div(theme = list(ul = list("list-style-type" = "*")))
  lid <- cli_ul()
  out <- capt0({
    cli_li("foo")
    cli_li(c("bar", "foobar"))
  }, strip_style = TRUE)
  expect_equal(out, "* foo\n* bar\n* foobar\n")
  cli_end(lid)
})

test_that("ol", {
  cli_div(theme = list(ol = list()))
  lid <- cli_ol()
  out <- capt0({
    cli_li("foo")
    cli_li(c("bar", "foobar"))
  }, strip_style = TRUE)
  expect_equal(out, "1. foo\n2. bar\n3. foobar\n")
  cli_end(lid)
})

test_that("ul ul", {
  cli_div(theme = list(
    ul = list("list-style-type" = "*"),
    "ul ul" = list("list-style-type" = "-", "margin-left" = 2)
  ))
  lid <- cli_ul()
  out <- capt0({
    cli_li("1")
    lid2 <- cli_ul()
    cli_li("1 1")
    cli_li(c("1 2", "1 3"))
    cli_end(lid2)
    cli_li("2")
  }, strip_style = TRUE)
  expect_equal(out, "* 1\n  - 1 1\n  - 1 2\n  - 1 3\n* 2\n")
  cli_end(lid)
})

test_that("ul ol", {
  cli_div(theme = list(
    ul = list("list-style-type" = "*"),
    li = list("margin-left" = 2)
  ))
  lid <- cli_ul()
  out <- capt0({
    cli_li("1")
    lid2 <- cli_ol()
    cli_li("1 1")
    cli_li(c("1 2", "1 3"))
    cli_end(lid2)
    cli_li("2")
  }, strip_style = TRUE)
  expect_equal(out, "  * 1\n  1. 1 1\n  2. 1 2\n  3. 1 3\n  * 2\n")
  cli_end(lid)
})

test_that("ol ol", {
  cli_div(theme = list(
    "li" = list("margin-left" = 2),
    "li li" = list("margin-left" = 2)
  ))
  lid <- cli_ol()
  out <- capt0({
    cli_li("1")
    lid2 <- cli_ol()
    cli_li("1 1")
    cli_li(c("1 2", "1 3"))
    cli_end(lid2)
    cli_li("2")
  }, strip_style = TRUE)
  expect_equal(out, "  1. 1\n    1. 1 1\n    2. 1 2\n    3. 1 3\n  2. 2\n")
  cli_end(lid)
})

test_that("ol ul", {
  cli_div(theme = list(
    ul = list("list-style-type" = "*", "margin-left" = 2)
  ))
  lid <- cli_ol()
  out <- capt0({
    cli_li("1")
    lid2 <- cli_ul()
    cli_li("1 1")
    cli_li(c("1 2", "1 3"))
    cli_end(lid2)
    cli_li("2")
  }, strip_style = TRUE)
  expect_equal(out, "1. 1\n  * 1 1\n  * 1 2\n  * 1 3\n2. 2\n")
  cli_end(lid)
})

test_that("starting with an item", {
  cli_div(theme = list(ul = list("list-style-type" = "*")))
  out <- capt0({
    cli_li("foo")
    cli_li(c("bar", "foobar"))
  }, strip_style = TRUE)
  expect_equal(out, "* foo\n* bar\n* foobar\n")
})

test_that("ol, with first item", {
  cli_div(theme = list(ol = list()))
  out <- capt0({
    lid <- cli_ol("foo", .close = FALSE)
    cli_li(c("bar", "foobar"))
  }, strip_style = TRUE)
  expect_equal(out, "1. foo\n2. bar\n3. foobar\n")
  cli_end(lid)
})

test_that("ul, with first item", {
  cli_div(theme = list(ul = list("list-style-type" = "*")))
  out <- capt0({
    lid <- cli_ul("foo", .close = FALSE)
    cli_li(c("bar", "foobar"))
  }, strip_style = TRUE)
  expect_equal(out, "* foo\n* bar\n* foobar\n")
  cli_end(lid)
})

test_that("dl", {
  cli_div(theme = list(ul = list()))
  lid <- cli_dl()
  out <- capt0({
    cli_li(c(this = "foo"))
    cli_li(c(that = "bar", other = "foobar"))
  }, strip_style = TRUE)
  expect_equal(out, "this: foo\nthat: bar\nother: foobar\n")
  cli_end(lid)
})

test_that("dl dl", {
  cli_div(theme = list(
    li = list("margin-left" = 2)
  ))
  lid <- cli_dl()
  out <- capt0({
    cli_li(c(a = "1"))
    lid2 <- cli_dl()
    cli_li(c("a-a" = "1 1"))
    cli_li(c("a-b" = "1 2", "a-c" = "1 3"))
    cli_end(lid2)
    cli_li(c(b = "2"))
  }, strip_style = TRUE)
  expect_equal(out, "  a: 1\n  a-a: 1 1\n  a-b: 1 2\n  a-c: 1 3\n  b: 2\n")
  cli_end(lid)
})

test_that("dl ol", {
  cli_div(theme = list(
    li = list("margin-left" = 2)
  ))
  lid <- cli_dl()
  out <- capt0({
    cli_li(c(a = "1"))
    lid2 <- cli_ol()
    cli_li(c("1 1"))
    cli_li(c("1 2", "1 3"))
    cli_end(lid2)
    cli_li(c(b = "2"))
  }, strip_style = TRUE)
  expect_equal(out, "  a: 1\n  1. 1 1\n  2. 1 2\n  3. 1 3\n  b: 2\n")
  cli_end(lid)
})

test_that("dl ul", {
  cli_div(theme = list(
    ul = list("list-style-type" = "*"),
    li = list("margin-left" = 2)
  ))
  lid <- cli_dl()
  out <- capt0({
    cli_li(c(a = "1"))
    lid2 <- cli_ul()
    cli_li(c("1 1"))
    cli_li(c("1 2", "1 3"))
    cli_end(lid2)
    cli_li(c(b = "2"))
  }, strip_style = TRUE)
  expect_equal(out, "  a: 1\n  * 1 1\n  * 1 2\n  * 1 3\n  b: 2\n")
  cli_end(lid)
})

test_that("ol dl", {
  cli_div(theme = list(
    li = list("margin-left" = 2)
  ))
  lid <- cli_ol()
  out <- capt0({
    cli_li("1")
    lid2 <- cli_dl()
    cli_li(c("a-a" = "1 1"))
    cli_li(c("a-b" = "1 2", "a-c" = "1 3"))
    cli_end(lid2)
    cli_li("2")
  }, strip_style = TRUE)
  expect_equal(out, "  1. 1\n  a-a: 1 1\n  a-b: 1 2\n  a-c: 1 3\n  2. 2\n")
  cli_end(lid)
})

test_that("ul dl", {
  cli_div(theme = list(
    ul = list("list-style-type" = "*"),
    li = list("margin-left" = 2)
  ))
  lid <- cli_ul()
  out <- capt0({
    cli_li("1")
    lid2 <- cli_dl()
    cli_li(c("a-a" = "1 1"))
    cli_li(c("a-b" = "1 2", "a-c" = "1 3"))
    cli_end(lid2)
    cli_li("2")
  }, strip_style = TRUE)
  expect_equal(out, "  * 1\n  a-a: 1 1\n  a-b: 1 2\n  a-c: 1 3\n  * 2\n")
  cli_end(lid)
})

test_that("dl, with first item", {
  cli_div(theme = list(ul = list()))
  out <- capt0({
    lid <- cli_dl(c(this = "foo"), .close = FALSE)
    cli_li(c(that = "bar", other = "foobar"))
  }, strip_style = TRUE)
  expect_equal(out, "this: foo\nthat: bar\nother: foobar\n")
  cli_end(lid)
})
