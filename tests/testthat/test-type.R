
test_that("type style", {
  expect_snapshot({
    # objects
    cli_text("{.type {mtcars}}")
    cli_text("{.type {tibble::as_tibble(mtcars)}}")
    cli_text("{.type {rlang::quo(1)}}")

    # matrices and arrays
    cli_text("{.type {list()}}")
    cli_text("{.type {matrix(list(1, 2))}}")
    cli_text("{.type {array(list(1, 2, 3))}}")

    cli_text("{.type {integer()}}")
    cli_text("{.type {matrix(1:3)}}")
    cli_text("{.type {array(1:3, dim = 1:3)}}")

    cli_text("{.type {character()}}")
    cli_text("{.type {matrix(letters)}}")
    cli_text("{.type {array(letters[1:3], dim = 1:3)}}")

    # missing arguments
    # this does not actually work in {.type} because of the eval rounds
    typename(quote(expr = ))

    # scalars
    cli_text("{.type {NA}}")
    cli_text("{.type {NA_integer_}}")
    cli_text("{.type {NA_real_}}")
    cli_text("{.type {NA_complex_}}")
    cli_text("{.type {NA_character_}}")

    cli_text("{.type {TRUE}}")
    cli_text("{.type {FALSE}}")

    cli_text("{.type {1L}}")
    cli_text("{.type {1.0}}")
    cli_text("{.type {1i}}")
    cli_text("{.type {as.raw(1L)}}")

    cli_text("{.type {'foo'}}")
    cli_text("{.type {''}}")

    cli_text("{.type {list(1)}}")

    cli_text("{.type {matrix(NA)}}")
    cli_text("{.type {matrix(1)}}")

    # empty vectors
    cli_text("{.type {logical()}}")
    cli_text("{.type {integer()}}")
    cli_text("{.type {double()}}")
    cli_text("{.type {complex()}}")
    cli_text("{.type {character()}}")
    cli_text("{.type {raw()}}")
    cli_text("{.type {list()}}")

    # correct article
    cli_text("{.type {structure(1, class = 'igraph')}}")
  })
})
