# headers [plain]

    Code
      local({
        cli_div(class = "testcli", theme = test_style())
        cli_h1("HEADER")
        cli_h2("Header")
        cli_h3("Header")
        x <- "foobar"
        xx <- 100
        cli_h2("{xx}. header: {x}")
      })
    Message <cliMessage>
      
      HEADER
      
      Header
      
      Header
      
      100. header: foobar
      

# headers [ansi]

    Code
      local({
        cli_div(class = "testcli", theme = test_style())
        cli_h1("HEADER")
        cli_h2("Header")
        cli_h3("Header")
        x <- "foobar"
        xx <- 100
        cli_h2("{xx}. header: {x}")
      })
    Message <cliMessage>
      [1m[3m[1m[3mHEADER[3m[1m[23m[22m
      
      [1m[1mHeader[1m[22m
      
      [4m[4mHeader[4m[24m
      
      [1m[1m[1m100[1m. header: [1mfoobar[1m[1m[22m
      

# headers [unicode]

    Code
      local({
        cli_div(class = "testcli", theme = test_style())
        cli_h1("HEADER")
        cli_h2("Header")
        cli_h3("Header")
        x <- "foobar"
        xx <- 100
        cli_h2("{xx}. header: {x}")
      })
    Message <cliMessage>
      HEADER
      
      Header
      
      Header
      
      100. header: foobar
      

# headers [fancy]

    Code
      local({
        cli_div(class = "testcli", theme = test_style())
        cli_h1("HEADER")
        cli_h2("Header")
        cli_h3("Header")
        x <- "foobar"
        xx <- 100
        cli_h2("{xx}. header: {x}")
      })
    Message <cliMessage>
      [1m[3m[1m[3mHEADER[3m[1m[23m[22m
      
      [1m[1mHeader[1m[22m
      
      [4m[4mHeader[4m[24m
      
      [1m[1m[1m100[1m. header: [1mfoobar[1m[1m[22m
      

# issue #218

    Code
      cli_h1("one {1} two {2} three {3}")
    Message <cliMessage>
      -- one 1 two 2 three 3 ---------------------------------------------------------
    Code
      cli_h2("one {1} two {2} three {3}")
    Message <cliMessage>
      
      -- one 1 two 2 three 3 --
      

