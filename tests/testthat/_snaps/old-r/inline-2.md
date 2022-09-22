# various errors

    Code
      cli_text("xx {__cannot-parse-this__} yy")
    Condition
      Error:
      ! Error while parsing cli `{}` expression: `__cannot-parse-th...`.
      Caused by error:
      ! <text>:1:1: unexpected input
      1: _
          ^

