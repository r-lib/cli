# text is wrapped

    Code
      local({
        cli_div(class = "testcli", theme = test_style())
        withr::local_options(cli.width = 60)
        withr::local_seed(42)
        cli_h1("Header")
        cli_text(lorem_ipsum())
      })
    Message <cliMessage>
      
      Header
      
      Occaecat est aute labore et. Nulla eiusmod eu proident
      occaecat aliqua minim et ex. Laboris id nostrud amet
      eiusmod ipsum excepteur magna. Ullamco incididunt mollit
      est fugiat nisi do. Ullamco cillum labore aliquip enim duis
      nostrud excepteur amet aliquip. Sunt proident irure est
      esse pariatur.

