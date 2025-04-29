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
