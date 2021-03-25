
start_app()
on.exit(stop_app(), add = TRUE)

# We can't easily use snapshot tests here, because they don't capture \r

test_that("create and clear", {
  f <- function() {
    cli_status("* This is the current status")
    cli_status_clear()
  }
  out <- ansi_strip(capt0(f()))
  expect_match(out, "* This is the current status", fixed = TRUE)
  out <- ansi_strip(capt0(f()))
  expect_match(out, "* This is the current status", fixed = TRUE)
})

test_that("output while status bar is active", {
  withr::local_options(list(cli.ansi = FALSE, cli.dynamic = TRUE))
  f <- function() {
    cli_text("out1")
    sb <- cli_status("status1")
    cli_text("out2")
    cli_status_update("status2", id = sb)
  }
  out <- ansi_strip(capt0(f()))
  expect_equal(out, paste0(
    "out1\n",
    "\rstatus1",
    "\r       \rout2\nstatus1",
    "\rstatus2",
    "\r       \r"))
})

test_that("interpolation", {
  withr::local_options(list(cli.ansi = FALSE, cli.dynamic = TRUE))
  f <- function() {
    cli_div(theme = list("span.pkg" = list("before" = "{", after = "}")))
    cli_status("You see 1+1={1+1}, this is {.pkg cli}")
    cli_status_clear()
  }
  out <- ansi_strip(capt0(f()))
  expect_equal(out, paste0(
    "\rYou see 1+1=2, this is {cli}",
    "\r                            \r"))
})

test_that("update", {
  withr::local_options(list(cli.ansi = FALSE, cli.dynamic = TRUE))
  f <- function() {
    cli_text("out1")
    sb <- cli_status("status1")
    cli_status_update("status2", id = sb)
  }
  out <- ansi_strip(capt0(f()))
  expect_equal(out, paste0(
    "out1\n",
    "\rstatus1",
    "\rstatus2",
    "\r       \r"))
})

test_that("keep", {
  withr::local_options(list(cli.ansi = FALSE, cli.dynamic = TRUE))
  f <- function() {
    cli_status("* This is the current status", .keep = TRUE)
    cli_status_clear()
  }
  out <- ansi_strip(capt0(f()))
  expect_equal(out, "\r* This is the current status\n")
})

test_that("multiple status bars", {
  withr::local_options(list(cli.ansi = FALSE, cli.dynamic = TRUE))
  f <- function() {
    sb1 <- cli_status("status1")
    cli_text("text1")
    sb2 <- cli_status("status2")
    cli_text("text2")
    cli_status_clear(sb2)
    cli_text("text3")
  }
  out <- ansi_strip(capt0(f()))
  expect_equal(out, paste0(
    "\rstatus1",
    "\r       \rtext1\nstatus1",        # emit text1, restore status1
    "\rstatus2",                        # show status2
    "\r       \rtext2\nstatus2",        # emit text2, restore status2
    "\r       \rstatus1",               # clear status2, restore status1
    "\r       \rtext3\nstatus1",        # emit text3, restore status1
    "\r       \r"))                     # (auto)clear status1
})

test_that("truncating", {
  withr::local_options(list(
    cli.ansi = FALSE,
    cli.dynamic = TRUE,
    cli.unicode = FALSE
  ))
  f <- function() {
    withr::local_options(list(cli.width = 40))
    txt <- "Eiusmod enim mollit aute aliquip Lorem sunt cupidatat."
    cli_status(c(txt, txt))
  }
  out <- ansi_strip(capt0(f()))
  expect_equal(out, paste0(
    "\rEiusmod enim mollit aute aliquip Lore...",
    "\r                                        \r"))
})

test_that("ansi colors and clearing", {
  withr::local_options(list(
    cli.num_colors = 256L,
    cli.ansi = FALSE,
    cli.dynamic = TRUE
  ))
  f <- function() {
    withr::local_options(list(num_ansi_colors = 256L))
    cli_status(col_red("This is red"))
    cli_status_clear()
  }
  out <- capt0(f())
  expect_match(out, "\033[31m", fixed = TRUE)
  expect_match(out, "\r           \r", fixed = TRUE)
})

test_that("theming status bar", {
  f <- function() {
    cli_text("out1")
    sb <- cli_status("{.alert-info status1}")
    cli_text("out2")
    cli_status_update("status2", id = sb)
  }
  out <- ansi_strip(capt0(f()))
  out2 <- ansi_strip(capt0(cli_alert_info("status1")))
  expect_match(out, str_trim(out2), fixed = TRUE)
})

