# unknown hyperlink type

    Code
      make_link("this", "foobar")
    Condition
      Error in `match.arg()`:
      ! 'arg' should be one of "email", "file", "fun", "help", "href", "run", "topic", "url", "vignette"

# iterm file links

    Code
      cli::cli_text("{.file /path/to/file:10}")
    Message
      ']8;;file:///path/to/file#10/path/to/file:10]8;;'
    Code
      cli::cli_text("{.file /path/to/file:10:20}")
    Message
      ']8;;file:///path/to/file#10:20/path/to/file:10:20]8;;'

# rstudio links

    Code
      cli::cli_text("{.fun pkg::fun}")
    Message
      `]8;;ide:help:pkg::funpkg::fun]8;;()`

---

    Code
      cli::cli_text("{.help fun}")
    Message
      ]8;;ide:help:funfun]8;;

---

    Code
      cli::cli_text("{.run package::func()}")
    Message
      ]8;;ide:run:package::func()package::func()]8;;

---

    Code
      cli::cli_text("{.vignette package::title}")
    Message
      ]8;;ide:vignette:package::titlepackage::title]8;;

---

    Code
      cli::cli_text("{.topic pkg::topic}")
    Message
      ]8;;ide:help:pkg::topicpkg::topic]8;;

# ST hyperlinks

    Code
      cat(style_hyperlink("text", "https://example.com"))
    Output
      ]8;;https://example.com\text]8;;\

# get_config_chr() errors if option is not NULL or string

    Code
      get_config_chr("something")
    Condition
      Error in `get_config_chr()`:
      ! is_string(opt) is not TRUE

