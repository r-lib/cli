# generic

    Code
      local({
        cli_div(theme = list(.alert = list(before = "GENERIC! ")))
        cli_alert("wow")
      })
    Message <cliMessage>
      GENERIC! wow

# success [plain]

    Code
      local({
        cli_alert_success("wow")
      })
    Message <cliMessage>
      v wow

# success [ansi]

    Code
      local({
        cli_alert_success("wow")
      })
    Message <cliMessage>
      [32mv[39m wow

# success [unicode]

    Code
      local({
        cli_alert_success("wow")
      })
    Message <cliMessage>
      ✔ wow

# success [fancy]

    Code
      local({
        cli_alert_success("wow")
      })
    Message <cliMessage>
      [32m✔[39m wow

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

