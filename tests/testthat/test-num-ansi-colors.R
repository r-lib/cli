test_that("win10_build works for different osVersion", {
    mockery::stub(
        win10_build, "utils::sessionInfo",
        list(running = NULL)
    )
    expect_identical(win10_build(), 0L)

    mockery::stub(
        win10_build, "utils::sessionInfo",
        list(running = "Debian GNU/Linux 11 (bullseye)")
    )
    expect_identical(win10_build(), 0L)

    mockery::stub(
        win10_build, "utils::sessionInfo",
        list(running = "Windows 10 x64 (build 16299)")
    )
    expect_identical(win10_build(), 16299L)
})

test_that("cli.default_num_colors #1", {

  # crayon.enabled
  withr::local_envvar(R_CLI_NUM_COLORS = NA_character_)
  withr::local_options(
    cli.num_colors = NULL,
    crayon.enabled = TRUE,
    crayon.colors = NULL,
    cli.default_num_colors = NULL
  )

  expect_equal(num_ansi_colors(), 8L)

  withr::local_options(cli.default_num_colors = 123L)
  expect_equal(num_ansi_colors(), 123L)
})

test_that("cli.default_num_colors #2", {

  # Windows emacs
  withr::local_envvar(
    R_CLI_NUM_COLORS = NA_character_,
    RSTUDIO = NA_character_
  )
  withr::local_options(
    cli.num_colors = NULL,
    crayon.enabled = NULL,
    crayon.colors = NULL,
    cli.default_num_colors = NULL
  )

  mockery::stub(num_ansi_colors, "os_type", "windows")
  mockery::stub(num_ansi_colors, "commandArgs", "--ess")
  mockery::stub(num_ansi_colors, "is_emacs_with_color", TRUE)

  expect_equal(num_ansi_colors(), 8L)

  withr::local_options(cli.default_num_colors = 123L)
  expect_equal(num_ansi_colors(), 123L)
})

test_that("cli.default_num_colors #3", {

  # non-truecolor COLORMAP
  withr::local_envvar(COLORTERM = "other")
  withr::local_options(cli.default_num_colors = NULL)

  expect_equal(detect_tty_colors(), 8L)

  withr::local_options(cli.default_num_colors = 123L)
  expect_equal(detect_tty_colors(), 123L)
})

test_that("cli.default_num_colors #4", {

  # Unix emacs with color
  withr::local_envvar(COLORTERM = NA_character_)

  mockery::stub(detect_tty_colors, "os_type", "unix")
  mockery::stub(detect_tty_colors, "is_emacs_with_color", TRUE)

  withr::local_options(cli.default_num_colors = NULL)

  expect_equal(detect_tty_colors(), 8L)

  withr::local_options(cli.default_num_colors = 123L)
  expect_equal(detect_tty_colors(), 123L)
})

test_that("cli.default_num_colors #5", {

  # rstudio terminal on Windows
  withr::local_envvar(COLORTERM = NA_character_)

  mockery::stub(detect_tty_colors, "os_type", "windows")
  mockery::stub(detect_tty_colors, "win10_build", 10586)
  mockery::stub(
    detect_tty_colors,
    "rstudio_detect",
    list(type = "rstudio_terminal")
  )
  mockery::stub(detect_tty_colors, "system2", TRUE)

  withr::local_options(cli.default_num_colors = NULL)
  expect_equal(detect_tty_colors(), 8L)

  withr::local_options(cli.default_num_colors = 123L)
  expect_equal(detect_tty_colors(), 123L)
})

test_that("cli.default_num_colors #6", {

  # Windows 10 terminal
  withr::local_envvar(COLORTERM = NA_character_)
  withr::local_options(cli.default_num_colors = NULL)

  mockery::stub(detect_tty_colors, "os_type", "windows")
  mockery::stub(detect_tty_colors, "win10_build", 10586)
  mockery::stub(
    detect_tty_colors,
    "rstudio_detect",
    list(type = "not_rstudio")
  )
  mockery::stub(detect_tty_colors, "system2", TRUE)
  expect_equal(detect_tty_colors(), 256L)

  mockery::stub(detect_tty_colors, "win10_build", 14931)
  expect_equal(detect_tty_colors(), truecolor)

  withr::local_options(cli.default_num_colors = 123L)
  expect_equal(detect_tty_colors(), 123L)
})

test_that("cli.default_num_colors #7", {

  # conemu or cmder
  withr::local_envvar(
    COLORTERM = NA_character_,
    ConEmuANSI = "ON"
  )
  withr::local_options(cli.default_num_colors = NULL)
  mockery::stub(detect_tty_colors, "os_type", "windows")
  mockery::stub(detect_tty_colors, "win10_build", 1)

  expect_equal(detect_tty_colors(), 8L)
  withr::local_options(cli.default_num_colors = 123L)
  expect_equal(detect_tty_colors(), 123L)
})

test_that("cli.default_num_colors #8", {

  # unix terminal, xterm
  withr::local_envvar(
    COLORTERM = NA_character_,
    TERM = "xterm"
  )

  mockery::stub(detect_tty_colors, "os_type", "unix")
  mockery::stub(detect_tty_colors, "is_emacs_with_color", FALSE)
  mockery::stub(detect_tty_colors, "system", "8")

  withr::local_options(cli.default_num_colors = NULL)
  expect_equal(detect_tty_colors(), 256L)

  withr::local_options(cli.default_num_colors = 123L)
  expect_equal(detect_tty_colors(), 123L)
})
