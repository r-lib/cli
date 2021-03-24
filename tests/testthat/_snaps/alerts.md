# generic

    Code
      local({
        cli_div(theme = list(.alert = list(before = "GENERIC! ")))
        cli_alert("wow")
      })
    Message <cliMessage>
      GENERIC! wow

# success

    Code
      local({
        cli_div(theme = list(`.alert-success` = list(before = "SUCCESS! ")))
        cli_alert_success("wow")
      })
    Message <cliMessage>
      SUCCESS! wow

# danger

    Code
      local({
        cli_div(theme = list(`.alert-danger` = list(before = "DANGER! ")))
        cli_alert_danger("wow")
      })
    Message <cliMessage>
      DANGER! wow

# warning

    Code
      local({
        cli_div(theme = list(`.alert-warning` = list(before = "WARNING! ")))
        cli_alert_warning("wow")
      })
    Message <cliMessage>
      WARNING! wow

# info

    Code
      local({
        cli_div(theme = list(`.alert-info` = list(before = "INFO! ")))
        cli_alert_info("wow")
      })
    Message <cliMessage>
      INFO! wow

