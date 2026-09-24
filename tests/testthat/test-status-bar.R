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
  expect_equal(
    out,
    paste0(
      "out1\n",
      "\rstatus1\r",
      "\r       \rout2\nstatus1\r",
      "\rstatus2\r",
      "\r       \r"
    )
  )
})

test_that("interpolation", {
  withr::local_options(list(cli.ansi = FALSE, cli.dynamic = TRUE))
  f <- function() {
    cli_div(theme = list("span.pkg" = list("before" = "{", after = "}")))
    cli_status("You see 1+1={1+1}, this is {.pkg cli}")
    cli_status_clear()
  }
  out <- ansi_strip(capt0(f()))
  expect_equal(
    out,
    paste0(
      "\rYou see 1+1=2, this is {cli}\r",
      "\r                            \r"
    )
  )
})

test_that("update", {
  withr::local_options(list(cli.ansi = FALSE, cli.dynamic = TRUE))
  f <- function() {
    cli_text("out1")
    sb <- cli_status("status1")
    cli_status_update("status2", id = sb)
  }
  out <- ansi_strip(capt0(f()))
  expect_equal(
    out,
    paste0(
      "out1\n",
      "\rstatus1\r",
      "\rstatus2\r",
      "\r       \r"
    )
  )
})

test_that("keep", {
  withr::local_options(list(cli.ansi = FALSE, cli.dynamic = TRUE))
  f <- function() {
    cli_status("* This is the current status", .keep = TRUE)
    cli_status_clear()
  }
  out <- ansi_strip(capt0(f()))
  expect_equal(out, "\r* This is the current status\r\n")
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
  expect_equal(
    out,
    paste0(
      "\rstatus1\r",
      "\r       \rtext1\nstatus1\r", # emit text1, restore status1
      "\rstatus2\r", # show status2
      "\r       \rtext2\nstatus2\r", # emit text2, restore status2
      "\r       \rstatus1\r", # clear status2, restore status1
      "\r       \rtext3\nstatus1\r", # emit text3, restore status1
      "\r       \r"
    )
  ) # (auto)clear status1
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
  expect_equal(
    out,
    paste0(
      "\rEiusmod enim mollit aute aliquip Lore...\r",
      "\r                                        \r"
    )
  )
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
  expect_equal(
    out,
    paste0(
      "out1\n",
      "\rstatus1\r",
      "\r       \rout2\nstatus1\r",
      "\rstatus1 ... done\r\n"
    )
  )
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
  expect_equal(
    out,
    paste0(
      "out1\n",
      "\rstatus1\r",
      "\r       \rout2\nstatus1\r",
      "\rstatus1 ... failed\r\n"
    )
  )
})

test_that("auto close with success", {
  withr::local_options(list(cli.ansi = FALSE, cli.dynamic = TRUE))
  f <- function() {
    cli_text("out1")
    sb <- cli_status("status1", .auto_result = "done")
    cli_text("out2")
  }
  out <- ansi_strip(capt0(f()))
  expect_equal(
    out,
    paste0(
      "out1\n",
      "\rstatus1\r",
      "\r       \rout2\nstatus1\r",
      "\rstatus1 ... done\r\n"
    )
  )
})

