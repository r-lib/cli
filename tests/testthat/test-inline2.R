
start_app()
on.exit(stop_app(), add = TRUE)

test_that_cli(configs = c("plain", "ansi"), "collapsing class names", {
  expect_snapshot(local({
    cc <- c("one", "two")
    cli_text("this is a class: {.cls myclass}")
    cli_text("multiple classes: {.cls {cc}}")
  }))
})
