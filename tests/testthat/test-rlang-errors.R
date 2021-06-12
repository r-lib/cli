
test_that_cli("cli_abort", {
  expect_snapshot(error = TRUE, local({
    n <- "boo"
    cli_abort(c(
            "{.var n} must be a numeric vector",
      "x" = "You've supplied a {.cls {class(n)}} vector."
    ))
  }))

  expect_snapshot(error = TRUE, local({
    len <- 26
    idx <- 100
    cli_abort(c(
            "Must index an existing element:",
      "i" = "There {?is/are} {len} element{?s}.",
      "x" = "You've tried to subset element {idx}."
    ))
  }))
})

test_that_cli("cli_warn", {
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
  mockery::stub(cli_abort, "rstudio_detect", list(type = "rstudio_console"))
  local_rng_version("3.5.0")
  set.seed(42)
  expect_snapshot(error = TRUE, local({
    len <- 26
    idx <- 100
    cli_abort(c(
            lorem_ipsum(1, 3),
      "i" = lorem_ipsum(1, 3),
      "x" = lorem_ipsum(1, 3)
    ))
  }))
})

test_that_cli(config = "ansi", "color in RStudio", {
  mockery::stub(
    get_rstudio_fg_color0,
    "rstudio_detect",
    list(type = "rstudio_console", num_colors = 256)
  )
  mockery::stub(
    get_rstudio_fg_color0,
    "rstudioapi::getThemeInfo",
    list(foreground = "rgb(0, 0, 0)")
  )
  expect_snapshot({
    col <- get_rstudio_fg_color0()
    cat(col("this is the new color"))
  })

  mockery::stub(
    get_rstudio_fg_color0,
    "rstudioapi::getThemeInfo",
    list()
  )
  expect_null(get_rstudio_fg_color0())

  mockery::stub(
    get_rstudio_fg_color0,
    "rstudio_detect",
    list(type = "rstudio_console", num_colors = 1)
    )
  expect_null(get_rstudio_fg_color0())
})

test_that_cli(config = "ansi", "update_rstudio_color", {
  mockery::stub(
    update_rstudio_color,
    "get_rstudio_fg_color",
    function() make_ansi_style("#008800")
  )
  expect_snapshot(cat(update_rstudio_color("color me interested")))
})
