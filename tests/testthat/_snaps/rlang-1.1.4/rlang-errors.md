# cli_abort() captures correct call and backtrace

    Code
      print(expect_error(f()))
    Output
      <error/rlang_error>
      Error in `h()`:
      ! foo
      ---
      Backtrace:
           x
        1. +-base::print(expect_error(f()))
        2. +-testthat::expect_error(f())
        3. | \-testthat:::expect_condition_matching(...)
        4. |   \-testthat:::quasi_capture(...)
        5. |     +-testthat (local) .capture(...)
        6. |     | \-base::withCallingHandlers(...)
        7. |     \-rlang::eval_bare(quo_get_expr(.quo), quo_get_env(.quo))
        8. \-cli (local) f()
        9.   \-cli (local) g()
       10.     \-cli (local) h()

---

    Code
      print(expect_error(f(list())))
    Output
      <error/cli_my_class>
      Error in `h()`:
      ! `x` can't be empty.
      ---
      Backtrace:
           x
        1. +-base::print(expect_error(f(list())))
        2. +-testthat::expect_error(f(list()))
        3. | \-testthat:::expect_condition_matching(...)
        4. |   \-testthat:::quasi_capture(...)
        5. |     +-testthat (local) .capture(...)
        6. |     | \-base::withCallingHandlers(...)
        7. |     \-rlang::eval_bare(quo_get_expr(.quo), quo_get_env(.quo))
        8. \-cli (local) f(list())
        9.   \-cli (local) g(x)
       10.     \-cli (local) h(x)

# cli_abort(.internal = TRUE) reports the correct function (r-lib/rlang#1386)

    Code
      (expect_error(fn()))
    Output
      <error/rlang_error>
      Error in `fn()`:
      ! Message.
      i This is an internal error that was detected in the base package.

