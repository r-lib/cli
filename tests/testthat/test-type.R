
test_that("type style", {
  expect_snapshot({
    # objects
    cli_text("{.typeof {mtcars}}")
    cli_text("{.typeof {tibble::as_tibble(mtcars)}}")
    cli_text("{.typeof {rlang::quo(1)}}")

    # matrices and arrays
    cli_text("{.typeof {list()}}")
    cli_text("{.typeof {matrix(list(1, 2))}}")
    cli_text("{.typeof {array(list(1, 2, 3))}}")

    cli_text("{.typeof {integer()}}")
    cli_text("{.typeof {matrix(1:3)}}")
    cli_text("{.typeof {array(1:3, dim = 1:3)}}")

    cli_text("{.typeof {character()}}")
    cli_text("{.typeof {matrix(letters)}}")
    cli_text("{.typeof {array(letters[1:3], dim = 1:3)}}")

    # missing arguments
    # this does not actually work in {.typeof} because of the eval rounds
    typename(quote(expr = ))

    # scalars
    cli_text("{.typeof {NA}}")
    cli_text("{.typeof {NA_integer_}}")
    cli_text("{.typeof {NA_real_}}")
    cli_text("{.typeof {NA_complex_}}")
    cli_text("{.typeof {NA_character_}}")

    cli_text("{.typeof {TRUE}}")
    cli_text("{.typeof {FALSE}}")

    cli_text("{.typeof {1L}}")
    cli_text("{.typeof {1.0}}")
    cli_text("{.typeof {1i}}")
    cli_text("{.typeof {as.raw(1L)}}")

    cli_text("{.typeof {'foo'}}")
    cli_text("{.typeof {''}}")

    cli_text("{.typeof {list(1)}}")

    cli_text("{.typeof {matrix(NA)}}")
    cli_text("{.typeof {matrix(1)}}")

    # empty vectors
    cli_text("{.typeof {logical()}}")
    cli_text("{.typeof {integer()}}")
    cli_text("{.typeof {double()}}")
    cli_text("{.typeof {complex()}}")
    cli_text("{.typeof {character()}}")
    cli_text("{.typeof {raw()}}")
    cli_text("{.typeof {list()}}")

    # correct article
    cli_text("{.typeof {structure(1, class = 'igraph')}}")
  })
})
