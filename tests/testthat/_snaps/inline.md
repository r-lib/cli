# inline classes [plain]

    Code
      invisible(lapply(classes, do))
    Message
      This is <<<it>>> really
      This is <<<it>>> really
      This is <<<it>>> really
      This is <<<it>>> really
      This is <<<it>>> really
      This is <<<it>>> really
      This is <<<it>>> really
      This is <<<it>>> really
      This is <<<it>>> really
      This is <<<it>>> really
      This is <<<it>>> really
      This is <<<it>>> really
      This is <<<it>>> really
      This is <<<it>>> really

# inline classes [ansi]

    Code
      invisible(lapply(classes, do))
    Message
      This is [36m<<<it>>>[39m really
      This is [36m<<<it>>>[39m really
      This is [36m<<<it>>>[39m really
      This is [36m<<<it>>>[39m really
      This is [36m<<<it>>>[39m really
      This is [36m<<<it>>>[39m really
      This is [36m<<<it>>>[39m really
      This is [36m<<<it>>>[39m really
      This is [36m<<<it>>>[39m really
      This is [36m<<<it>>>[39m really
      This is [36m<<<it>>>[39m really
      This is [36m<<<it>>>[39m really
      This is [36m<<<it>>>[39m really
      This is [36m<<<it>>>[39m really

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
    Message
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
    Message
      Message with special characters like } { }} {{
      Message with special characters like } { }} {{

# S3 class is used for styling

    Code
      local({
        cli_div(theme = list(div = list(`class-map` = list(foo = "bar")), .bar = list(
          before = "::")))
        obj <- structure("yep", class = "foo")
        cli_text("This is {obj}.")
      })
    Message
      This is ::yep.

