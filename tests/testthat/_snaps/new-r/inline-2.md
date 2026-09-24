# various errors

    Code
      cli_text("xx {__cannot-parse-this__} yy")
    Condition
      Error:
      ! ! Could not parse cli `{}` expression: `__cannot-parse-th...`.
      Caused by error in `parse(text = code, keep.source = FALSE)`:
      ! <text>:1:2: unexpected input
      1: __
           ^

