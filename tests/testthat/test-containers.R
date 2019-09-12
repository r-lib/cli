
context("cli containers")

setup(start_app())
teardown(stop_app())

test_that("auto closing", {
  cli_div(theme = list(".xx .emph" = list(before = "itsu:")))
  id <- ""
  out <- ""
  f <- function() {
    capt0(id <<- cli_par(class = "xx"))
    out <<- capt0(cli_text("foo {.emph blah} bar"))
  }

  capt0(f())
  expect_match(out, "itsu:", fixed = TRUE)

  out <- capt0(cli_text("foo {.emph blah} bar"))
  expect_false(grepl("itsu:", out, fixed = TRUE))
})

test_that("opt out of auto closing", {
  cli_div(theme = list(".xx .emph" = list(before = "itsu:")))
  id <- NULL
  f <- function() {
    capt0(id <<- cli_par(class = "xx", .auto_close = FALSE))
    out <- capt0(cli_text("foo {.emph blah} bar"))
    expect_match(out, "itsu:", fixed = TRUE)
  }

  capt0(f())

  ## Still active
  out <- capt0(cli_text("foo {.emph blah} bar"))
  expect_match(out, "itsu:", fixed = TRUE)

  ## close explicitly
  expect_false(is.null(id))
  capt0(cli_end(id))

  out <- capt0(cli_text("foo {.emph blah} bar"))
  expect_false(grepl("itsu:", out, fixed = TRUE))
})

test_that("auto closing with special env", {
  cli_div(theme = list(".xx .emph" = list(before = "itsu:")))
  id <- NULL
  f <- function() {
    g()
    ## Still active
    out <- capt0(cli_text("foo {.emph blah} bar"))
    expect_match(out, "itsu:", fixed = TRUE)
  }

  g <- function() {
    capt0(id <<- cli_par(class = "xx", .auto_close = TRUE,
                        .envir = parent.frame()))
    out <- capt0(cli_text("foo {.emph blah} bar"))
    expect_match(out, "itsu:", fixed = TRUE)
  }

  capt0(f())

  ## Not active any more
  out <- capt0(cli_text("foo {.emph blah} bar"))
  expect_false(grepl("itsu:", out, fixed = TRUE))
})

test_that("div with special style", {
  f <- function() {
    cli_div(theme = list(".xx .emph" = list(before = "itsu:")))
    capt0(cli_par(class = "xx"))
    out <- capt0(cli_text("foo {.emph blah} bar"))
    expect_match(out, "itsu:", fixed = TRUE)
  }

  capt0(f())

  ## Not active any more
  out <- capt0(cli_text("foo {.emph blah} bar"))
  expect_false(grepl("itsu:", out, fixed = TRUE))
})

test_that("margin is squashed", {
  cli_div(theme = list(par = list("margin-top" = 3, "margin-bottom" = 3)))
  out <- capt0({ cli_par(); cli_par(); cli_par() }, strip_style = TRUE)
  expect_equal(out, "\n\n\n")
  out <- capt0({ cli_end(); cli_end(); cli_end() })
  expect_equal(out, "")

  out <- capt0({ cli_par(); cli_par(); cli_par() })
  expect_equal(out, "")
  capt0(cli_text(lorem_ipsum()))
  out <- capt0({ cli_end(); cli_end(); cli_end() }, strip_style = TRUE)
  expect_equal(out, "\n\n\n")
})

test_that("before and after work properly", {
  cli_div(theme = list(
    "div.alert-success" = list(before ="!!!")
  ))
  out <- capt0(cli_alert_success("{.pkg foobar} is good"))
  expect_match(out, "!!!", fixed = TRUE)
})
