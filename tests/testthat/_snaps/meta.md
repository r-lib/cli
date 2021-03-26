# meta basics [plain]

    Code
      cli::cli({
        message("This is before")
        cli_alert_info("First message")
        message("This as well")
        cli_alert_success("Success!")
      })
    Message <simpleMessage>
      This is before
      This as well
    Message <cliMessage>
      i First message
      v Success!

# meta basics [ansi]

    Code
      cli::cli({
        message("This is before")
        cli_alert_info("First message")
        message("This as well")
        cli_alert_success("Success!")
      })
    Message <simpleMessage>
      This is before
      This as well
    Message <cliMessage>
      [36mi[39m First message
      [32mv[39m Success!

# meta basics [unicode]

    Code
      cli::cli({
        message("This is before")
        cli_alert_info("First message")
        message("This as well")
        cli_alert_success("Success!")
      })
    Message <simpleMessage>
      This is before
      This as well
    Message <cliMessage>
      ℹ First message
      ✔ Success!

# meta basics [fancy]

    Code
      cli::cli({
        message("This is before")
        cli_alert_info("First message")
        message("This as well")
        cli_alert_success("Success!")
      })
    Message <simpleMessage>
      This is before
      This as well
    Message <cliMessage>
      [36mℹ[39m First message
      [32m✔[39m Success!

# meta is single cli_message [plain]

    Code
      cli_server_default(msgs[[1]])
    Message <cliMessage>
      i First message
      v Success!
    Output
      NULL

# meta is single cli_message [ansi]

    Code
      cli_server_default(msgs[[1]])
    Message <cliMessage>
      [36mi[39m First message
      [32mv[39m Success!
    Output
      NULL

# meta is single cli_message [unicode]

    Code
      cli_server_default(msgs[[1]])
    Message <cliMessage>
      ℹ First message
      ✔ Success!
    Output
      NULL

# meta is single cli_message [fancy]

    Code
      cli_server_default(msgs[[1]])
    Message <cliMessage>
      [36mℹ[39m First message
      [32m✔[39m Success!
    Output
      NULL

# meta is single cliMessage [plain]

    Code
      withCallingHandlers(cli::cli({
        cli_alert_info("First message")
        cli_alert_success("Success!")
      }), cliMessage = function(msg) {
        msgs <<- c(msgs, list(msg))
      })
    Message <cliMessage>
      i First message
      v Success!

# meta is single cliMessage [ansi]

    Code
      withCallingHandlers(cli::cli({
        cli_alert_info("First message")
        cli_alert_success("Success!")
      }), cliMessage = function(msg) {
        msgs <<- c(msgs, list(msg))
      })
    Message <cliMessage>
      [36mi[39m First message
      [32mv[39m Success!

# meta is single cliMessage [unicode]

    Code
      withCallingHandlers(cli::cli({
        cli_alert_info("First message")
        cli_alert_success("Success!")
      }), cliMessage = function(msg) {
        msgs <<- c(msgs, list(msg))
      })
    Message <cliMessage>
      ℹ First message
      ✔ Success!

# meta is single cliMessage [fancy]

    Code
      withCallingHandlers(cli::cli({
        cli_alert_info("First message")
        cli_alert_success("Success!")
      }), cliMessage = function(msg) {
        msgs <<- c(msgs, list(msg))
      })
    Message <cliMessage>
      [36mℹ[39m First message
      [32m✔[39m Success!

