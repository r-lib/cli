# meta basics [plain]

    Code
      cli::cli({
        message("This is before")
        cli_alert_info("First message")
        message("This as well")
        cli_alert_success("Success!")
      })
    Message
      This is before
      This as well
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
    Message
      This is before
      This as well
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
    Message
      This is before
      This as well
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
    Message
      This is before
      This as well
      [36mℹ[39m First message
      [32m✔[39m Success!

# meta is single cli_message [plain]

    Code
      cli_server_default(msgs[[1]])
    Message
      i First message
      v Success!
    Output
      NULL

# meta is single cli_message [ansi]

    Code
      cli_server_default(msgs[[1]])
    Message
      [36mi[39m First message
      [32mv[39m Success!
    Output
      NULL

# meta is single cli_message [unicode]

    Code
      cli_server_default(msgs[[1]])
    Message
      ℹ First message
      ✔ Success!
    Output
      NULL

# meta is single cli_message [fancy]

    Code
      cli_server_default(msgs[[1]])
    Message
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
    Message
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
    Message
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
    Message
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
    Message
      [36mℹ[39m First message
      [32m✔[39m Success!

# substitution [plain]

    Code
      local({
        x <- 1:3
        cli({
          title <- "My title"
          cli_h1("Title: {.emph {title}}")
          cli_text("And {.emph some} more: {.val {x}}")
        })
      })
    Message
      
      -- Title: My title -------------------------------------------------------------
      And some more: 1, 2, and 3

# substitution [ansi]

    Code
      local({
        x <- 1:3
        cli({
          title <- "My title"
          cli_h1("Title: {.emph {title}}")
          cli_text("And {.emph some} more: {.val {x}}")
        })
      })
    Message
      
      [36m--[39m [1mTitle: [3mMy title[23m[22m [36m-------------------------------------------------------------[39m
      And [3msome[23m more: [34m1[39m, [34m2[39m, and [34m3[39m

# substitution [unicode]

    Code
      local({
        x <- 1:3
        cli({
          title <- "My title"
          cli_h1("Title: {.emph {title}}")
          cli_text("And {.emph some} more: {.val {x}}")
        })
      })
    Message
      
      ── Title: My title ─────────────────────────────────────────────────────────────
      And some more: 1, 2, and 3

# substitution [fancy]

    Code
      local({
        x <- 1:3
        cli({
          title <- "My title"
          cli_h1("Title: {.emph {title}}")
          cli_text("And {.emph some} more: {.val {x}}")
        })
      })
    Message
      
      [36m──[39m [1mTitle: [3mMy title[23m[22m [36m─────────────────────────────────────────────────────────────[39m
      And [3msome[23m more: [34m1[39m, [34m2[39m, and [34m3[39m

# return values are ok when recording (#496)

    Code
      cli::cli({
        lid <- cli::cli_ul()
        cli::cli_li("a bullet")
        cli::cli_end(lid)
      })
    Message
      * a bullet

# nested cli() (#497)

    Code
      cli::cli({
        cli::cli_h1("Header")
        cli::cli(cli::cli_text("Some text"))
        cli::cli_text("Some more text")
      })
    Message
      
      -- Header ----------------------------------------------------------------------
      Some text
      Some more text

