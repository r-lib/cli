# add/remove/list themes

    Code
      cli_par(class = "green")
      cli_text(lorem_ipsum())
    Message <cliMessage>
      [32m[32mEsse ipsum irure exercitation consectetur sunt sint eu minim quis commodo[32m[39m
      [32m[32mcillum. Sunt dolore veniam cillum cupidatat incididunt laboris dolor elit culpa[32m[39m
      [32m[32melit. Duis pariatur culpa id nisi laboris duis incididunt laboris eiusmod velit[32m[39m
      [32m[32meu. Nulla anim anim nulla ullamco irure nostrud incididunt qui magna sint aute[32m[39m
      [32m[32mad nulla anim. Incididunt proident aliquip do aliqua sint deserunt irure quis[32m[39m
      [32m[32msint elit. Minim pariatur ad pariatur ex occaecat quis esse aliqua[32m[39m
      [32m[32mreprehenderit in do aute elit. Consectetur sunt mollit labore aliquip voluptate[32m[39m
      [32m[32mofficia mollit in ex esse.[32m[39m
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

