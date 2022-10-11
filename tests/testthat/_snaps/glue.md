# glue quotes and comments

    Code
      cli_dl(c(test_1 = "all good", test_2 = "not #good"))
    Message
      test_1: all good
      test_2: not #good
    Code
      cli::cli_dl(c(test_3 = "no' good either"))
    Message
      test_3: no' good either
    Code
      cli::cli_dl(c(test_4 = "no\" good also"))
    Message
      test_4: no" good also
    Code
      cli::cli_text("{.url https://example.com/#section}")
    Message
      <https://example.com/#section>
    Code
      cli::cli_alert_success("Qapla'")
    Message
      v Qapla'

# quotes, etc. within expressions are still OK

    Code
      cli::cli_text("{.url URL} {x <- 'foo'; nchar(x)}")
    Message
      <URL> 3
    Code
      cli::cli_text("{.url URL} {x <- \"foo\"; nchar(x)}")
    Message
      <URL> 3
    Code
      cli::cli_text("{.url URL} {1 + 1 # + 1} {1 + 1}")
    Message
      <URL> 2 2

# { } is parsed with literal = FALSE

    Code
      format_message("{.emph {'{foo {}'}}")
    Output
      [1] "{foo {}"

