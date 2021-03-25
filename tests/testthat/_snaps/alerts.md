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

# danger [plain]

    Code
      local({
        cli_alert_danger("wow")
      })
    Message <cliMessage>
      x wow

# danger [ansi]

    Code
      local({
        cli_alert_danger("wow")
      })
    Message <cliMessage>
      [31mx[39m wow

# danger [unicode]

    Code
      local({
        cli_alert_danger("wow")
      })
    Message <cliMessage>
      ✖ wow

# danger [fancy]

    Code
      local({
        cli_alert_danger("wow")
      })
    Message <cliMessage>
      [31m✖[39m wow

# warning [plain]

    Code
      local({
        cli_alert_warning("wow")
      })
    Message <cliMessage>
      ! wow

# warning [ansi]

    Code
      local({
        cli_alert_warning("wow")
      })
    Message <cliMessage>
      [33m![39m wow

# warning [unicode]

    Code
      local({
        cli_alert_warning("wow")
      })
    Message <cliMessage>
      ! wow

# warning [fancy]

    Code
      local({
        cli_alert_warning("wow")
      })
    Message <cliMessage>
      [33m![39m wow

# info [plain]

    Code
      local({
        cli_alert_info("wow")
      })
    Message <cliMessage>
      i wow

# info [ansi]

    Code
      local({
        cli_alert_info("wow")
      })
    Message <cliMessage>
      [36mi[39m wow

# info [unicode]

    Code
      local({
        cli_alert_info("wow")
      })
    Message <cliMessage>
      ℹ wow

# info [fancy]

    Code
      local({
        cli_alert_info("wow")
      })
    Message <cliMessage>
      [36mℹ[39m wow

# before and after can have spaces

    Code
      local({
        cli_div(theme = list(.alert = list(before = "x  ", after = "  x")))
        cli_alert("continuing that first alert", wrap = TRUE)
      })
    Message <cliMessage>
      x  continuing that first alert  x