test_that("auto close wtih failure", {
  withr::local_options(list(cli.ansi = FALSE, cli.dynamic = TRUE))
  f <- function() {
    cli_text("out1")
    sb <- cli_status("status1", .auto_result = "failed")
    if (is_interactive()) {
      Sys.sleep(2)
    }
    cli_text("out2")
    if (is_interactive()) Sys.sleep(2)
  }
  out <- ansi_strip(capt0(f()))
  expect_equal(
    out,
    paste0(
      "out1\n",
      "\rstatus1\r",
      "\r       \rout2\nstatus1\r",
      "\rstatus1 ... failed\r\n"
    )
  )
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
    if (is_interactive()) {
      Sys.sleep(1)
    }
    cli_text("out2")
    if (is_interactive()) Sys.sleep(1)
  }
  out <- ansi_strip(capt0(f()))
  expect_match(out, "status1 ... failed", fixed = TRUE)

  f2 <- function() {
    cli_text("out1")
    sb <- cli_status(
      msg = "{.alert-info status1}",
      msg_done = "{.alert-success status1 ... done}",
      msg_failed = "{.alert-danger status1 ... failed}",
      .auto_result = "done"
    )
    if (is_interactive()) {
      Sys.sleep(1)
    }
    cli_text("out2")
    if (is_interactive()) Sys.sleep(1)
  }
  out2 <- ansi_strip(capt0(f2()))
  expect_match(out2, "status1 ... done", fixed = TRUE)
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
    if (is_interactive()) {
      Sys.sleep(2)
    }
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
      "\r\U0001F477\r",
      "\r  \rout2\n\U0001F477\r",
      "\r\u2728\r",
      "\r  \r"
    ),
    paste0(
      "out1\n",
      "\r<U+0001F477>\r",
      "\r  \rout2\n<U+0001F477>\r",
      "\r<U+2728>\r",
      "\r  \r"
    )
  )
  expect_true(out %in% exps)
})

test_that("auto-close with done or failure", {
  withr::local_options(list(
    cli.ansi = FALSE,
    cli.dynamic = TRUE,
    cli.unicode = FALSE
  ))
  f <- function() {
    cli_text("out1")
    sb <- cli_process_start("status1")
    cli_text("out2")
  }
  out <- ansi_strip(capt0(f()))
  expect_match(out, "status1 ... done")

  out <- ansi_strip(capt0(f()))
  expect_match(out, "status1 ... done")

  # This fails on older R versions, only if f2() is tryCatch()-ed.
  if (getRversion() < "3.5.0") {
    skip("Needs R 3.5.0")
  }

  f2 <- function() {
    cli_text("out1")
    sb <- cli_process_start("status1")
    cli_text("out2")
    stop("oops")
  }

  out2 <- ansi_strip(capt0(tryCatch(f2(), error = function(err) NULL)))
  expect_match(
    out2,
    fixed = TRUE,
    paste0(
      "out1\n",
      "\ri status1\r",
      "\r         \r",
      "out2\n",
      "i status1\r",
      "\rx status1 ... failed\r\n"
    )
  )
})

# ---- multi-line progress bars ----

test_that("concurrent progress bars on ANSI terminal", {
  skip_if_not_installed("testthat", "3.1.2")
  withr::local_options(
    cli.dynamic = TRUE,
    cli.ansi = TRUE,
    cli.progress_show_after = 0
  )

  fun <- function() {
    id1 <- cli_progress_bar(
      "bar1",
      total = 3,
      type = "custom",
      format = "bar1: {pb_current}",
      current = FALSE
    )
    id2 <- cli_progress_bar(
      "bar2",
      total = 3,
      type = "custom",
      format = "bar2: {pb_current}",
      current = FALSE
    )
    cli_progress_update(id = id1, force = TRUE)
    cli_progress_update(id = id2, force = TRUE)
    cli_progress_update(id = id1, force = TRUE)
    cli_progress_done(id = id1)
    cli_progress_done(id = id2)
  }

  msgs <- capture_cli_messages(fun())
  expect_snapshot(msgs)
})

test_that("bar completion while others remain (ANSI)", {
  skip_if_not_installed("testthat", "3.1.2")
  withr::local_options(
    cli.dynamic = TRUE,
    cli.ansi = TRUE,
    cli.progress_show_after = 0,
    cli.progress_clear = TRUE
  )

  fun <- function() {
    id1 <- cli_progress_bar(
      type = "custom",
      format = "first: {pb_current}",
      total = 2,
      current = FALSE,
      clear = TRUE
    )
    id2 <- cli_progress_bar(
      type = "custom",
      format = "second: {pb_current}",
      total = 2,
      current = FALSE,
      clear = TRUE
    )
    cli_progress_update(id = id1, force = TRUE)
    cli_progress_update(id = id2, force = TRUE)
    cli_progress_done(id = id1)
    cli_progress_update(id = id2, force = TRUE)
    cli_progress_done(id = id2)
  }

  msgs <- capture_cli_messages(fun())
  expect_snapshot(msgs)
})

