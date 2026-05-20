# is_ansi_tty() rejects invalid cli.ansi option values

    Code
      is_ansi_tty()
    Condition
      Error:
      ! ! Invalid value for option 'cli.ansi'
      i Expected TRUE or FALSE, got a string.

---

    Code
      is_ansi_tty()
    Condition
      Error:
      ! ! Invalid value for option 'cli.ansi'
      i Expected TRUE or FALSE, got `NA`.

---

    Code
      is_ansi_tty()
    Condition
      Error:
      ! ! Invalid value for option 'cli.ansi'
      i Expected TRUE or FALSE, got a number.

# is_ansi_tty() rejects invalid R_CLI_ANSI values

    Code
      is_ansi_tty()
    Condition
      Error:
      ! ! Invalid value for environment variable 'R_CLI_ANSI'
      i Expected one of "true" or "false", got maybe.

