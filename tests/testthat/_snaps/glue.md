# glue quotes and comments

    Code
      cli_dl(c(test_1 = "all good", test_2 = "not #good"))
    Message <cliMessage>
      test_1: all good
      test_2: not #good
    Code
      cli::cli_dl(c(test_3 = "no' good either"))
    Message <cliMessage>
      test_3: no' good either
    Code
      cli::cli_dl(c(test_4 = "no\" good also"))
    Message <cliMessage>
      test_4: no" good also
    Code
      cli::cli_text("{.url https://example.com/#section}")
    Message <cliMessage>
      <https://example.com/#section>
    Code
      cli::cli_alert_success("Qapla'")
    Message <cliMessage>
      v Qapla'

# quotes, etc. within expressions are still OK

    Code
      cli::cli_text("{.url URL} {x <- 'foo'; nchar(x)}")
    Message <cliMessage>
      <URL> 3
    Code
      cli::cli_text("{.url URL} {x <- \"foo\"; nchar(x)}")
    Message <cliMessage>
      <URL> 3
    Code
      cli::cli_text("{.url URL} {1 + 1 # + 1} {1 + 1}")
    Message <cliMessage>
      <URL> 2 2

