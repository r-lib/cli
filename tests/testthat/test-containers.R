
start_app()
on.exit(stop_app(), add = TRUE)

test_that("auto closing", {
  expect_snapshot(local({
    cli_div(theme = list(".xx .emph" = list(before = "itsu:")))
    f <- function() {
      cli_par(class = "xx")
      cli_text("foo {.emph blah} bar")
    }

    # this has the marker
    f()
    # but this does not, because the .xx par was closed
    cli_text("foo {.emph blah} bar")
  }))
})

test_that("opt out of auto closing", {
  expect_snapshot(local({
    cli_div(theme = list(".xx .emph" = list(before = "itsu:")))
    id <- NULL
    f <- function() {
      id <<- cli_par(class = "xx", .auto_close = FALSE)
      cli_text("foo {.emph blah} bar")
    }

    f()

    # Still active
    cli_text("foo {.emph blah} bar")

    ## close explicitly
    expect_false(is.null(id))
    cli_end(id)
    cli_text("foo {.emph blah} bar")
  }))
})

test_that("auto closing with special env", {
  expect_snapshot(local({
    cli_div(theme = list(".xx .emph" = list(before = "itsu:")))
    f <- function() {
      g()
      # Still active
      cli_text("foo {.emph blah} bar")
    }

    g <- function() {
      cli_par(class = "xx", .auto_close = TRUE, .envir = parent.frame())
      cli_text("foo {.emph blah} bar")
    }

    f()

    # Not active any more
    cli_text("foo {.emph blah} bar")
  }))
})

test_that("div with special style", {
  expect_snapshot({
    f <- function() {
      cli_div(theme = list(".xx .emph" = list(before = "itsu:")))
      cli_par(class = "xx")
      cli_text("foo {.emph blah} bar")
    }
    f()
    # Not active any more
    cli_text("foo {.emph blah} bar")
  })
})

test_that("margin is squashed", {
  # expect_snapshot cuts off the trailing newline from the message it
  # seems, so instead of 4 empty lines, there will be only three
  expect_snapshot(local({
    cli_div(theme = list(par = list("margin-top" = 4, "margin-bottom" = 4)))
    cli_text("three lines")
    cli_par()
    cli_par()
    cli_par()
    cli_text("until here")
    cli_end()
    cli_end()
    cli_end()
    cli_par()
    cli_par()
    cli_par()
    cli_text("no space, still")
    cli_end()
    cli_end()
    cli_end()
    cli_text("three lines again")
  }))
})

test_that("before and after work properly", {
  expect_snapshot(local({
    cli_div(
      theme = list(
        "div.alert-success" = list(before ="!!!")
      ))
    cli_alert_success("{.pkg foobar} is good")
  }))
})
