
start_app()
on.exit(stop_app(), add = TRUE)

test_that_cli("issue #154", {
  expect_snapshot({
    cli_code("a\nb\nc")
  })
})

test_that_cli("Jenny's problem", {
  cli_code_wrapper <- function(x, .envir = parent.frame()) {
    x <- glue::glue(x, .envir = .envir)
    cli_code(x, .envir = .envir) # <- passing .envir along is problematic
  }

  true_val <- "TRUE"
  false_val <- "'FALSE'"
  expect_snapshot(cli_code_wrapper("if (1) {true_val} else {false_val}"))
})
