test_that("win10_build works for different osVersion", {
  local_mocked_bindings(
    sessionInfo = function() list(running = NULL), .package = "utils"
  )
  expect_identical(win10_build(), 0L)

  local_mocked_bindings(
    sessionInfo = function() list(running = "Debian GNU/Linux 11 (bullseye)"),
    .package = "utils"
  )
  expect_identical(win10_build(), 0L)

  local_mocked_bindings(
    sessionInfo = function() list(running = "Windows 10 x64 (build 16299)"),
    .package = "utils"
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

  local_mocked_bindings(os_type = function() "windows")
  local_mocked_bindings(commandArgs = function() "--ess")
  local_mocked_bindings(is_emacs_with_color = function() TRUE)

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

  local_mocked_bindings(os_type = function() "unix")
  local_mocked_bindings(is_emacs_with_color = function() TRUE)

  withr::local_options(cli.default_num_colors = NULL)

  expect_equal(detect_tty_colors(), 8L)

  withr::local_options(cli.default_num_colors = 123L)
  expect_equal(detect_tty_colors(), 123L)
})

test_that("cli.default_num_colors #5", {

  # rstudio terminal on Windows
  withr::local_envvar(COLORTERM = NA_character_)

  local_mocked_bindings(os_type = function() "windows")
  local_mocked_bindings(win10_build = function() 10586)
  local_mocked_bindings(
    rstudio_detect = function() list(type = "rstudio_terminal")
  )
  local_mocked_bindings(system2 = function(...) TRUE)

  withr::local_options(cli.default_num_colors = NULL)
  expect_equal(detect_tty_colors(), 8L)

  withr::local_options(cli.default_num_colors = 123L)
  expect_equal(detect_tty_colors(), 123L)
})

test_that("cli.default_num_colors #6", {

  # Windows 10 terminal
  withr::local_envvar(COLORTERM = NA_character_)
  withr::local_options(cli.default_num_colors = NULL)

  local_mocked_bindings(os_type = function() "windows")
  local_mocked_bindings(win10_build = function() 10586)
  local_mocked_bindings(
    rstudio_detect = function() list(type = "not_rstudio")
  )
  local_mocked_bindings(system2 = function(...) TRUE)
  expect_equal(detect_tty_colors(), 256L)

  local_mocked_bindings(win10_build = function() 14931)
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
  local_mocked_bindings(os_type = function() "windows")
  local_mocked_bindings(win10_build = function() 1)

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

  local_mocked_bindings(os_type = function() "unix")
  local_mocked_bindings(is_emacs_with_color = function() FALSE)
  local_mocked_bindings(system = function(...) "8")

  withr::local_options(cli.default_num_colors = NULL)
  expect_equal(detect_tty_colors(), 256L)

  withr::local_options(cli.default_num_colors = 123L)
  expect_equal(detect_tty_colors(), 123L)
})

test_that("ESS_BACKGROUND_MODE", {
  withr::local_envvar(
    RSTUDIO = NA_character_,
    ESS_BACKGROUND_MODE = NA_character_
  )

  local_mocked_bindings(is_iterm = function() FALSE)
  local_mocked_bindings(is_emacs = function() TRUE)

  expect_false(detect_dark_theme("auto"))

  withr::local_envvar(ESS_BACKGROUND_MODE = "dark")
  expect_true(detect_dark_theme("auto"))
})

test_that("emacs_version", {
  withr::local_envvar(INSIDE_EMACS = "")
  expect_true(is.na(emacs_version()))
  withr::local_envvar(INSIDE_EMACS = "foobar")
  expect_true(is.na(emacs_version()))

  withr::local_envvar(INSIDE_EMACS = "23.2.3")
  expect_equal(emacs_version(), c(23, 2, 3))
  withr::local_envvar(INSIDE_EMACS = "23.2.3,foobar")
  expect_equal(emacs_version(), c(23, 2, 3))
  withr::local_envvar(INSIDE_EMACS = "'23.2.3'")
  expect_equal(emacs_version(), c(23, 2, 3))
  withr::local_envvar(INSIDE_EMACS = "'23.2.3',foobar")
  expect_equal(emacs_version(), c(23, 2, 3))
})
