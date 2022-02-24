
test_that_cli("format_error", {
  expect_snapshot(error = TRUE, local({
    n <- "boo"
    stop(format_error(c(
            "{.var n} must be a numeric vector",
      "x" = "You've supplied a {.cls {class(n)}} vector."
    )))
  }))

  expect_snapshot(error = TRUE, local({
    len <- 26
    idx <- 100
    stop(format_error(c(
            "Must index an existing element:",
      "i" = "There {?is/are} {len} element{?s}.",
      "x" = "You've tried to subset element {idx}."
    )))
  }))
})

test_that_cli("format_warning", {
  expect_snapshot({
    n <- "boo"
    warning(format_warning(c(
            "{.var n} must be a numeric vector",
      "x" = "You've supplied a {.cls {class(n)}} vector."
    )))
  })

  expect_snapshot(local({
    len <- 26
    idx <- 100
    warning(format_warning(c(
            "Must index an existing element:",
      "i" = "There {?is/are} {len} element{?s}.",
      "x" = "You've tried to subset element {idx}."
    )))
  }))
})

test_that_cli("format_message", {
  expect_snapshot({
    n <- "boo"
    message(format_message(c(
            "{.var n} must be a numeric vector",
      "x" = "You've supplied a {.cls {class(n)}} vector."
    )))
  })

  expect_snapshot(local({
    len <- 26
    idx <- 100
    message(format_message(c(
            "Must index an existing element:",
      "i" = "There {?is/are} {len} element{?s}.",
      "x" = "You've tried to subset element {idx}."
    )))
  }))
})

test_that("format_error width in RStudio", {
  mockery::stub(format_error, "rstudio_detect", list(type = "rstudio_console"))
  withr::local_rng_version("3.3.0")
  set.seed(42)
  expect_snapshot(error = TRUE, local({
    len <- 26
    idx <- 100
    stop(format_error(c(
            lorem_ipsum(1, 3),
      "i" = lorem_ipsum(1, 3),
      "x" = lorem_ipsum(1, 3)
    )))
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

test_that("named first element", {
  expect_snapshot(
    format_error(c("*" = "foo", "*" = "bar"))
  )
  expect_snapshot(
    format_warning(c("*" = "foo", "*" = "bar"))
  )
})

test_that("no cli conditions are thrown", {
  cnd <- NULL
  withCallingHandlers({
    format_error("error")
    format_warning("warning")
    format_message("message")
  }, cli_message = function(cnd_) cnd <<- cnd_)

  expect_null(cnd)
})

test_that("cli.condition_width", {
  withr::local_options(cli.condition_width = 40, cli.num_colors = 1)
  msg <- strrep("1234567890 ", 8)
  expect_snapshot({
    format_error(msg)
    format_warning(msg)
    format_message(msg)
  })

  withr::local_options(cli.condition_width = Inf)
  expect_snapshot({
    format_error(msg)
    format_warning(msg)
    format_message(msg)
  })
})

test_that_cli("suppressing Unicode bullets", {
  withr::local_options(cli.condition_unicode_bullets = FALSE)
  expect_snapshot(error = TRUE, local({
    n <- "boo"
    stop(format_error(c(
            "{.var n} must be a numeric vector",
      "x" = "You've supplied a {.cls {class(n)}} vector.",
      "v" = "Success.",
      "i" = "Info.",
      "*" = "Bullet",
      ">" = "Arrow"
    )))
  }))
})

test_that("edge cases", {
  expect_equal(cli::format_error(""), "")
})
