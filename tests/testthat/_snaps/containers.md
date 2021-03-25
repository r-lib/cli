# auto closing

    Code
      local({
        cli_div(theme = list(`.xx .emph` = list(before = "itsu:")))
        f <- (function() {
          cli_par(class = "xx")
          cli_text("foo {.emph blah} bar")
        })
        f()
        cli_text("foo {.emph blah} bar")
      })
    Message <cliMessage>
      foo itsu:blah bar
      
      foo blah bar

# opt out of auto closing

    Code
      local({
        cli_div(theme = list(`.xx .emph` = list(before = "itsu:")))
        id <- NULL
        f <- (function() {
          id <<- cli_par(class = "xx", .auto_close = FALSE)
          cli_text("foo {.emph blah} bar")
        })
        f()
        cli_text("foo {.emph blah} bar")
        expect_false(is.null(id))
        cli_end(id)
        cli_text("foo {.emph blah} bar")
      })
    Message <cliMessage>
      foo itsu:blah bar
      foo itsu:blah bar
      
      foo blah bar

# auto closing with special env

    Code
      local({
        cli_div(theme = list(`.xx .emph` = list(before = "itsu:")))
        f <- (function() {
          g()
          cli_text("foo {.emph blah} bar")
        })
        g <- (function() {
          cli_par(class = "xx", .auto_close = TRUE, .envir = parent.frame())
          cli_text("foo {.emph blah} bar")
        })
        f()
        cli_text("foo {.emph blah} bar")
      })
    Message <cliMessage>
      foo itsu:blah bar
      foo itsu:blah bar
      
      foo blah bar

# div with special style

    Code
      f <- (function() {
        cli_div(theme = list(`.xx .emph` = list(before = "itsu:")))
        cli_par(class = "xx")
        cli_text("foo {.emph blah} bar")
      })
      f()
    Message <cliMessage>
      foo itsu:blah bar
      
    Code
      cli_text("foo {.emph blah} bar")
    Message <cliMessage>
      foo blah bar

# margin is squashed

    Code
      local({
        cli_div(theme = list(par = list(`margin-top` = 4, `margin-bottom` = 4)))
        cli_text("three lines")
        cli_par()
        cli_par()
        cli_par()
        cli_text("until here")
        cli_end()
        cli_end()
        cli_end()
        cli_par()
        cli_par()
        cli_par()
        cli_text("no space, still")
        cli_end()
        cli_end()
        cli_end()
        cli_text("three lines again")
      })
    Message <cliMessage>
      three lines
      
      
      
      until here
      
      
      
      no space, still
      
      
      
      three lines again

# before and after work properly

    Code
      local({
        cli_div(theme = list(`div.alert-success` = list(before = "!!!")))
        cli_alert_success("{.pkg foobar} is good")
      })
    Message <cliMessage>
      !!!foobar is good

