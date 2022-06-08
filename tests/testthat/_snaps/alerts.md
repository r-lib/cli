# generic

    Code
      local({
        cli_div(theme = list(.alert = list(before = "GENERIC! ")))
        cli_alert("wow")
      })
    Message
      GENERIC! wow

# success [plain]

    Code
      local({
        cli_alert_success("wow")
      })
    Message
      v wow

# success [ansi]

    Code
      local({
        cli_alert_success("wow")
      })
    Message
      [32mv[39m wow

# success [unicode]

    Code
      local({
        cli_alert_success("wow")
      })
    Message
      ✔ wow

# success [fancy]

    Code
      local({
        cli_alert_success("wow")
      })
    Message
      [32m✔[39m wow

# danger [plain]

    Code
      local({
        cli_alert_danger("wow")
      })
    Message
      x wow

# danger [ansi]

    Code
      local({
        cli_alert_danger("wow")
      })
    Message
      [31mx[39m wow

# danger [unicode]

    Code
      local({
        cli_alert_danger("wow")
      })
    Message
      ✖ wow

# danger [fancy]

    Code
      local({
        cli_alert_danger("wow")
      })
    Message
      [31m✖[39m wow

# warning [plain]

    Code
      local({
        cli_alert_warning("wow")
      })
    Message
      ! wow

# warning [ansi]

    Code
      local({
        cli_alert_warning("wow")
      })
    Message
      [33m![39m wow

# warning [unicode]

    Code
      local({
        cli_alert_warning("wow")
      })
    Message
      ! wow

# warning [fancy]

    Code
      local({
        cli_alert_warning("wow")
      })
    Message
      [33m![39m wow

# info [plain]

    Code
      local({
        cli_alert_info("wow")
      })
    Message
      i wow

# info [ansi]

    Code
      local({
        cli_alert_info("wow")
      })
    Message
      [36mi[39m wow

# info [unicode]

    Code
      local({
        cli_alert_info("wow")
      })
    Message
      ℹ wow

# info [fancy]

    Code
      local({
        cli_alert_info("wow")
      })
    Message
      [36mℹ[39m wow

# before and after can have spaces

    Code
      local({
        cli_div(theme = list(.alert = list(before = "x  ", after = "  x")))
        cli_alert("continuing that first alert", wrap = TRUE)
      })
    Message
      x  continuing that first alert  x

