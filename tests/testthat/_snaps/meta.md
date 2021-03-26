# meta

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

