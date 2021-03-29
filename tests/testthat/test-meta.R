
start_app()
on.exit(stop_app(), add = TRUE)

test_that_cli("meta basics", {
  expect_snapshot(
    cli::cli({
      message("This is before")
      cli_alert_info("First message")
      message("This as well")
      cli_alert_success("Success!")
    })
  )
})

test_that_cli("meta is single cli_message", {
  msgs <- list()
  withCallingHandlers(
    cli::cli({
      cli_alert_info("First message")
      cli_alert_success("Success!")
    }),
    cli_message = function(msg) {
      msgs <<- c(msgs, list(msg))
      invokeRestart("cli_message_handled")
    }
  )

  expect_equal(length(msgs), 1L)
  expect_snapshot(cli_server_default(msgs[[1]]))
})

test_that_cli("meta is single cliMessage", {
  msgs <- list()
  expect_snapshot(
    withCallingHandlers(
      cli::cli({
        cli_alert_info("First message")
        cli_alert_success("Success!")
      }),
      cliMessage = function(msg) {
        msgs <<- c(msgs, list(msg))
      }
    )
  )

  expect_equal(length(msgs), 1L)
})

test_that_cli("substitution", {
  expect_snapshot(local({
    x <- 1:3
    cli({
      title <- "My title"
      cli_h1("Title: {.emph {title}}")
      cli_text("And {.emph some} more: {.val {x}}")
    })
  }))
})
