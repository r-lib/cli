
context("cli containers")

test_that("auto closing", {
  clix$div(theme = list(".xx .emph::before" = list(content = "itsu:")))
  f <- function() {
    capt0(clix$par(class = "xx"))
    out <- capt0(clix$text("foo {emph blah} bar"))
    expect_match(out, "itsu:", fixed = TRUE)
  }

  capt0(f())

  out <- capt0(clix$text("foo {emph blah} bar"))
  expect_false(grepl("itsu:", out, fixed = TRUE))
})

test_that("opt out of auto closing", {
  clix$div(theme = list(".xx .emph::before" = list(content = "itsu:")))
  id <- NULL
  f <- function() {
    capt0(id <<- clix$par(class = "xx", .auto_close = FALSE))
    out <- capt0(clix$text("foo {emph blah} bar"))
    expect_match(out, "itsu:", fixed = TRUE)
  }

  capt0(f())

  ## Still active
  out <- capt0(clix$text("foo {emph blah} bar"))
  expect_match(out, "itsu:", fixed = TRUE)

  ## close explicitly
  expect_false(is.null(id))
  capt0(clix$end(id))

  out <- capt0(clix$text("foo {emph blah} bar"))
  expect_false(grepl("itsu:", out, fixed = TRUE))
})

test_that("auto closing with special env", {
  clix$div(theme = list(".xx .emph::before" = list(content = "itsu:")))
  id <- NULL
  f <- function() {
    g()
    ## Still active
    out <- capt0(clix$text("foo {emph blah} bar"))
    expect_match(out, "itsu:", fixed = TRUE)
  }

  g <- function() {
    capt0(id <<- clix$par(class = "xx", .auto_close = TRUE,
                        .envir = parent.frame()))
    out <- capt0(clix$text("foo {emph blah} bar"))
    expect_match(out, "itsu:", fixed = TRUE)
  }

  capt0(f())

  ## Not active any more
  out <- capt0(clix$text("foo {emph blah} bar"))
  expect_false(grepl("itsu:", out, fixed = TRUE))
})

test_that("div with special style", {
  f <- function() {
    clix$div(theme = list(".xx .emph::before" = list(content = "itsu:")))
    capt0(clix$par(class = "xx"))
    out <- capt0(clix$text("foo {emph blah} bar"))
    expect_match(out, "itsu:", fixed = TRUE)
  }

  capt0(f())

  ## Not active any more
  out <- capt0(clix$text("foo {emph blah} bar"))
  expect_false(grepl("itsu:", out, fixed = TRUE))
})

test_that("margin is squashed", {
  clix$reset()
  clix$div(theme = list(par = list("margin-top" = 3, "margin-bottom" = 3)))
  out <- capt0({ clix$par(); clix$par(); clix$par() })
  expect_equal(out, "\n\n\n")
  out <- capt0({ clix$end(); clix$end(); clix$end() })
  expect_equal(out, "")

  out <- capt0({ clix$par(); clix$par(); clix$par() })
  expect_equal(out, "")
  capt0(clix$text(lorem_ipsum()))
  out <- capt0({ clix$end(); clix$end(); clix$end() })
  expect_equal(out, "\n\n\n")
})

test_that("code is not implemented yet", {
  expect_error(clix$code(letters), "not implemented")
})

test_that("before and after work properly", {
  clix$div(theme = list(
    "div.alert-success::before" = list(content ="!!!")
  ))
  out <- capt0(clix$alert_success("{pkg foobar} is good"))
  expect_match(out, "!!!", fixed = TRUE)
})
