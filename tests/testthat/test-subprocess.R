
context("subprocess")

test_that("events are properly generated", {
  ## This needs callr >= 3.0.0.90001, which is not yet on CRAN
  if (packageVersion("callr") < "3.0.0.9001") skip("Need newer callr")

  do <- function() {
    cli::cli_div()
    cli::cli_h1("title")
    cli::cli_text("text")
  }

  rs <- callr::r_session$new()
  on.exit(rs$kill(), add = TRUE)

  msgs <- list()
  handler <- function(msg) {
    msgs <<- c(msgs, list(msg))
    if (!is.null(findRestart("muffleMessage"))) {
      invokeRestart("muffleMessage")
    }
  }

  withCallingHandlers(
    rs$run(do),
    cli_message = handler)

  expect_equal(length(msgs), 4)
  lapply(msgs, expect_s3_class, "cli_message")
  expect_equal(msgs[[1]]$type, "div")
  expect_equal(msgs[[2]]$type, "h1")
  expect_equal(msgs[[3]]$type, "text")
  expect_equal(msgs[[4]]$type, "end")

  rs$close()
})

test_that("subprocess with default handler", {
  ## This needs callr >= 3.0.0.90001, which is not yet on CRAN
  if (packageVersion("callr") < "3.0.0.9001") skip("Need newer callr")

  do <- function() {
    cli::cli_div()
    cli::cli_h1("title")
    cli::cli_text("text")
  }

  rs <- callr::r_session$new()
  on.exit(rs$kill(), add = TRUE)

  msgs <- list()
  withr::with_options(list(
    cli.default_handler = function(msg)  {
      msgs <<- c(msgs, list(msg))
      if (!is.null(findRestart("muffleMessage"))) {
        invokeRestart("muffleMessage")
      }
    }),
    rs$run(do)
  )

  expect_equal(length(msgs), 4)
  lapply(msgs, expect_s3_class, "cli_message")
  expect_equal(msgs[[1]]$type, "div")
  expect_equal(msgs[[2]]$type, "h1")
  expect_equal(msgs[[3]]$type, "text")
  expect_equal(msgs[[4]]$type, "end")

  rs$close()
})

test_that("output in child process", {
  ## This needs callr >= 3.0.0.90001, which is not yet on CRAN
  if (packageVersion("callr") < "3.0.0.9001") skip("Need newer callr")

  do <- function() {
    options(crayon.enabled = TRUE)
    options(crayon.colors = 256)
    crayon::num_colors(forget = TRUE)
    withCallingHandlers(
      cli_message = function(msg) {
        withCallingHandlers(
          cli:::cli_server_default(msg),
          message = function(mmsg) {
            class(mmsg) <- c("callr_message", "message", "condition")
            signalCondition(mmsg)
            invokeRestart("muffleMessage")
          }
        )
        invokeRestart("muffleMessage")
      }, {
        cli::start_app(theme = cli::simple_theme())
        cli::cli_h1("Title")
        cli::cli_text("This is generated in the {.emph subprocess}.")
        "foobar"
      }
    )
  }

  rs <- callr::r_session$new()
  on.exit(rs$kill(), add = TRUE)

  msgs <- list()
  result <- withCallingHandlers(
    callr_message = function(msg) {
      msgs <<- c(msgs, list(msg))
      if (!is.null(findRestart("muffleMessage"))) {
        invokeRestart("muffleMessage")
      }
    },
    rs$run_with_output(do)
  )

  expect_equal(result$stdout, "")
  expect_equal(result$stderr, "")
  expect_identical(result$result, "foobar")
  expect_null(result$error)
  lapply(msgs, expect_s3_class, "callr_message")
  str <- paste(vcapply(msgs, "[[", "message"), collapse = "")
  expect_true(crayon::has_style(str))
  expect_match(str, "Title")
  expect_match(str, "This is generated")

  rs$close()
})
