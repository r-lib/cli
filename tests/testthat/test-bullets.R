start_app()
on.exit(stop_app(), add = TRUE)

test_that_cli("bullets", {
  expect_snapshot(cli_bullets(c(
    "noindent",
    " " = "space",
    "v" = "success",
    "x" = "danger",
    "!" = "warning",
    "i" = "info",
    "*" = "bullet",
    ">" = "arrow"
  )))
})

test_that_cli("bullets glue", {
  expect_snapshot(cli_bullets(c(
    "noindent {.key {1:3}}",
    " " = "space {.key {1:3}}",
    "v" = "success {.key {1:3}}",
    "x" = "danger {.key {1:3}}",
    "!" = "warning {.key {1:3}}",
    "i" = "info {.key {1:3}}",
    "*" = "bullet {.key {1:3}}",
    ">" = "arrow {.key {1:3}}"
  )))
})

test_that_cli("bullets wrapping", {
  txt <- strrep("This is some text that is longer than the width. ", 3)
  expect_snapshot(cli_bullets(c(
    txt,
    " " = txt,
    "v" = txt,
    "x" = txt,
    "!" = txt,
    "i" = txt,
    "*" = txt,
    ">" = txt
  )))
})
