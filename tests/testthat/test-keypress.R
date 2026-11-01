test_that("control characters", {
  skip_on_cran()
  p <- r_pty()

  expect_snapshot(
    for (code in c(1:2, 4:6, 8:14, 16L, 20L, 21L, 23L, 27L, 127L)) {
      p$write_input("cli::keypress()\n")
      Sys.sleep(0.1)
      p$write_input(as.raw(code))
      p$poll_io(1000)
      cat(p$read_output())
    }
  )
})

test_that("write ahead", {
  skip_on_cran()
  p <- r_pty()
  expect_snapshot({
    p$write_input("{ Sys.sleep(0.5); cli::keypress() }\nX")
    p$poll_io(1000)
    cat(p$read_output())
  })
})

test_that("arrows, etc", {
  skip_on_cran()
  p <- r_pty()
  keys <- paste0(
    "\033",
    c(
      "[A",
      "[C",
      "[D",
      "[F",
      "[H",
      "-",
      "OA",
      "OB",
      "OC",
      "OD",
      "OF",
      "OH",
      "-",
      "[1~",
      "[2~",
      "[3~",
      "[4~",
      "[5~",
      "[6~",
      "-",
      "[[5~",
      "[[6~",
      "-",
      "[[7~",
      "[[8~",
      "-",
      "OP",
      "OQ",
      "OR",
      "OS",
      "-",
      "[15~",
      "[17~",
      "[18~",
      "[19~",
      "[20~",
      "[21~",
      "[23~",
      "[24~",
      "-",
      "[11~",
      "[12~",
      "[13~",
      "[14~",
      "-",
      ""
    )
  )
  keys[keys == "\033-"] <- "-"
  expect_snapshot({
    for (key in keys) {
      p$write_input("cli::keypress()\n")
      p$write_input(key)
      p$poll_io(1000)
      cat(p$read_output())
    }
  })
})

test_that("nonblocking", {
  skip_on_cran()
  p <- r_pty()
  expect_snapshot({
    p$write_input("cli::keypress(block = FALSE)\n")
    p$poll_io(1000)
    cat(p$read_output())
  })
  expect_snapshot({
    p$write_input("{ Sys.sleep(0.5); cli::keypress() }\nX")
    p$poll_io(1000)
    cat(p$read_output())
  })
})

# Wait for a marker to appear in a pty process's output, or time out.
keypress_wait_for <- function(p, marker, timeout = 10) {
  strip_ansi <- function(x) {
    gsub("\033(?:\\[[0-9;?]*[A-Za-z]|\\][^\007]*\007)", "", x, perl = TRUE)
  }
  out <- ""
  deadline <- Sys.time() + timeout
  while (
    Sys.time() < deadline && !grepl(marker, strip_ansi(out), fixed = TRUE)
  ) {
    p$poll_io(200)
    out <- paste0(out, p$read_output())
  }
  strip_ansi(out)
}

test_that("keypress() times out", {
  skip_on_cran()
  skip_on_os("windows")

  opts <- callr::r_process_options(
    func = function() {
      # Make sure has_keypress_support() is happy in the child, and stop
      # cli from writing cursor-control sequences to the pty (otherwise the
      # child can block on the tty write and never exit).
      Sys.setenv(TERM = "xterm", R_CLI_HIDE_CURSOR = "false")
      cat("READY\n")
      flush(stdout())
      t0 <- Sys.time()
      res <- cli::keypress(timeout = 1)
      dt <- as.numeric(Sys.time() - t0, units = "secs")
      list(res = res, elapsed = dt)
    },
    stdout = NULL,
    stderr = NULL
  )
  opts$extra$pty <- TRUE

  p <- callr::r_process$new(opts)
  on.exit(p$kill(), add = TRUE)

  expect_match(keypress_wait_for(p, "READY"), "READY", fixed = TRUE)

  # We never press a key, so keypress() should return NA on its own after
  # roughly one second, and the process should finish without hanging.
  p$wait(timeout = 5000)
  expect_false(p$is_alive())
  res <- p$get_result()
  expect_true(is.na(res$res))
  expect_gte(res$elapsed, 1)
})

test_that("keypress() is interruptible", {
  skip_on_cran()
  skip_on_os("windows")

  opts <- callr::r_process_options(
    func = function() {
      # Make sure has_keypress_support() is happy in the child, and stop
      # cli from writing cursor-control sequences to the pty (otherwise the
      # child can block on the tty write and never exit).
      Sys.setenv(TERM = "xterm", R_CLI_HIDE_CURSOR = "false")
      cat("READY\n")
      flush(stdout())
      tryCatch(cli::keypress(), interrupt = function(...) "interrupted")
    },
    stdout = NULL,
    stderr = NULL
  )
  opts$extra$pty <- TRUE

  p <- callr::r_process$new(opts)
  on.exit(p$kill(), add = TRUE)

  expect_match(keypress_wait_for(p, "READY"), "READY", fixed = TRUE)

  # Give keypress() a moment to enter its poll loop, then interrupt it.
  Sys.sleep(0.5)
  p$interrupt()

  # The interrupt should be caught and turned into "interrupted", and the
  # process should finish on its own (rather than hanging).
  p$wait(timeout = 5000)
  expect_false(p$is_alive())
  expect_equal(p$get_result(), "interrupted")
})
