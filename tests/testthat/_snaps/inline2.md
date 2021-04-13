# collapsing class names [plain]

    Code
      local({
        cc <- c("one", "two")
        cli_text("this is a class: {.cls myclass}")
        cli_text("multiple classes: {.cls {cc}}")
      })
    Message <cliMessage>
      this is a class: <myclass>
      multiple classes: <one/two>

# collapsing class names [ansi]

    Code
      local({
        cc <- c("one", "two")
        cli_text("this is a class: {.cls myclass}")
        cli_text("multiple classes: {.cls {cc}}")
      })
    Message <cliMessage>
      this is a class: [34m[34m<myclass>[34m[39m
      multiple classes: [34m[34m<one/two>[34m[39m

