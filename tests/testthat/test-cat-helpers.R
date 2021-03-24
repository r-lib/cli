
test_that("cat_line", {
  expect_snapshot(
    cat_line("This is ", "a ", "line of text.")
  )

  tmp <- tempfile()
  on.exit(unlink(tmp), add = TRUE)
  cat_line("This is ", "a ", "line of text.", file = tmp)
  exp <- "This is a line of text."
  expect_equal(readLines(tmp, warn = FALSE), exp)

  local_cli_config(num_colors = 256L)

  expect_snapshot({
    cat_line("This is ", "a ", "line of text.", col = "red")
    cat_line("This is ", "a ", "line of text.", background_col = "green")
  })
})

test_that_cli(configs = c("plain", "unicode"), "cat_bullet", {
  expect_snapshot({
    cat_bullet(letters[1:5])
  })
})

test_that_cli(configs = c("plain", "unicode"), "cat_boxx", {
  expect_snapshot({
    cat_boxx("foo")
  })
})

test_that_cli(configs = c("plain", "unicode"), "cat_rule", {
  expect_snapshot(local({
    withr::local_options(cli.width = 20)
    cat_rule("title")
  }))
})

test_that_cli(configs = c("plain", "unicode"), "cat_print", {
  expect_snapshot({
    cat_print(boxx(""))
  })

  expect_snapshot(local({
    tmp <- tempfile()
    on.exit(unlink(tmp), add = TRUE)
    expect_silent(cat_print(boxx(""), file = tmp))
    cat(readLines(tmp, warn = FALSE), sep = "\n")
  }))
})
