# type style

    Code
      cli_text("{.obj_type_friendly {mtcars}}")
    Message
      a data frame
    Code
      cli_text("{.obj_type_friendly {tibble::as_tibble(mtcars)}}")
    Message
      a tibble
    Code
      cli_text("{.obj_type_friendly {rlang::quo(1)}}")
    Message
      a <quosure> object
    Code
      cli_text("{.obj_type_friendly {list()}}")
    Message
      an empty list
    Code
      cli_text("{.obj_type_friendly {matrix(list(1, 2))}}")
    Message
      a list matrix
    Code
      cli_text("{.obj_type_friendly {array(list(1, 2, 3))}}")
    Message
      a list
    Code
      cli_text("{.obj_type_friendly {integer()}}")
    Message
      an empty integer vector
    Code
      cli_text("{.obj_type_friendly {matrix(1:3)}}")
    Message
      an integer matrix
    Code
      cli_text("{.obj_type_friendly {array(1:3, dim = 1:3)}}")
    Message
      an integer array
    Code
      cli_text("{.obj_type_friendly {character()}}")
    Message
      an empty character vector
    Code
      cli_text("{.obj_type_friendly {matrix(letters)}}")
    Message
      a character matrix
    Code
      cli_text("{.obj_type_friendly {array(letters[1:3], dim = 1:3)}}")
    Message
      a character array
    Code
      typename(quote(expr = ))
    Output
      [1] "absent"
    Code
      cli_text("{.obj_type_friendly {NA}}")
    Message
      `NA`
    Code
      cli_text("{.obj_type_friendly {NA_integer_}}")
    Message
      an integer `NA`
    Code
      cli_text("{.obj_type_friendly {NA_real_}}")
    Message
      a numeric `NA`
    Code
      cli_text("{.obj_type_friendly {NA_complex_}}")
    Message
      a complex `NA`
    Code
      cli_text("{.obj_type_friendly {NA_character_}}")
    Message
      a character `NA`
    Code
      cli_text("{.obj_type_friendly {TRUE}}")
    Message
      `TRUE`
    Code
      cli_text("{.obj_type_friendly {FALSE}}")
    Message
      `FALSE`
    Code
      cli_text("{.obj_type_friendly {1L}}")
    Message
      an integer
    Code
      cli_text("{.obj_type_friendly {1.0}}")
    Message
      a number
    Code
      cli_text("{.obj_type_friendly {1i}}")
    Message
      a complex number
    Code
      cli_text("{.obj_type_friendly {as.raw(1L)}}")
    Message
      a raw value
    Code
      cli_text("{.obj_type_friendly {'foo'}}")
    Message
      a string
    Code
      cli_text("{.obj_type_friendly {''}}")
    Message
      `""`
    Code
      cli_text("{.obj_type_friendly {list(1)}}")
    Message
      a list
    Code
      cli_text("{.obj_type_friendly {matrix(NA)}}")
    Message
      a logical matrix
    Code
      cli_text("{.obj_type_friendly {matrix(1)}}")
    Message
      a double matrix
    Code
      cli_text("{.obj_type_friendly {logical()}}")
    Message
      an empty logical vector
    Code
      cli_text("{.obj_type_friendly {integer()}}")
    Message
      an empty integer vector
    Code
      cli_text("{.obj_type_friendly {double()}}")
    Message
      an empty numeric vector
    Code
      cli_text("{.obj_type_friendly {complex()}}")
    Message
      an empty complex vector
    Code
      cli_text("{.obj_type_friendly {character()}}")
    Message
      an empty character vector
    Code
      cli_text("{.obj_type_friendly {raw()}}")
    Message
      an empty raw vector
    Code
      cli_text("{.obj_type_friendly {list()}}")
    Message
      an empty list
    Code
      cli_text("{.obj_type_friendly {structure(1, class = 'igraph')}}")
    Message
      an <igraph> object

