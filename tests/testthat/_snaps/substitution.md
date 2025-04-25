# glue errors

    Code
      cli_h1("foo { asdfasdfasdf } bar")
    Condition
      Error:
      ! Could not evaluate cli `{}` expression: ` asdfasdfasdf `.
      Caused by error:
      ! object 'asdfasdfasdf' not found
    Code
      cli_text("foo {cmd {dsfsdf()}}")
    Condition
      Error:
      ! Could not parse cli `{}` expression: `cmd {dsfsdf()}`.
      Caused by error:
      ! <text>:1:5: unexpected '{'
      1: cmd {
              ^

