
setup(start_app())
teardown(stop_app())

test_that("cliapp output auto", {
  skip_on_cran()

  txt <- "Stay calm. This is a test."
  script <- tempfile(fileext = ".R")
  on.exit(unlink(script, recursive = TRUE), add = TRUE)

  # stderr if not interactive ----------------

  code <- substitute(env = list(txt = txt), {
    options(rlib_interactive = FALSE, crayon.enabled = FALSE)
    cli::cli_text(txt)
  })
  cat(deparse(code), file = script, sep = "\n")

  out <- callr::rscript(script, show = FALSE, fail_on_status = FALSE)
  expect_true(out$stderr %in% paste0(txt, c("\n", "\r\n")))
  expect_equal(out$stdout, "")

  # stdout if interactive --------------------

  code <- substitute(env = list(txt = txt), {
    options(rlib_interactive = TRUE, crayon.enabled = FALSE)
    cli::cli_text(txt)
  })
  cat(deparse(code), file = script, sep = "\n")

  out <- callr::rscript(script, show = FALSE, fail_on_status = FALSE)
  expect_true(out$stdout %in% paste0(txt, c("\n", "\r\n")))
  expect_equal(out$stderr, "")

  # choose explicitly -----------------------

  txt2 <- "Don't move"
  code <- substitute(env = list(txt = txt, txt2 = txt2), {
    options(rlib_interactive = FALSE, crayon.enabled = FALSE)
    cli::start_app(output = "stderr")
    cli::cli_text(txt)
    cli::stop_app()
    options(rlib_interactive = TRUE)
    cli::start_app(output = "stdout")
    cli::cli_text(txt2)
    cli::stop_app()
  })
  cat(deparse(code), file = script, sep = "\n")

  out <- callr::rscript(script, show = FALSE, fail_on_status = FALSE)
  expect_true(out$stderr %in% paste0(txt, c("\n", "\r\n")))
  expect_true(out$stdout %in% paste0(txt2, c("\n", "\r\n")))
})

test_that("can also use a connection", {
  skip_on_cran()

  txt <- "Stay calm. This is a test."
  script <- tempfile(fileext = ".R")
  on.exit(unlink(script, recursive = TRUE), add = TRUE)

  code <- substitute(env = list(txt = txt), {
    options(crayon.enabled = FALSE)
    con <- textConnection(NULL, open = "w", local = TRUE)
    cli::start_app(output = con)
    cli::cli_text(txt)
    cli::stop_app()
    flush(con)
    cat("output:", textConnectionValue(con), "\n", sep = "")
  })
  cat(deparse(code), file = script, sep = "\n")

  out <- callr::rscript(script, show = FALSE, fail_on_status = FALSE)
  expect_true(out$stdout %in% paste0("output:", txt, c("\n", "\r\n")))
  expect_equal(out$stderr, "")
})
