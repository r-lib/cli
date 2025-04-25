test_that("type style", {
  expect_snapshot({
    # objects
    cli_text("{.obj_type_friendly {mtcars}}")
    cli_text("{.obj_type_friendly {tibble::as_tibble(mtcars)}}")
    cli_text("{.obj_type_friendly {rlang::quo(1)}}")

    # matrices and arrays
    cli_text("{.obj_type_friendly {list()}}")
    cli_text("{.obj_type_friendly {matrix(list(1, 2))}}")
    cli_text("{.obj_type_friendly {array(list(1, 2, 3))}}")

    cli_text("{.obj_type_friendly {integer()}}")
    cli_text("{.obj_type_friendly {matrix(1:3)}}")
    cli_text("{.obj_type_friendly {array(1:3, dim = 1:3)}}")

    cli_text("{.obj_type_friendly {character()}}")
    cli_text("{.obj_type_friendly {matrix(letters)}}")
    cli_text("{.obj_type_friendly {array(letters[1:3], dim = 1:3)}}")

    # missing arguments
    # this does not actually work in {.obj_type_friendly} because of the eval rounds
    typename(quote(expr = ))

    # scalars
    cli_text("{.obj_type_friendly {NA}}")
    cli_text("{.obj_type_friendly {NA_integer_}}")
    cli_text("{.obj_type_friendly {NA_real_}}")
    cli_text("{.obj_type_friendly {NA_complex_}}")
    cli_text("{.obj_type_friendly {NA_character_}}")

    cli_text("{.obj_type_friendly {TRUE}}")
    cli_text("{.obj_type_friendly {FALSE}}")

    cli_text("{.obj_type_friendly {1L}}")
    cli_text("{.obj_type_friendly {1.0}}")
    cli_text("{.obj_type_friendly {1i}}")
    cli_text("{.obj_type_friendly {as.raw(1L)}}")

    cli_text("{.obj_type_friendly {'foo'}}")
    cli_text("{.obj_type_friendly {''}}")

    cli_text("{.obj_type_friendly {list(1)}}")

    cli_text("{.obj_type_friendly {matrix(NA)}}")
    cli_text("{.obj_type_friendly {matrix(1)}}")

    # empty vectors
    cli_text("{.obj_type_friendly {logical()}}")
    cli_text("{.obj_type_friendly {integer()}}")
    cli_text("{.obj_type_friendly {double()}}")
    cli_text("{.obj_type_friendly {complex()}}")
    cli_text("{.obj_type_friendly {character()}}")
    cli_text("{.obj_type_friendly {raw()}}")
    cli_text("{.obj_type_friendly {list()}}")

    # correct article
    cli_text("{.obj_type_friendly {structure(1, class = 'igraph')}}")
  })
})
