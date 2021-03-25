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
      [32m[32mNon incididunt mollit ullamco duis officia proident. Laborum esse mollit mollit[32m[39m
      [32m[32meiusmod tempor cupidatat. In commodo anim irure nostrud. Deserunt nisi amet[32m[39m
      [32m[32mlaborum magna aliqua. Do esse consectetur ut deserunt nulla Lorem non. Fugiat[32m[39m
      [32m[32mest dolore deserunt aliqua amet et esse dolore elit exercitation sint[32m[39m
      [32m[32mexercitation non ipsum.[32m[39m
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
      [32m[32mNon incididunt mollit ullamco duis officia proident. Laborum esse mollit mollit[32m[39m
      [32m[32meiusmod tempor cupidatat. In commodo anim irure nostrud. Deserunt nisi amet[32m[39m
      [32m[32mlaborum magna aliqua. Do esse consectetur ut deserunt nulla Lorem non. Fugiat[32m[39m
      [32m[32mest dolore deserunt aliqua amet et esse dolore elit exercitation sint[32m[39m
      [32m[32mexercitation non ipsum.[32m[39m
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