test_that("interleaved cli output with multiple active bars (ANSI)", {
  skip_if_not_installed("testthat", "3.1.2")
  withr::local_options(
    cli.dynamic = TRUE,
    cli.ansi = TRUE,
    cli.progress_show_after = 0
  )

  fun <- function() {
    id1 <- cli_progress_bar(
      type = "custom",
      format = "dl: {pb_current}",
      total = 3,
      current = FALSE
    )
    id2 <- cli_progress_bar(
      type = "custom",
      format = "proc: {pb_current}",
      total = 3,
      current = FALSE
    )
    cli_progress_update(id = id1, force = TRUE)
    cli_progress_update(id = id2, force = TRUE)
    cli_alert_info("checkpoint")
    cli_progress_update(id = id1, force = TRUE)
    cli_progress_done(id = id1)
    cli_progress_done(id = id2)
  }

  msgs <- capture_cli_messages(fun())
  expect_snapshot(msgs)
})

test_that("non-ANSI dynamic fallback shows single bar", {
  withr::local_options(
    cli.dynamic = TRUE,
    cli.ansi = FALSE,
    cli.progress_show_after = 0
  )

  fun <- function() {
    id1 <- cli_progress_bar(
      type = "custom",
      format = "bar1: {pb_current}",
      total = 2,
      current = FALSE
    )
    id2 <- cli_progress_bar(
      type = "custom",
      format = "bar2: {pb_current}",
      total = 2,
      current = FALSE
    )
    cli_progress_update(id = id1, force = TRUE)
    cli_progress_update(id = id2, force = TRUE)
    cli_progress_done(id = id1)
    cli_progress_done(id = id2)
  }

  out <- ansi_strip(capt0(fun()))
  expect_match(out, "bar1: 1", fixed = TRUE)
  expect_match(out, "bar2: 1", fixed = TRUE)
})

test_that("non-dynamic output preserves newline-per-update", {
  withr::local_options(
    cli.dynamic = FALSE,
    cli.ansi = FALSE,
    cli.progress_show_after = 0
  )

  fun <- function() {
    id1 <- cli_progress_bar(
      type = "custom",
      format = "bar1: {pb_current}",
      total = 2,
      current = FALSE
    )
    cli_progress_update(id = id1, force = TRUE)
    cli_progress_done(id = id1)
  }

  out <- ansi_strip(capt0(fun()))
  expect_match(out, "bar1: 1\n", fixed = TRUE)
})

test_that("cli_status multiple bars regression", {
  withr::local_options(cli.ansi = FALSE, cli.dynamic = TRUE)

  f <- function() {
    sb1 <- cli_status("status1")
    cli_text("text1")
    sb2 <- cli_status("status2")
    cli_text("text2")
    cli_status_clear(sb2)
    cli_text("text3")
  }
  out <- ansi_strip(capt0(f()))
  expect_equal(
    out,
    paste0(
      "\rstatus1\r",
      "\r       \rtext1\nstatus1\r",
      "\rstatus2\r",
      "\r       \rtext2\nstatus2\r",
      "\r       \rstatus1\r",
      "\r       \rtext3\nstatus1\r",
      "\r       \r"
    )
  )
})

test_that("cli_process_start/done regression", {
  withr::local_options(cli.ansi = FALSE, cli.dynamic = TRUE)

  f <- function() {
    cli_process_start("working")
    cli_process_done()
  }
  out <- ansi_strip(capt0(f()))
  expect_match(out, "working", fixed = TRUE)
  expect_match(out, "done", fixed = TRUE)
})

