
context("cli containers")

test_that("auto closing", {
  clix$div(theme = list(".xx .emph::before" = list(content = "itsu:")))
  f <- function() {
    capt(clix$par(class = "xx"))
    out <- capt(clix$text("foo {emph blah} bar"), print_it = FALSE)
    expect_match(out, "itsu:", fixed = TRUE)
  }

  capt(f())

  out <- capt(clix$text("foo {emph blah} bar"), print_it = FALSE)
  expect_false(grepl("itsu:", out, fixed = TRUE))
})

test_that("opt out of auto closing", {
  clix$div(theme = list(".xx .emph::before" = list(content = "itsu:")))
  id <- NULL
  f <- function() {
    capt(id <<- clix$par(class = "xx", .auto_close = FALSE))
    out <- capt(clix$text("foo {emph blah} bar"), print_it = FALSE)
    expect_match(out, "itsu:", fixed = TRUE)
  }

  capt(f())

  ## Still active
  out <- capt(clix$text("foo {emph blah} bar"), print_it = FALSE)
  expect_match(out, "itsu:", fixed = TRUE)

  ## close explicitly
  expect_false(is.null(id))
  capt(clix$end(id), print_it = FALSE)

  out <- capt(clix$text("foo {emph blah} bar"), print_it = FALSE)
  expect_false(grepl("itsu:", out, fixed = TRUE))
})

test_that("auto closing with special env", {
  clix$div(theme = list(".xx .emph::before" = list(content = "itsu:")))
  id <- NULL
  f <- function() {
    g()
    ## Still active
    out <- capt(clix$text("foo {emph blah} bar"), print_it = FALSE)
    expect_match(out, "itsu:", fixed = TRUE)
  }

  g <- function() {
    capt(id <<- clix$par(class = "xx", .auto_close = TRUE,
                        .envir = parent.frame()))
    out <- capt(clix$text("foo {emph blah} bar"), print_it = FALSE)
    expect_match(out, "itsu:", fixed = TRUE)
  }

  capt(f())

  ## Not active any more
  out <- capt(clix$text("foo {emph blah} bar"), print_it = FALSE)
  expect_false(grepl("itsu:", out, fixed = TRUE))
})

test_that("div with special style", {
  f <- function() {
    clix$div(theme = list(".xx .emph::before" = list(content = "itsu:")))
    capt(clix$par(class = "xx"))
    out <- capt(clix$text("foo {emph blah} bar"), print_it = FALSE)
    expect_match(out, "itsu:", fixed = TRUE)
  }

  capt(f())

  ## Not active any more
  out <- capt(clix$text("foo {emph blah} bar"), print_it = FALSE)
  expect_false(grepl("itsu:", out, fixed = TRUE))
})

test_that("margin is squashed", {
  clix$reset()
  clix$div(theme = list(par = list("margin-top" = 3, "margin-bottom" = 3)))
  out <- capt({ clix$par(); clix$par(); clix$par() }, print_it = FALSE)
  expect_equal(out, "\n\n")
  out <- capt({ clix$end(); clix$end(); clix$end() }, print_it = FALSE)
  expect_equal(out, "")

  out <- capt({ clix$par(); clix$par(); clix$par() }, print_it = FALSE)
  expect_equal(out, "")
  capt(clix$text(lorem_ipsum()))
  out <- capt({ clix$end(); clix$end(); clix$end() }, print_it = FALSE)
  expect_equal(out, "\n\n")
})

test_that("code is not implemented yet", {
  expect_error(clix$code(letters), "not implemented")
})

test_that("before and after work properly", {
  clix$div(theme = list(
    "div.alert-success::before" = list(content ="!!!")
  ))
  out <- capt(clix$alert_success("{pkg foobar} is good"), print_it = FALSE)
  expect_match(out, "!!!", fixed = TRUE)
})
