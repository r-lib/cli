test_that_cli("cli_abort", {
  withr::local_options(cli.theme_dark = FALSE)
  expect_snapshot(
    error = TRUE,
    local({
      n <- "boo"
      cli_abort(c(
        "{.var n} must be a numeric vector",
        "x" = "You've supplied a {.cls {class(n)}} vector."
      ))
    })
  )

  expect_snapshot(
    error = TRUE,
    local({
      len <- 26
      idx <- 100
      cli_abort(c(
        "Must index an existing element:",
        "i" = "There {?is/are} {len} element{?s}.",
        "x" = "You've tried to subset element {idx}."
      ))
    })
  )

  n <- "boo"
  err <- tryCatch(
    cli_abort(c(
      "{.var n} must be a numeric vector",
      "x" = "You've supplied a {.cls {class(n)}} vector."
    )),
    error = function(e) e
  )
  expect_snapshot(c(err$message, err$body))
})

test_that_cli("cli_warn", {
  skip_if_not_installed("rlang", "1.0.0")

  withr::local_options(cli.theme_dark = FALSE)
  expect_snapshot({
    n <- "boo"
    cli_warn(c(
      "{.var n} must be a numeric vector",
      "x" = "You've supplied a {.cls {class(n)}} vector."
    ))
  })

  expect_snapshot(local({
    len <- 26
    idx <- 100
    cli_warn(c(
      "Must index an existing element:",
      "i" = "There {?is/are} {len} element{?s}.",
      "x" = "You've tried to subset element {idx}."
    ))
  }))
})

test_that_cli("cli_inform", {
  skip_if_not_installed("rlang", "1.0.0")

  withr::local_options(cli.ansi = FALSE)
  expect_snapshot({
    n <- "boo"
    cli_inform(c(
      "{.var n} must be a numeric vector",
      "x" = "You've supplied a {.cls {class(n)}} vector."
    ))
  })

  expect_snapshot(local({
    len <- 26
    idx <- 100
    cli_inform(c(
      "Must index an existing element:",
      "i" = "There {?is/are} {len} element{?s}.",
      "x" = "You've tried to subset element {idx}."
    ))
  }))
})

test_that("cli_abort width in RStudio", {
  # this is to fix breakage with new testthat
  withr::local_options(cli.condition_width = getOption("cli.width"))
  local_mocked_bindings(
    rstudio_detect = function() list(type = "rstudio_console")
  )
  withr::local_rng_version("3.5.0")
  set.seed(42)
  expect_snapshot(
    error = TRUE,
    local({
      len <- 26
      idx <- 100
      cli_abort(c(
        lorem_ipsum(1, 3),
        "i" = lorem_ipsum(1, 3),
        "x" = lorem_ipsum(1, 3)
      ))
    })
  )
})

test_that_cli(configs = "ansi", "color in RStudio", {
  local_mocked_bindings(
    rstudio_detect = function()
      list(type = "rstudio_console", num_colors = 256),
    get_rstudio_theme = function() list(foreground = "rgb(0, 0, 0)")
  )
  expect_snapshot({
    col <- get_rstudio_fg_color0()
    cat(col("this is the new color"))
  })

  local_mocked_bindings(get_rstudio_theme = function() list())
  expect_null(get_rstudio_fg_color0())

  local_mocked_bindings(
    rstudio_detect = function() list(type = "rstudio_console", num_colors = 1)
  )
  expect_null(get_rstudio_fg_color0())
})

test_that_cli(configs = "ansi", "update_rstudio_color", {
  local_mocked_bindings(
    get_rstudio_fg_color = function() make_ansi_style("#008800")
  )
  expect_snapshot(cat(update_rstudio_color("color me interested")))
})
