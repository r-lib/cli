# glue quotes and comments

    Code
      cli_dl(c(test_1 = "all good", test_2 = "not #good"))
    Message <cliMessage>
      test_1: all good
      test_2: not #good
    Code
      cli::cli_text("{.url https://example.com/#section}")
    Message <cliMessage>
      <https://example.com/#section>

# quotes, etc. within expressions are still OK

    Code
      cli::cli_text("{.url URL} {1 + 1 # + 1} {1 + 1}")
    Message <cliMessage>
      <URL> 2 2

