
context("cli status bar")

setup(start_app())
teardown(stop_app())

test_that("create and clear", {
  f <- function() {
    cli_status("* This is the current status")
    cli_status_clear()
  }
  out <- crayon::strip_style(capt0(f()))
  expect_match(out, "* This is the current status", fixed = TRUE)
  out <- crayon::strip_style(capt0(f()))
  expect_match(out, "* This is the current status", fixed = TRUE)
})

test_that("output while status bar is active", {
  f <- function() {
    cli_text("out1")
    sb <- cli_status("status1")
    cli_text("out2")
    cli_status_update("status2", id = sb)
  }
  out <- crayon::strip_style(capt0(f()))
  expect_equal(out, paste0(
    "out1\n",
    "\r\rstatus1",
    "\r       \rout2\nstatus1",
    "\r       \rstatus2",
    "\r       \r"))
})

test_that("interpolation", {
  f <- function() {
    cli_div(theme = list("span.pkg" = list("before" = "{", after = "}")))
    cli_status("You see 1+1={1+1}, this is {pkg cli}")
    cli_status_clear()
  }
  out <- crayon::strip_style(capt0(f()))
  expect_equal(out, paste0(
    "\r\rYou see 1+1=2, this is {cli}",
    "\r                            \r"))
})

test_that("update", {
  f <- function() {
    cli_text("out1")
    sb <- cli_status("status1")
    cli_status_update("status2", id = sb)
  }
  out <- crayon::strip_style(capt0(f()))
  expect_equal(out, paste0(
    "out1\n",
    "\r\rstatus1",
    "\r       \rstatus2",
    "\r       \r"))
})

test_that("keep", {
  f <- function() {
    cli_status("* This is the current status", .keep = TRUE)
    cli_status_clear()
  }
  out <- crayon::strip_style(capt0(f()))
  expect_equal(out, "\r\r* This is the current status\n")
})

test_that("multiple status bars", {
  f <- function() {
    sb1 <- cli_status("status1")
    cli_text("text1")
    sb2 <- cli_status("status2")
    cli_text("text2")
    cli_status_clear(sb2)
    cli_text("text3")
  }
  out <- crayon::strip_style(capt0(f()))
  expect_equal(out, paste0(
    "\r\rstatus1",
    "\r       \rtext1\nstatus1",        # emit text1, restore status1
    "\r       \rstatus2",               # show status2
    "\r       \rtext2\nstatus2",        # emit text2, restore status2
    "\r       \rstatus1",               # clear status2, restore status1
    "\r       \rtext3\nstatus1",        # emit text3, restore status1
    "\r       \r"))                     # (auto)clear status1
})

test_that("truncating", {
  f <- function() {
    withr::local_options(list(cli.width = 40))
    txt <- "Eiusmod enim mollit aute aliquip Lorem sunt cupidatat."
    cli_status(c(txt, txt))
  }
  out <- crayon::strip_style(capt0(f()))
  expect_equal(out, paste0(
    "\r\rEiusmod enim mollit aute aliquip Lorem ",
    "\r                                       \r"))
})

test_that("ansi colors and clearing", {
  f <- function() {
    withr::local_options(list(crayon.enabled = TRUE, crayon.colors = 256))
    crayon::num_colors(forget = TRUE)
    cli_status(col_red("This is red"))
    cli_status_clear()
  }
  out <- capt0(f())
  expect_match(out, "\033[31m", fixed = TRUE)
  expect_match(out, "\r           \r", fixed = TRUE)
})
