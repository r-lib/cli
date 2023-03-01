
test_that("ansi_align", {
  txt0 <- "\033]8;;https://ex.com\007te\033]8;;\007"
  txt1 <- st_from_bel(txt0)
  txt <- paste0(txt0, txt1)
  space3 <- strrep(" ", 3)
  space6 <- strrep(" ", 6)
  expect_equal(
    ansi_align(txt, 10),
    ansi_string(paste0(txt, space6))
  )

  expect_equal(
    ansi_align(txt, 10, "center"),
    ansi_string(paste0(space3, txt, space3))
  )

  expect_equal(
    ansi_align(txt, 10, "right"),
    ansi_string(paste0(space6, txt))
  )
})

test_that("ansi_chartr", {
  txt0 <- "1\033]8;;https://ex.com\007text\033]8;;\0072"
  txt1 <- st_from_bel(txt0)
  txt <- paste0(txt0, txt1)
  expect_equal(
    ansi_chartr("12x0", "34yo", txt),
    ansi_string(paste0(
      "3\033]8;;https://ex.com\007teyt\033]8;;\0074",
      st_from_bel("3\033]8;;https://ex.com\007teyt\033]8;;\0074")
    ))
  )
})

test_that("ansi_columns", {
  txt <- "\033]8;;https://ex.com\007text\033]8;;\007"

  expect_equal(
    ansi_strip(ansi_columns(rep(txt, 4), 10)),
    c("text text ", "text text ")
  )
})

test_that("ansi_has_any", {
  txt <- "1\033]8;;https://ex.com\007text\033]8;;\0072"
  expect_true(ansi_has_any(txt))
  expect_true(ansi_has_any(txt, sgr = FALSE, csi = FALSE))
  expect_false(ansi_has_any(txt, link = FALSE))
})

test_that("ansi_html", {
  txt <- paste0(
    "1",
    "\033[1m\033]8;;https://ex.com\007",
    "text",
    "\033]8;;\007",
    "\033[22m",
    "2"
  )

  expect_equal(
    ansi_html(txt),
    paste0(
      "1",
      "<a class=\"ansi-link\" href=\"https://ex.com\">",
      "<span class=\"ansi ansi-bold\">",
      "text",
      "</span>",
      "</a>",
      "2"
    )
  )
})

test_that("ansi_nchar", {
  cases <- list(
    list("\033]8;;https://ex.com\007text\033]8;;\007", 4),
    list("\033]8;x=1:y=2;https://ex.com\007text\033]8;;\007", 4),
    list("\033]8;;https://ex.com\007text\033]8;;\007", 4),
    list("\033[1m\033]8;;https://ex.com\007text\033]8;;\007\033[22m", 4)
  )

  for (c in cases) {
    expect_equal(ansi_nchar(c[[1]]), c[[2]])
  }
})

test_that("ansi_regex", {
  cases <- c(
    "1\033]8;;https://ex.com\007text\033]8;;\0072",
    "1\033]8;x=1:y=2;https://ex.com\007text\033]8;;\0072",
    "1\033]8;;https://ex.com\007text\033]8;;\0072",
    "1\033[1m\033]8;;https://ex.com\007text\033]8;;\007\033[22m2"
  )

  for (case in cases) {
    expect_equal(gsub(ansi_regex(), "", case, perl = TRUE), "1text2")
  }
})

test_that("ansi_simplify", {
  txt <- "1\033[1m\033]8;;https://ex.com\007text\033]8;;\007\033[22m2"
  expect_equal(
    ansi_simplify(txt),
    ansi_string(
      "1\033]8;;https://ex.com\007\033[1mtext\033[22m\033]8;;\0072"
    )
  )
})

test_that("ansi_strip", {
  cases <- c(
    "1\033]8;;https://ex.com\007text\033]8;;\0072",
    "1\033]8;x=1:y=2;https://ex.com\007text\033]8;;\0072",
    "1\033]8;;https://ex.com\007text\033]8;;\0072",
    "1\033[1m\033]8;;https://ex.com\007text\033]8;;\007\033[22m2"
  )

  for (case in cases) {
    expect_equal(ansi_strip(case), "1text2")
  }

  txt <- "1\033[1m\033]8;;https://ex.com\007text\033]8;;\007\033[22m2"
  expect_equal(
    ansi_strip(txt, link = FALSE),
    "1\033]8;;https://ex.com\007text\033]8;;\0072"
  )
  expect_equal(
    ansi_strip(txt, sgr = FALSE),
    "1\033[1mtext\033[22m2"
  )
})

