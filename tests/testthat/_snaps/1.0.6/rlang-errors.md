# cli_abort(.internal = TRUE) reports the correct function (r-lib/rlang#1386)

    Code
      (expect_error(fn()))
    Output
      <error/rlang_error>
      Error in `fn()`:
      ! Message.
      i This is an internal error that was detected in the base package.

