# glue errors

    Code
      cli_h1("foo { asdfasdfasdf } bar")
    Condition
      Error:
      ! ! Could not evaluate cli `{}` expression: ` asdfasdfasdf `.
      Caused by error in `eval(expr, envir = envir)` at inline.R:323:7:
      ! object 'asdfasdfasdf' not found
    Code
      cli_text("foo {cmd {dsfsdf()}}")
    Condition
      Error:
      ! ! Could not parse cli `{}` expression: `cmd {dsfsdf()}`.
      Caused by error in `parse(text = code, keep.source = FALSE)` at inline.R:317:7:
      ! <text>:1:5: unexpected '{'
      1: cmd {
              ^

