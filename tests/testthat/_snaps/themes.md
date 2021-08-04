# add/remove/list themes [plain]

    Code
      cli_par(class = "green")
      cli_text(lorem_ipsum())
    Message <cliMessage>
      Non incididunt mollit ullamco duis officia proident. Laborum esse mollit mollit
      eiusmod tempor cupidatat. In commodo anim irure nostrud. Deserunt nisi amet
      laborum magna aliqua. Do esse consectetur ut deserunt nulla Lorem non. Fugiat
      est dolore deserunt aliqua amet et esse dolore elit exercitation sint
      exercitation non ipsum.
    Code
      cli_end()
    Message <cliMessage>
      

# add/remove/list themes [ansi]

    Code
      cli_par(class = "green")
      cli_text(lorem_ipsum())
    Message <cliMessage>
      [32mNon incididunt mollit ullamco duis officia proident. Laborum esse mollit mollit[39m
      [32meiusmod tempor cupidatat. In commodo anim irure nostrud. Deserunt nisi amet[39m
      [32mlaborum magna aliqua. Do esse consectetur ut deserunt nulla Lorem non. Fugiat[39m
      [32mest dolore deserunt aliqua amet et esse dolore elit exercitation sint[39m
      [32mexercitation non ipsum.[39m
    Code
      cli_end()
    Message <cliMessage>
      

# add/remove/list themes [unicode]

    Code
      cli_par(class = "green")
      cli_text(lorem_ipsum())
    Message <cliMessage>
      Non incididunt mollit ullamco duis officia proident. Laborum esse mollit mollit
      eiusmod tempor cupidatat. In commodo anim irure nostrud. Deserunt nisi amet
      laborum magna aliqua. Do esse consectetur ut deserunt nulla Lorem non. Fugiat
      est dolore deserunt aliqua amet et esse dolore elit exercitation sint
      exercitation non ipsum.
    Code
      cli_end()
    Message <cliMessage>
      

# add/remove/list themes [fancy]

    Code
      cli_par(class = "green")
      cli_text(lorem_ipsum())
    Message <cliMessage>
      [32mNon incididunt mollit ullamco duis officia proident. Laborum esse mollit mollit[39m
      [32meiusmod tempor cupidatat. In commodo anim irure nostrud. Deserunt nisi amet[39m
      [32mlaborum magna aliqua. Do esse consectetur ut deserunt nulla Lorem non. Fugiat[39m
      [32mest dolore deserunt aliqua amet et esse dolore elit exercitation sint[39m
      [32mexercitation non ipsum.[39m
    Code
      cli_end()
    Message <cliMessage>
      

# explicit formatter is used, and combined

    Code
      cli_text("this is {.emph it}, really")
    Message <cliMessage>
      this is (((<<it>>))), really

# user's override

    Code
      local({
        start_app(theme = custom, .auto_close = FALSE)
        cli_alert("Alert!")
        stop_app()
        withr::local_options(cli.user_theme = override)
        start_app(theme = custom, .auto_close = FALSE)
        cli_alert("Alert!")
        stop_app()
      })
    Message <cliMessage>
      custom:Alert!
      custom:Alert!override:

# NULL will undo a style property

    Code
      local({
        cli_alert("this has an arrow")
        cli_div(theme = list(.alert = list(before = NULL)))
        cli_alert("this does not")
      })
    Message <cliMessage>
      > this has an arrow
      this does not

# NULL will undo color [ansi]

    Code
      local({
        cli_alert("{.emph {.val this is blue}}")
        cli_div(theme = list(span.val = list(color = NULL)))
        cli_alert("{.emph {.val this is not}}")
      })
    Message <cliMessage>
      > [34m[3m[34m"this is blue"[34m[23m[39m
      > [0m[22m[23m[24m[27m[28m[29m[49m[3m[0m[22m[3m[24m[27m[28m[29m[49m"this is not"[0m[22m[23m[24m[27m[28m[29m[49m[23m[39m

---

    Code
      local({
        cli_alert("{.emph {.val this is blue}}")
        cli_div(theme = list(span.val = list(color = "none")))
        cli_alert("{.emph {.val this is not}}")
      })
    Message <cliMessage>
      > [34m[3m[34m"this is blue"[34m[23m[39m
      > [0m[22m[23m[24m[27m[28m[29m[49m[3m[0m[22m[3m[24m[27m[28m[29m[49m"this is not"[0m[22m[23m[24m[27m[28m[29m[49m[23m[39m

# NULL will undo background color [ansi]

    Code
      local({
        cli_alert("{.emph {.code this has bg color}}")
        cli_div(theme = list(span = list(`background-color` = NULL)))
        cli_alert("{.emph {.code this does not}}")
      })
    Message <cliMessage>
      > [38;5;235m[48;5;253m[3m[38;5;235m[48;5;253m`this has bg color`[48;5;253m[38;5;235m[23m[49m[39m
      > [0m[22m[23m[24m[27m[28m[29m[39m[3m[38;5;235m[0m[22m[3m[24m[27m[28m[29m[38;5;235m`this does not`[0m[22m[23m[24m[27m[28m[29m[39m[39m[23m[49m

---

    Code
      local({
        cli_alert("{.emph {.code this has bg color}}")
        cli_div(theme = list(span = list(`background-color` = "none")))
        cli_alert("{.emph {.code this does not}}")
      })
    Message <cliMessage>
      > [38;5;235m[48;5;253m[3m[38;5;235m[48;5;253m`this has bg color`[48;5;253m[38;5;235m[23m[49m[39m
      > [0m[22m[23m[24m[27m[28m[29m[39m[3m[38;5;235m[0m[22m[3m[24m[27m[28m[29m[38;5;235m`this does not`[0m[22m[23m[24m[27m[28m[29m[39m[39m[23m[49m