test_that("ansi_strsplit", {
  txt <- "1\033]8;;https://ex.com\007te;xt\033]8;;\0072"
  expect_equal(
    ansi_strsplit(txt, ";"),
    list(ansi_string(c(
      "1\033]8;;https://ex.com\007te\033]8;;\007",
      "\033]8;;https://ex.com\007xt\033]8;;\0072"
    )))
  )
})

test_that("ansi_strtrim", {
  txt <- "1\033]8;;https://ex.com\007text\033]8;;\0072"
  expect_equal(
    ansi_strtrim(txt, 6),
    ansi_string(txt)
  )
  expect_equal(
    ansi_strtrim(txt, 4),
    ansi_string(paste0(ansi_substr(txt, 1, 1), "..."))
  )
})

test_that("ansi_strwrap", {
  txt <- "1\033]8;;https://ex.com\007text\033]8;;\0072"
  wrp <- ansi_strwrap(strrep(paste0(txt, " "), 10), 15)
  expect_equal(
    wrp,
    ansi_string(rep(paste0(txt, " ", txt), 5))
  )
})

test_that("ansi_substr", {
  txt <- "1\033[1m\033]8;;https://ex.com\007text\033]8;;\007\033[22m2"

  cases <- list(
    list(1, 3, "1\033]8;;https://ex.com\007\033[1mte\033[22m\033]8;;\007"),
    list(4, 6, "\033]8;;https://ex.com\007\033[1mxt\033[22m\033]8;;\0072"),
    list(3, 4, "\033]8;;https://ex.com\007\033[1mex\033[22m\033]8;;\007"),
    list(1, 10, "1\033]8;;https://ex.com\007\033[1mtext\033[22m\033]8;;\0072")
  )

  for (c in cases) {
    expect_equal(ansi_substr(txt, c[[1]], c[[2]]), ansi_string(c[[3]]))
  }
})

test_that("ansi_substring", {
  txt <- "1\033[1m\033]8;;https://ex.com\007text\033]8;;\007\033[22m2"

  cases <- list(
    list(1, 3, "1\033]8;;https://ex.com\007\033[1mte\033[22m\033]8;;\007"),
    list(4, 6, "\033]8;;https://ex.com\007\033[1mxt\033[22m\033]8;;\0072"),
    list(3, 4, "\033]8;;https://ex.com\007\033[1mex\033[22m\033]8;;\007"),
    list(1, 10, "1\033]8;;https://ex.com\007\033[1mtext\033[22m\033]8;;\0072")
  )

  for (c in cases) {
    expect_equal(ansi_substring(txt, c[[1]], c[[2]]), ansi_string(c[[3]]))
  }
})

test_that("ansi_tolower", {
  txt <- "Pre\033]8;;https://ex.com\007tEXt\033]8;;\007PoST"
  expect_equal(
    ansi_tolower(txt),
    ansi_string("pre\033]8;;https://ex.com\007text\033]8;;\007post")
  )
})

test_that("ansi_toupper", {
  txt <- "Pre\033]8;;https://ex.com\007tEXt\033]8;;\007PoST"
  expect_equal(
    ansi_toupper(txt),
    ansi_string("PRE\033]8;;https://ex.com\007TEXT\033]8;;\007POST")
  )
})

test_that("ansi_trimws", {
  txt <- "1\033[1m\033]8;;https://ex.com\007text\033]8;;\007\033[22m2"
  expect_equal(
    ansi_trimws(paste0("   ", txt, "   ")),
    ansi_simplify(txt)
  )
  expect_equal(
    ansi_trimws(txt),
    ansi_string(txt)
  )
})

test_that("unknown hyperlink type", {
  expect_snapshot(
    error = TRUE,
    make_link("this", "foobar")
  )
})

test_that("iterm file links", {
  withr::local_envvar(R_CLI_HYPERLINK_STYLE = "iterm")
  withr::local_options(cli.hyperlink = TRUE)
  expect_snapshot({
    cli::cli_text("{.file /path/to/file:10}")
    cli::cli_text("{.file /path/to/file:10:20}")
  })
})

