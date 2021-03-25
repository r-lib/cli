
start_app()
on.exit(stop_app(), add = TRUE)

test_that("simplest", {
  expect_snapshot({
    for (n in 0:2) cli_text("{n} package{?s}")
    for (n in 0:2) print(pluralize("{n} package{?s}"))
  })
})

test_that("irregular", {
  expect_snapshot({
    for (n in 0:2) cli_text("{n} dictionar{?y/ies}")
    for (n in 0:2) print(pluralize("{n} dictionar{?y/ies}"))
  })
})

test_that("multiple substitutions", {
  expect_snapshot({
    for (n in 0:2) cli_text("{n} package{?s} {?is/are} ...")
    for (n in 0:2) print(pluralize("{n} package{?s} {?is/are} ..."))
  })
})

test_that("multiple quantities", {
  expect_snapshot({
    for (m in 0:2) for (n in 0:2) cli_text("{m} package{?s} and {n} folder{?s}")
    for (m in 0:2) for (n in 0:2) print(pluralize("{m} package{?s} and {n} folder{?s}"))
  })
})

test_that("no()", {
  expect_snapshot({
    for (n in 0:2) cli_text("{no(n)} package{?s}")
    for (n in 0:2) print(pluralize("{no(n)} package{?s}"))
  })
})

test_that("set qty() explicitly", {
  expect_snapshot({
    for (n in 0:2) cli_text("{qty(n)}There {?is/are} {n} package{?s}")
    for (n in 0:2) print(pluralize("{qty(n)}There {?is/are} {n} package{?s}"))
  })
})

test_that("collapsing vectors", {
  expect_snapshot({
    pkgs <- function(n) glue("pkg{seq_len(n)}")
    for (n in 1:3) cli_text("The {pkgs(n)} package{?s}")
    for (n in 1:3) print(pluralize("The {pkgs(n)} package{?s}"))
  })
})

test_that("pluralization and style", {
  expect_snapshot({
    special_style <- list(span.foo = list(before = "<", after = ">"))
    cli_div(theme = special_style)
    for (n in 0:2) cli_text("{n} {.foo package{?s}}")
  })

  expect_snapshot({
    pkgs <- function(n) glue("pkg{seq_len(n)}")
    for (n in 1:3) cli_text("The {.foo {pkgs(n)}} package{?s}")
  })
})

test_that("post-processing", {
  expect_snapshot({
    for (n in 0:2) cli_text("Package{?s}: {n}")
  })

  expect_snapshot({
    pkgs <- function(n) glue("pkg{seq_len(n)}")
    for (n in 1:2) cli_text("Package{?s}: {pkgs(n)}")
    for (n in 1:2) print(pluralize("Package{?s}: {pkgs(n)}"))
  })
})

test_that("post-processing errors", {
  expect_error(
    cli_text("package{?s}"),
    "Cannot pluralize without a quantity"
  )
  expect_error(
    pluralize("package{?s}"),
    "Cannot pluralize without a quantity"
  )
  expect_error(
    cli_text("package{?s} {5} {10}"),
    "Multiple quantities for pluralization"
  )
  expect_error(
    pluralize("package{?s} {5} {10}"),
    "Multiple quantities for pluralization"
  )
})

test_that("issue 158", {
  expect_snapshot({
    print(pluralize("{0} word{?A/B/}"))
    print(pluralize("{1} word{?A/B/}"))
    print(pluralize("{9} word{?A/B/}"))
  })
})
