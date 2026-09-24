test_that("is_ansi_tty() honours cli.ansi option", {
  withr::with_options(list(cli.ansi = TRUE), {
    expect_true(is_ansi_tty())
  })
  withr::with_options(list(cli.ansi = FALSE), {
    expect_false(is_ansi_tty())
  })
})

test_that("is_ansi_tty() rejects invalid cli.ansi option values", {
  withr::with_options(list(cli.ansi = "yes"), {
    expect_snapshot(error = TRUE, is_ansi_tty())
  })
  withr::with_options(list(cli.ansi = NA), {
    expect_snapshot(error = TRUE, is_ansi_tty())
  })
  withr::with_options(list(cli.ansi = 1), {
    expect_snapshot(error = TRUE, is_ansi_tty())
  })
})

test_that("is_ansi_tty() honours R_CLI_ANSI env var", {
  withr::local_options(cli.ansi = NULL)

  for (val in c("true", "TRUE", "True", "on", "yes", "y", "t", "1")) {
    withr::with_envvar(c(R_CLI_ANSI = val), {
      expect_true(is_ansi_tty(), info = val)
    })
  }

  for (val in c("false", "FALSE", "False", "off", "no", "n", "f", "0")) {
    withr::with_envvar(c(R_CLI_ANSI = val), {
      expect_false(is_ansi_tty(), info = val)
    })
  }
})

test_that("is_ansi_tty() rejects invalid R_CLI_ANSI values", {
  withr::local_options(cli.ansi = NULL)
  withr::local_envvar(R_CLI_ANSI = "maybe")
  expect_snapshot(error = TRUE, is_ansi_tty())
})

test_that("cli.ansi option takes precedence over R_CLI_ANSI", {
  withr::local_envvar(R_CLI_ANSI = "false")
  withr::with_options(list(cli.ansi = TRUE), {
    expect_true(is_ansi_tty())
  })

  withr::local_envvar(R_CLI_ANSI = "true")
  withr::with_options(list(cli.ansi = FALSE), {
    expect_false(is_ansi_tty())
  })
})
