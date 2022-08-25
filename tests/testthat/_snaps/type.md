# type style

    Code
      cli_text("{.type {mtcars}}")
    Message
      a <data.frame> object
    Code
      cli_text("{.type {tibble::as_tibble(mtcars)}}")
    Message
      a <tbl_df/tbl/data.frame> object
    Code
      cli_text("{.type {rlang::quo(1)}}")
    Message
      a <quosure> object
    Code
      cli_text("{.type {list()}}")
    Message
      an empty list
    Code
      cli_text("{.type {matrix(list(1, 2))}}")
    Message
      a list matrix
    Code
      cli_text("{.type {array(list(1, 2, 3))}}")
    Message
      a list
    Code
      cli_text("{.type {integer()}}")
    Message
      an empty integer vector
    Code
      cli_text("{.type {matrix(1:3)}}")
    Message
      an integer matrix
    Code
      cli_text("{.type {array(1:3, dim = 1:3)}}")
    Message
      an integer array
    Code
      cli_text("{.type {character()}}")
    Message
      an empty character vector
    Code
      cli_text("{.type {matrix(letters)}}")
    Message
      a character matrix
    Code
      cli_text("{.type {array(letters[1:3], dim = 1:3)}}")
    Message
      a character array
    Code
      typename(quote(expr = ))
    Output
      [1] "absent"
    Code
      cli_text("{.type {NA}}")
    Message
      `NA`
    Code
      cli_text("{.type {NA_integer_}}")
    Message
      an integer `NA`
    Code
      cli_text("{.type {NA_real_}}")
    Message
      a numeric `NA`
    Code
      cli_text("{.type {NA_complex_}}")
    Message
      a complex `NA`
    Code
      cli_text("{.type {NA_character_}}")
    Message
      a character `NA`
    Code
      cli_text("{.type {TRUE}}")
    Message
      `TRUE`
    Code
      cli_text("{.type {FALSE}}")
    Message
      `FALSE`
    Code
      cli_text("{.type {1L}}")
    Message
      an integer
    Code
      cli_text("{.type {1.0}}")
    Message
      a number
    Code
      cli_text("{.type {1i}}")
    Message
      a complex number
    Code
      cli_text("{.type {as.raw(1L)}}")
    Message
      a raw value
    Code
      cli_text("{.type {'foo'}}")
    Message
      a string
    Code
      cli_text("{.type {''}}")
    Message
      `""`
    Code
      cli_text("{.type {list(1)}}")
    Message
      a list
    Code
      cli_text("{.type {matrix(NA)}}")
    Message
      a logical matrix
    Code
      cli_text("{.type {matrix(1)}}")
    Message
      a double matrix
    Code
      cli_text("{.type {logical()}}")
    Message
      an empty logical vector
    Code
      cli_text("{.type {integer()}}")
    Message
      an empty integer vector
    Code
      cli_text("{.type {double()}}")
    Message
      an empty numeric vector
    Code
      cli_text("{.type {complex()}}")
    Message
      an empty complex vector
    Code
      cli_text("{.type {character()}}")
    Message
      an empty character vector
    Code
      cli_text("{.type {raw()}}")
    Message
      an empty raw vector
    Code
      cli_text("{.type {list()}}")
    Message
      an empty list
    Code
      cli_text("{.type {structure(1, class = 'igraph')}}")
    Message
      an <igraph> object

