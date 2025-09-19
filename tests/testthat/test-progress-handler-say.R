test_that("say_out", {
  px <- asNamespace("processx")$get_tool("px")
  tmp <- tempfile("cli-test-")
  on.exit(unlink(tmp), add = TRUE)
  withr::local_options(
    cli.progress_say_command = px,
    cli.progress_say_args = c("writefile", tmp)
  )
  p <- say_out(" 70%")
  expect_s3_class(p, "process")
  p$wait(3000)
  expect_false(p$is_alive())
  p$kill()
  expect_equal(readLines(tmp, warn = FALSE), " 70%")
})

test_that("say_update", {
  withr::local_options(cli.progress_say_frequency = 1e-9)
  local_mocked_bindings(say_out = function(text) text)
  bar <- new.env(parent = emptyenv())
  bar$current <- 10
  bar$total <- NA
  say_update(bar)
  expect_equal(bar$say_proc, 10)

  bar$total <- 50
  say_update(bar)
  expect_equal(bar$say_proc, " 20%")
})
