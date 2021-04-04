
start_app()
on.exit(stop_app(), add = TRUE)

test_that_cli("memo", {
  expect_snapshot(cli_memo(c(
          "noindent",
    " " = "space",
    "v" = "success",
    "x" = "danger",
    "!" = "warning",
    "i" = "info",
    "*" = "bullet"
  )))
})

test_that_cli("memo glue", {
  expect_snapshot(cli_memo(c(
          "noindent {.key {1:3}}",
    " " = "space {.key {1:3}}",
    "v" = "success {.key {1:3}}",
    "x" = "danger {.key {1:3}}",
    "!" = "warning {.key {1:3}}",
    "i" = "info {.key {1:3}}",
    "*" = "bullet {.key {1:3}}"
  )))
})