test_that("rstudio links", {
  withr::local_envvar(
    RSTUDIO = "1",
    RSTUDIO_SESSION_PID = Sys.getpid(),
    RSTUDIO_CHILD_PROCESS_PANE = "build",
    RSTUDIO_CLI_HYPERLINKS = "1"
  )
  withr::local_options(
    cli.hyperlink = TRUE,
    cli.hyperlink_help = TRUE,
    cli.hyperlink_run = TRUE,
    cli.hyperlink_vignette = TRUE
  )
  expect_snapshot(
    cli::cli_text("{.fun pkg::fun}")
  )
  expect_snapshot(
    cli::cli_text("{.help fun}")
  )
  expect_snapshot(
    cli::cli_text("{.run package::func()}")
  )
  expect_snapshot(
    cli::cli_text("{.vignette package::title}")
  )
  expect_snapshot(
    cli::cli_text("{.topic pkg::topic}")
  )
})

test_that("ST hyperlinks", {
  withr::local_envvar(R_CLI_HYPERLINK_MODE = "posix")
  withr::local_options(cli.hyperlink = TRUE)
  expect_snapshot(
    cat(style_hyperlink("text", "https://example.com"))
  )
})

test_that("ansi_has_hyperlink_support", {
  local_clean_cli_context()

  # force with env var
  withr::with_envvar(list(R_CLI_HYPERLINKS = "true"),
    expect_true(ansi_has_hyperlink_support())
  )

  # if no ansi support, then no
  withr::with_options(list(cli.num_colors = 1),
    expect_false(ansi_has_hyperlink_support())
  )
  withr::with_envvar(list(R_CLI_NUM_COLORS = "1"),
    expect_false(ansi_has_hyperlink_support())
  )
  withr::with_options(list(crayon.enabled = FALSE),
    expect_false(ansi_has_hyperlink_support())
  )
  withr::with_envvar(list(NO_COLOR = "true"),
    expect_false(ansi_has_hyperlink_support())
  )

  # are we in rstudio with support?
  mockery::stub(ansi_has_hyperlink_support, "rstudio_detect",
                list(type = "rstudio_console", hyperlink = TRUE))
  expect_true(ansi_has_hyperlink_support())
})

test_that("ansi_has_hyperlink_support 2", {
  local_clean_cli_context()

  mockery::stub(ansi_has_hyperlink_support, "isatty", FALSE)
  expect_false(ansi_has_hyperlink_support())
})

test_that("ansi_has_hyperlink_support 3", {
  local_clean_cli_context()

  mockery::stub(ansi_has_hyperlink_support, "isatty", TRUE)
  mockery::stub(ansi_has_hyperlink_support, "is_windows", TRUE)
  withr::local_envvar(WT_SESSION = "4c464723-f51f-4612-83f7-31e1c75abd83")
  expect_true(ansi_has_hyperlink_support())
})

test_that("ansi_has_hyperlink_support 4", {
  local_clean_cli_context()
  mockery::stub(ansi_has_hyperlink_support, "isatty", TRUE)

  withr::local_envvar("CI" = "true")
  expect_false(ansi_has_hyperlink_support())

  withr::local_envvar("CI" = NA_character_, TEAMCITY_VERSION = "1")
  expect_false(ansi_has_hyperlink_support())
})

test_that("ansi_has_hyperlink_support 5", {
  local_clean_cli_context()
  mockery::stub(ansi_has_hyperlink_support, "isatty", TRUE)

  withr::local_envvar(
    TERM_PROGRAM = "iTerm.app",
    TERM_PROGRAM_VERSION = "3.4.16"
  )
  expect_true(ansi_has_hyperlink_support())
})

test_that("ansi_has_hyperlink_support 5", {
  local_clean_cli_context()
  mockery::stub(ansi_has_hyperlink_support, "isatty", TRUE)

  withr::local_envvar(VTE_VERSION = "0.51.1")
  expect_true(ansi_has_hyperlink_support())

  withr::local_envvar(VTE_VERSION = "5110")
  expect_true(ansi_has_hyperlink_support())

  withr::local_envvar(VTE_VERSION = "foo")
  expect_false(ansi_has_hyperlink_support())
})

test_that("ansi_hyperlink_types", {
  local_clean_cli_context()
  withr::local_envvar(
    R_CLI_HYPERLINKS = "true",
    R_CLI_HYPERLINK_RUN = "true"
  )
  expect_true(ansi_hyperlink_types()[["run"]])
})
