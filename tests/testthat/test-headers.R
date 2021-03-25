
start_app()
on.exit(stop_app(), add = TRUE)

test_that_cli("headers", {
  expect_snapshot(local({
    cli_div(class = "testcli", theme = test_style())
    cli_h1("HEADER")
    cli_h2("Header")
    cli_h3("Header")
    x <- "foobar"
    xx <- 100
    cli_h2("{xx}. header: {x}")
  }))
})

test_that("issue #218", {
  expect_snapshot({
    cli_h1("one {1} two {2} three {3}")
    cli_h2("one {1} two {2} three {3}")
  })
})
