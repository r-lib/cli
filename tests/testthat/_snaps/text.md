# text is wrapped

    Code
      local({
        cli_div(class = "testcli", theme = test_style())
        withr::local_options(cli.width = 60)
        withr::local_rng_version("3.5.0")
        withr::local_seed(42)
        cli_h1("Header")
        cli_text(lorem_ipsum())
      })
    Message <cliMessage>
      
      Header
      
      Non exercitation nostrud ullamco dolor exercitation ut
      veniam cillum fugiat irure tempor. Voluptate ut anim in et
      tempor. Quis nulla qui et nisi ad quis ad cupidatat.
      Laborum est excepteur aliqua veniam ex velit sunt magna
      veniam Lorem elit enim et. Aliqua occaecat mollit consequat
      dolore in mollit veniam officia labore reprehenderit culpa
      dolore.

