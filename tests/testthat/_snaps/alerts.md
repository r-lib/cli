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

# details [plain]

    Code
      local({
        x <- 1:5
        cli_alert("generic", details = c("Note that {x}", "and {.pkg {1:3}}"))
        cli_alert_success("success", details = c("Note that {x}", "and {.pkg {1:3}}"))
        cli_alert_danger("danger", details = c("Note that {x}", "and {.pkg {1:3}}"))
        cli_alert_warning("warning", details = c("Note that {x}", "and {.pkg {1:3}}"))
        cli_alert_info("info", details = c("Note that {x}", "and {.pkg {1:3}}"))
      })
    Message <cliMessage>
      > generic
        Note that 1, 2, 3, 4, and 5
        and 1, 2, and 3
      v success
        Note that 1, 2, 3, 4, and 5
        and 1, 2, and 3
      x danger
        Note that 1, 2, 3, 4, and 5
        and 1, 2, and 3
      ! warning
        Note that 1, 2, 3, 4, and 5
        and 1, 2, and 3
      i info
        Note that 1, 2, 3, 4, and 5
        and 1, 2, and 3

# details [ansi]

    Code
      local({
        x <- 1:5
        cli_alert("generic", details = c("Note that {x}", "and {.pkg {1:3}}"))
        cli_alert_success("success", details = c("Note that {x}", "and {.pkg {1:3}}"))
        cli_alert_danger("danger", details = c("Note that {x}", "and {.pkg {1:3}}"))
        cli_alert_warning("warning", details = c("Note that {x}", "and {.pkg {1:3}}"))
        cli_alert_info("info", details = c("Note that {x}", "and {.pkg {1:3}}"))
      })
    Message <cliMessage>
      > generic
        Note that 1, 2, 3, 4, and 5
        and [34m[34m1[34m[39m, [34m[34m2[34m[39m, and [34m[34m3[34m[39m
      [32mv[39m success
        Note that 1, 2, 3, 4, and 5
        and [34m[34m1[34m[39m, [34m[34m2[34m[39m, and [34m[34m3[34m[39m
      [31mx[39m danger
        Note that 1, 2, 3, 4, and 5
        and [34m[34m1[34m[39m, [34m[34m2[34m[39m, and [34m[34m3[34m[39m
      [33m![39m warning
        Note that 1, 2, 3, 4, and 5
        and [34m[34m1[34m[39m, [34m[34m2[34m[39m, and [34m[34m3[34m[39m
      [36mi[39m info
        Note that 1, 2, 3, 4, and 5
        and [34m[34m1[34m[39m, [34m[34m2[34m[39m, and [34m[34m3[34m[39m

# details [unicode]

    Code
      local({
        x <- 1:5
        cli_alert("generic", details = c("Note that {x}", "and {.pkg {1:3}}"))
        cli_alert_success("success", details = c("Note that {x}", "and {.pkg {1:3}}"))
        cli_alert_danger("danger", details = c("Note that {x}", "and {.pkg {1:3}}"))
        cli_alert_warning("warning", details = c("Note that {x}", "and {.pkg {1:3}}"))
        cli_alert_info("info", details = c("Note that {x}", "and {.pkg {1:3}}"))
      })
    Message <cliMessage>
      → generic
        Note that 1, 2, 3, 4, and 5
        and 1, 2, and 3
      ✔ success
        Note that 1, 2, 3, 4, and 5
        and 1, 2, and 3
      ✖ danger
        Note that 1, 2, 3, 4, and 5
        and 1, 2, and 3
      ! warning
        Note that 1, 2, 3, 4, and 5
        and 1, 2, and 3
      ℹ info
        Note that 1, 2, 3, 4, and 5
        and 1, 2, and 3

# details [fancy]

    Code
      local({
        x <- 1:5
        cli_alert("generic", details = c("Note that {x}", "and {.pkg {1:3}}"))
        cli_alert_success("success", details = c("Note that {x}", "and {.pkg {1:3}}"))
        cli_alert_danger("danger", details = c("Note that {x}", "and {.pkg {1:3}}"))
        cli_alert_warning("warning", details = c("Note that {x}", "and {.pkg {1:3}}"))
        cli_alert_info("info", details = c("Note that {x}", "and {.pkg {1:3}}"))
      })
    Message <cliMessage>
      → generic
        Note that 1, 2, 3, 4, and 5
        and [34m[34m1[34m[39m, [34m[34m2[34m[39m, and [34m[34m3[34m[39m
      [32m✔[39m success
        Note that 1, 2, 3, 4, and 5
        and [34m[34m1[34m[39m, [34m[34m2[34m[39m, and [34m[34m3[34m[39m
      [31m✖[39m danger
        Note that 1, 2, 3, 4, and 5
        and [34m[34m1[34m[39m, [34m[34m2[34m[39m, and [34m[34m3[34m[39m
      [33m![39m warning
        Note that 1, 2, 3, 4, and 5
        and [34m[34m1[34m[39m, [34m[34m2[34m[39m, and [34m[34m3[34m[39m
      [36mℹ[39m info
        Note that 1, 2, 3, 4, and 5
        and [34m[34m1[34m[39m, [34m[34m2[34m[39m, and [34m[34m3[34m[39m

