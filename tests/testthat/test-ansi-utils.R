test_that("re_table", {
  withr::local_options(
    cli.num_colors = 256,
    cli.hyperlink = TRUE
  )
  txt <- paste0(
    "this is some text ",
    col_red("red"),
    " some more text ",
    col_green("green"),
    " then some ",
    style_hyperlink("text", "https://example.com")
  )
  tbl <- re_table(ansi_regex(), txt)[[1]]
  tbl2 <- cbind(tbl, c(text = substring(txt, tbl[, "start"], tbl[, "end"])))
  expect_snapshot(tbl2)
  expect_snapshot(non_matching(list(tbl), txt))
})

test_that("re_table special cases", {
  withr::local_options(
    cli.num_colors = 256,
    cli.hyperlink = TRUE
  )
  txt <- "foobar"
  tbl <- re_table(ansi_regex(), txt)[[1]]
  expect_snapshot(tbl)
  expect_snapshot(non_matching(list(tbl), txt))
  expect_snapshot(non_matching(list(tbl), txt, empty = TRUE))

  txt <- col_red("foobar")
  tbl <- re_table(ansi_regex(), txt)[[1]]
  expect_snapshot(tbl)
  expect_snapshot(non_matching(list(tbl), txt))
  expect_snapshot(non_matching(list(tbl), txt, empty = TRUE))

  txt <- paste0("foo ", col_red(""), " bar")
  tbl <- re_table(ansi_regex(), txt)[[1]]
  expect_snapshot(tbl)
  expect_snapshot(non_matching(list(tbl), txt))
  expect_snapshot(non_matching(list(tbl), txt, empty = TRUE))
})

test_that("myseq", {
  expect_snapshot({
    myseq(1, 5)
    myseq(1, 1)
    myseq(1, 0)
    myseq(1, 5, 2)
    myseq(1, 6, 2)
    myseq(1, 1, 2)
    myseq(1, 2, -1)
    myseq(10, 1, -1)
    myseq(10, 1, -2)
    myseq(1, 5, -2)
  })
})
