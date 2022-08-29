# type style

    Code
      cli_text("{.typeof {mtcars}}")
    Message
      a data frame
    Code
      cli_text("{.typeof {tibble::as_tibble(mtcars)}}")
    Message
      a tibble
    Code
      cli_text("{.typeof {rlang::quo(1)}}")
    Message
      a <quosure> object
    Code
      cli_text("{.typeof {list()}}")
    Message
      an empty list
    Code
      cli_text("{.typeof {matrix(list(1, 2))}}")
    Message
      a list matrix
    Code
      cli_text("{.typeof {array(list(1, 2, 3))}}")
    Message
      a list
    Code
      cli_text("{.typeof {integer()}}")
    Message
      an empty integer vector
    Code
      cli_text("{.typeof {matrix(1:3)}}")
    Message
      an integer matrix
    Code
      cli_text("{.typeof {array(1:3, dim = 1:3)}}")
    Message
      an integer array
    Code
      cli_text("{.typeof {character()}}")
    Message
      an empty character vector
    Code
      cli_text("{.typeof {matrix(letters)}}")
    Message
      a character matrix
    Code
      cli_text("{.typeof {array(letters[1:3], dim = 1:3)}}")
    Message
      a character array
    Code
      typename(quote(expr = ))
    Output
      [1] "absent"
    Code
      cli_text("{.typeof {NA}}")
    Message
      `NA`
    Code
      cli_text("{.typeof {NA_integer_}}")
    Message
      an integer `NA`
    Code
      cli_text("{.typeof {NA_real_}}")
    Message
      a numeric `NA`
    Code
      cli_text("{.typeof {NA_complex_}}")
    Message
      a complex `NA`
    Code
      cli_text("{.typeof {NA_character_}}")
    Message
      a character `NA`
    Code
      cli_text("{.typeof {TRUE}}")
    Message
      `TRUE`
    Code
      cli_text("{.typeof {FALSE}}")
    Message
      `FALSE`
    Code
      cli_text("{.typeof {1L}}")
    Message
      an integer
    Code
      cli_text("{.typeof {1.0}}")
    Message
      a number
    Code
      cli_text("{.typeof {1i}}")
    Message
      a complex number
    Code
      cli_text("{.typeof {as.raw(1L)}}")
    Message
      a raw value
    Code
      cli_text("{.typeof {'foo'}}")
    Message
      a string
    Code
      cli_text("{.typeof {''}}")
    Message
      `""`
    Code
      cli_text("{.typeof {list(1)}}")
    Message
      a list
    Code
      cli_text("{.typeof {matrix(NA)}}")
    Message
      a logical matrix
    Code
      cli_text("{.typeof {matrix(1)}}")
    Message
      a double matrix
    Code
      cli_text("{.typeof {logical()}}")
    Message
      an empty logical vector
    Code
      cli_text("{.typeof {integer()}}")
    Message
      an empty integer vector
    Code
      cli_text("{.typeof {double()}}")
    Message
      an empty numeric vector
    Code
      cli_text("{.typeof {complex()}}")
    Message
      an empty complex vector
    Code
      cli_text("{.typeof {character()}}")
    Message
      an empty character vector
    Code
      cli_text("{.typeof {raw()}}")
    Message
      an empty raw vector
    Code
      cli_text("{.typeof {list()}}")
    Message
      an empty list
    Code
      cli_text("{.typeof {structure(1, class = 'igraph')}}")
    Message
      an <igraph> object