test_that("successful termination", {
  withr::local_options(list(cli.ansi = FALSE, cli.dynamic = TRUE))
  f <- function() {
    cli_text("out1")
    sb <- cli_status("status1")
    cli_text("out2")
    cli_status_clear(result = "done")
  }
  out <- ansi_strip(capt0(f()))
  expect_equal(out, paste0(
    "out1\n",
    "\rstatus1",
    "\r       \rout2\nstatus1",
    "\rstatus1 ... done\n"
  ))
})

test_that("terminate with failed", {
  withr::local_options(list(cli.ansi = FALSE, cli.dynamic = TRUE))
  f <- function() {
    cli_text("out1")
    sb <- cli_status("status1")
    cli_text("out2")
    cli_status_clear(result = "failed")
  }
  out <- ansi_strip(capt0(f()))
  expect_equal(out, paste0(
    "out1\n",
    "\rstatus1",
    "\r       \rout2\nstatus1",
    "\rstatus1 ... failed\n"
  ))
})

test_that("auto close with success", {
  withr::local_options(list(cli.ansi = FALSE, cli.dynamic = TRUE))
  f <- function() {
    cli_text("out1")
    sb <- cli_status("status1", .auto_result = "done")
    cli_text("out2")
  }
  out <- ansi_strip(capt0(f()))
  expect_equal(out, paste0(
    "out1\n",
    "\rstatus1",
    "\r       \rout2\nstatus1",
    "\rstatus1 ... done\n"
  ))
})

test_that("auto close wtih failure", {
  withr::local_options(list(cli.ansi = FALSE, cli.dynamic = TRUE))
  f <- function() {
    cli_text("out1")
    sb <- cli_status("status1", .auto_result = "failed")
    if (is_interactive()) Sys.sleep(2)
    cli_text("out2")
    if (is_interactive()) Sys.sleep(2)
  }
  out <- ansi_strip(capt0(f()))
  expect_equal(out, paste0(
    "out1\n",
    "\rstatus1",
    "\r       \rout2\nstatus1",
    "\rstatus1 ... failed\n"
  ))
})

test_that("auto close with styling", {
  f <- function() {
    cli_text("out1")
    sb <- cli_status(
      msg = "{.alert-info status1}",
      msg_done = "{.alert-success status1 ... done}",
      msg_failed = "{.alert-danger status1 ... failed}",
      .auto_result = "failed"
    )
    if (is_interactive()) Sys.sleep(1)
    cli_text("out2")
    if (is_interactive()) Sys.sleep(1)
  }
  out <- ansi_strip(capt0(f()))
  expect_match(out, "status1 ... failed\n")

  f2 <- function() {
    cli_text("out1")
    sb <- cli_status(
      msg = "{.alert-info status1}",
      msg_done = "{.alert-success status1 ... done}",
      msg_failed = "{.alert-danger status1 ... failed}",
      .auto_result = "done"
    )
    if (is_interactive()) Sys.sleep(1)
    cli_text("out2")
    if (is_interactive()) Sys.sleep(1)
  }
  out2 <- ansi_strip(capt0(f2()))
  expect_match(out2, "status1 ... done\n")
})

test_that("process auto close with success", {
  f <- function() {
    cli_text("out1")
    sb <- cli_process_start("status1", on_exit = "done")
    cli_text("out2")
  }
  out <- ansi_strip(capt0(f()))
  expect_match(out, "status1 ... done")
})

test_that("process auto close with failure", {
  f <- function() {
    cli_text("out1")
    sb <- cli_process_start("status1", on_exit = "failed")
    if (is_interactive()) Sys.sleep(2)
    cli_text("out2")
    if (is_interactive()) Sys.sleep(2)
  }
  out <- ansi_strip(capt0(f()))
  expect_match(out, "status1 ... failed")
})

test_that("Multiple spaces are no condensed in a status bar", {
  f <- function() {
    cli_status("* This  is the current  status")
    cli_status_clear()
  }
  out <- ansi_strip(capt0(f()))
  expect_match(out, "* This  is the current  status", fixed = TRUE)
  out <- ansi_strip(capt0(f()))
  expect_match(out, "* This  is the current  status", fixed = TRUE)
})

test_that("Emojis are cleaned up properly", {
  skip_on_os("windows")
  withr::local_options(list(cli.ansi = FALSE, cli.dynamic = TRUE))
  f <- function() {
    cli_text("out1")
    sb <- cli_status("\U0001F477")
    cli_text("out2")
    cli_status_update("\u2728", id = sb)
  }
  out <- ansi_strip(capt0(f()))
  exps <- c(
    paste0(
      "out1\n",
      "\r\U0001F477",
      "\r  \rout2\n\U0001F477",
      "\r\u2728",
      "\r  \r"),
    paste0(
      "out1\n",
      "\r<U+0001F477>",
      "\r  \rout2\n<U+0001F477>",
      "\r<U+2728>",
      "\r  \r")
  )
  expect_true(out %in% exps)
})
