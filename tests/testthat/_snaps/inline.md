# inline classes

    Code
      invisible(lapply(classes, do))
    Message <cliMessage>
      This is [36m[3m[36m<<<it>>>[36m[23m[39m really
      This is [36m[1m[36m<<<it>>>[36m[22m[39m really
      This is [36m[36m[48;5;235m<<<it>>>[49m[36m[39m really
      This is [36m[36m<<<it>>>[36m[39m really
      This is [36m[36m[48;5;235m<<<it>>>[49m[36m[39m really
      This is [36m[36m[48;5;235m<<<it>>>[49m[36m[39m really
      This is [36m[36m<<<it>>>[36m[39m really
      This is [36m[36m<<<it>>>[36m[39m really
      This is [36m[36m<<<it>>>[36m[39m really
      This is [36m[36m<<<it>>>[36m[39m really
      This is [36m[3m[36m<<<it>>>[36m[23m[39m really
      This is [36m[36m[48;5;235m<<<it>>>[49m[36m[39m really
      This is [36m[36m[48;5;235m<<<it>>>[49m[36m[39m really

# {{ and }} can be used for comments

    Code
      local({
        cli_text("Escaping {{ works")
        cli_text("Escaping }} works")
        cli_text("Escaping {{ and }} works")
        cli_text("Escaping {{{{ works")
        cli_text("Escaping }}}} works")
        cli_text("Escaping {{{{ and }} works")
        cli_text("Escaping {{{{ and }}}} works")
        cli_text("Escaping {{ and }}}} works")
      })
    Message <cliMessage>
      Escaping { works
      Escaping } works
      Escaping { and } works
      Escaping {{ works
      Escaping }} works
      Escaping {{ and } works
      Escaping {{ and }} works
      Escaping { and }} works

# no glue substitution in expressions that evaluate to a string

    Code
      local({
        msg <- "Message with special characters like } { }} {{"
        cli_text("{msg}")
        cli_text("{.emph {msg}}")
      })
    Message <cliMessage>
      Message with special characters like } { }} {{
      Message with special characters like } { }} {{

# S3 class is used for styling

    Code
      local({
        cli_div(theme = list(body = list(`class-map` = list(foo = "bar")), .bar = list(
          before = "::")))
        obj <- structure("yep", class = "foo")
        cli_text("This is {obj}.")
      })
    Message <cliMessage>
      This is ::yep.

# quoting phrases that don't start or end with letter or number

    Code
      local({
        x0 <- "good-name"
        cli_text("The name is {.file {x0}}.")
        x <- "weird-name "
        cli_text("The name is {.file {x}}.")
        cli_text("The name is {.path {x}}.")
        cli_text("The name is {.email {x}}.")
      })
    Message <cliMessage>
      The name is good-name.
      The name is 'weird-name '.
      The name is 'weird-name '.
      The name is 'weird-name '.

