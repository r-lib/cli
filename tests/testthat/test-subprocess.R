
test_that("events are properly generated", {
  ## This needs callr >= 3.0.0.90001, which is not yet on CRAN
  if (packageVersion("callr") < "3.0.0.9001") skip("Need newer callr")

  do <- function() {
    options(cli.message_class = "callr_message")
    cli::cli_div()
    cli::cli_h1("title")
    cli::cli_text("text")
  }

  rs <- callr::r_session$new()
  on.exit(rs$kill(), add = TRUE)

  msgs <- list()
  handler <- function(msg) {
    msgs <<- c(msgs, list(msg))
    if (!is.null(findRestart("cli_message_handled"))) {
      invokeRestart("cli_message_handled")
    }
    if (!is.null(findRestart("callr_r_session_muffle"))) {
      invokeRestart("callr_r_session_muffle")
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
    options(cli.message_class = "callr_message")
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
      if (!is.null(findRestart("cli_message_handled"))) {
        invokeRestart("cli_message_handled")
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

  # We need to do our own condition handling, otherwise callr will
  # handle `cli_message` and copy it to the main process.
  # So on `cli_message` we just call the default handler, which will
  # call `message()`, and on `message` we'll copy the formatted message
  # to the main process.

  do <- function() {
    options(cli.num_colors = 256)
    withCallingHandlers({
        cli::start_app(theme = cli::simple_theme())
        cli::cli_h1("Title")
        cli::cli_text("This is generated in the {.emph subprocess}.")
        "foobar"
      },
      cli_message = function(msg) {
        withCallingHandlers({
          cli:::cli_server_default(msg)
          invokeRestart("cli_message_handled") },
          message = function(mmsg) {
            class(mmsg) <- c("callr_message", "message", "condition")
            signalCondition(mmsg)
        })
      }
    )
  }

  rs <- callr::r_session$new()
  on.exit(rs$kill(), add = TRUE)

  # Store the formatted messages from callr
  # We also need to muffle the default handler here

  msgs <- list()
  result <- withCallingHandlers(
    rs$run_with_output(do),
    callr_message = function(msg) {
      msgs <<- c(msgs, list(msg))
      if (!is.null(msg$muffle) && !is.null(findRestart(msg$muffle))) {
        invokeRestart(msg$muffle)
      }
    }
  )

  expect_equal(result$stdout, "")
  expect_equal(result$stderr, "")
  expect_identical(result$result, "foobar")
  expect_null(result$error)
  str <- paste(vcapply(msgs, "[[", "message"), collapse = "")
  expect_true(ansi_has_any(str))
  expect_match(str, "Title")
  expect_match(str, "This is generated")

  rs$close()
})

test_that("substitution in child process", {

  do <- function() {
    options(cli.message_class = "callr_message")
    cli::cli_text("This is process {Sys.getpid()}.")
  }

  rs <- callr::r_session$new()
  on.exit(rs$kill(), add = TRUE)

  out <- capt0(rs$run(do))
  expect_match(out, glue::glue("This is process {rs$get_pid()}"))

  rs$close()
})