test_that("auto-close with .keep regression", {
  withr::local_options(cli.ansi = FALSE, cli.dynamic = TRUE)

  f <- function() {
    cli_status("kept status", .keep = TRUE)
    cli_status_clear()
  }
  out <- ansi_strip(capt0(f()))
  expect_equal(out, "\rkept status\r\n")
})

test_that("clearing non-current bar preserves current id", {
  withr::local_options(cli.ansi = FALSE, cli.dynamic = TRUE)

  f <- function() {
    sb1 <- cli_status("first")
    sb2 <- cli_status("second")
    sb3 <- cli_status("third")
    cli_status_clear(sb2, result = "done")
    cli_status_update(msg = "third-updated")
  }
  out <- ansi_strip(capt0(f()))
  expect_match(out, "third-updated", fixed = TRUE)
  expect_match(out, "second ... done", fixed = TRUE)
})

test_that("multi-bar keep/done on ANSI", {
  skip_if_not_installed("testthat", "3.1.2")
  withr::local_options(
    cli.dynamic = TRUE,
    cli.ansi = TRUE,
    cli.progress_show_after = 0
  )

  fun <- function() {
    id1 <- cli_progress_bar(
      type = "custom",
      format = "a: {pb_current}",
      total = 2,
      current = FALSE,
      clear = FALSE
    )
    id2 <- cli_progress_bar(
      type = "custom",
      format = "b: {pb_current}",
      total = 2,
      current = FALSE,
      clear = FALSE
    )
    cli_progress_update(id = id1, force = TRUE)
    cli_progress_update(id = id2, force = TRUE)
    cli_progress_update(id = id1, set = 2, force = TRUE)
    cli_progress_update(id = id2, set = 2, force = TRUE)
  }

  msgs <- capture_cli_messages(fun())
  expect_snapshot(msgs)
})

test_that("cli.progress_multiline = FALSE forces single-line ANSI render", {
  skip_if_not_installed("testthat", "3.1.2")
  withr::local_options(
    cli.dynamic = TRUE,
    cli.ansi = TRUE,
    cli.progress_show_after = 0,
    cli.progress_multiline = FALSE
  )

  fun <- function() {
    id1 <- cli_progress_bar(
      "bar1",
      total = 3,
      type = "custom",
      format = "bar1: {pb_current}",
      current = FALSE
    )
    id2 <- cli_progress_bar(
      "bar2",
      total = 3,
      type = "custom",
      format = "bar2: {pb_current}",
      current = FALSE
    )
    cli_progress_update(id = id1, force = TRUE)
    cli_progress_update(id = id2, force = TRUE)
    cli_progress_update(id = id1, force = TRUE)
    cli_progress_done(id = id1)
    cli_progress_done(id = id2)
  }

  msgs <- capture_cli_messages(fun())
  ## No cursor-up escapes — multiline render is disabled.
  expect_false(any(grepl("\033\\[\\d+A", msgs)))
  ## Newlines between bars only happen in multi-line mode.
  expect_false(any(grepl("\033\\[K\n", msgs)))
})

test_that("is_progress_multiline() defaults to TRUE", {
  withr::local_options(cli.progress_multiline = NULL)
  expect_true(is_progress_multiline())
})

test_that("is_progress_multiline() honours TRUE/FALSE", {
  withr::local_options(cli.progress_multiline = TRUE)
  expect_true(is_progress_multiline())

  withr::local_options(cli.progress_multiline = FALSE)
  expect_false(is_progress_multiline())
})

test_that("is_progress_multiline() rejects invalid values", {
  withr::local_options(cli.progress_multiline = "yes")
  expect_snapshot(error = TRUE, is_progress_multiline())

  withr::local_options(cli.progress_multiline = NA)
  expect_snapshot(error = TRUE, is_progress_multiline())

  withr::local_options(cli.progress_multiline = c(TRUE, FALSE))
  expect_snapshot(error = TRUE, is_progress_multiline())

  withr::local_options(cli.progress_multiline = 1)
  expect_snapshot(error = TRUE, is_progress_multiline())
})
